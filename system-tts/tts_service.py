#!/usr/bin/env python3
"""
ClaritySpeaks System TTS Service
Main orchestrator that ties together:
- Global hotkey listener (Cmd+Shift+Space)
- Text capture via AppleScript
- Kokoro TTS engine
- Audio playback via afplay

Usage:
    python tts_service.py          # Run in foreground
    python tts_service.py --daemon # Run as background daemon
"""

import os
import sys
import time
import signal
import argparse
import subprocess
import threading
from queue import Queue, Empty
from pathlib import Path

# Add current directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from tts_engine import TTSEngine, DEFAULT_VOICE, DEFAULT_SPEED
from hotkey_listener import HotkeyListener
from text_capture import get_selected_text, sanitize_text


# Configuration
AUDIO_CACHE_DIR = Path.home() / ".cache" / "clarityspeaks-tts"
MAX_QUEUE_SIZE = 10
DEFAULT_VOICE = 'af_bella'  # High-quality American female voice


class TTSService:
    """Main TTS service that orchestrates all components."""
    
    def __init__(self, voice=None, speed=None):
        """
        Initialize the TTS service.
        
        Args:
            voice: Default voice to use
            speed: Default speech speed
        """
        self.voice = voice or DEFAULT_VOICE
        self.speed = speed or DEFAULT_SPEED
        
        # Audio queue for handling rapid requests
        self.queue = Queue(maxsize=MAX_QUEUE_SIZE)
        
        # TTS engine (lazy initialization)
        self.engine = None
        
        # Hotkey listener
        self.hotkey_listener = None
        
        # Service state
        self._running = False
        self._is_speaking = False
        self._current_process = None
        
        # Create cache directory
        AUDIO_CACHE_DIR.mkdir(parents=True, exist_ok=True)
        
    def initialize(self):
        """Initialize the TTS engine (downloads model if needed)."""
        print("[Service] Initializing Kokoro TTS Engine...")
        self.engine = TTSEngine(voice=self.voice, speed=self.speed)
        self.engine.initialize()
        print(f"[Service] Ready! Voice: {self.voice}, Speed: {self.speed}")
        
    def start(self, daemon_mode=False):
        """Start the TTS service."""
        if not self.engine:
            self.initialize()
            
        self._running = True
        
        # Start hotkey listener
        self.hotkey_listener = HotkeyListener(self._on_hotkey)
        self.hotkey_listener.start()
        
        # Start queue processor
        self._queue_thread = threading.Thread(target=self._process_queue, daemon=True)
        self._queue_thread.start()
        
        print("\n" + "="*60)
        print("  ClaritySpeaks System TTS")
        print("  Press Cmd+Shift+Space to read selected text")
        print("  Press Ctrl+C to stop")
        print("="*60 + "\n")
        
        if daemon_mode:
            print("[Service] Running in background (daemon mode)")
        
        # Keep running
        try:
            while self._running:
                time.sleep(0.5)
        except KeyboardInterrupt:
            print("\n[Service] Shutting down...")
            self.stop()
            
    def stop(self):
        """Stop the TTS service."""
        self._running = False
        
        if self.hotkey_listener:
            self.hotkey_listener.stop()
            
        if self._current_process:
            self._current_process.terminate()
            
        print("[Service] Stopped.")
        
    def _on_hotkey(self):
        """Callback when hotkey is pressed."""
        if self._is_speaking:
            # If currently speaking, stop current playback
            print("[Service] Stopping playback...")
            if self._current_process:
                self._current_process.terminate()
                self._current_process = None
            self._is_speaking = False
            return
            
        # Capture selected text
        print("[Service] Hotkey pressed - capturing text...")
        text = get_selected_text()
        text = sanitize_text(text)
        
        if not text:
            print("[Service] No text captured")
            self._play_feedback_sound('error')
            return
            
        print(f"[Service] Captured: '{text[:50]}...'")
        
        # Add to queue
        try:
            self.queue.put_nowait(text)
            print(f"[Service] Queued ({self.queue.qsize()} items)")
        except:
            print("[Service] Queue full, skipping")
            self._play_feedback_sound('error')
            
    def _process_queue(self):
        """Process TTS requests from the queue."""
        while self._running:
            try:
                text = self.queue.get(timeout=1)
                self._is_speaking = True
                
                # Generate audio
                print(f"[Service] Generating speech...")
                output_path = AUDIO_CACHE_DIR / f"tts_{int(time.time())}.wav"
                
                try:
                    audio_file = self.engine.generate(text, output_path=str(output_path))
                    
                    # Play audio
                    print(f"[Service] Playing audio...")
                    self._play_feedback_sound('start')
                    self._current_process = subprocess.Popen(
                        ['afplay', audio_file],
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL
                    )
                    
                    # Wait for playback to finish
                    self._current_process.wait()
                    self._current_process = None
                    self._is_speaking = False
                    
                    # Clean up old audio files (keep last 5)
                    self._cleanup_old_audio()
                    
                except Exception as e:
                    print(f"[Service] Error generating speech: {e}")
                    self._play_feedback_sound('error')
                    self._is_speaking = False
                    
                self.queue.task_done()
                
            except Empty:
                continue
            except Exception as e:
                print(f"[Service] Queue processing error: {e}")
                
    def _play_feedback_sound(self, sound_type):
        """Play a short system feedback sound."""
        # Use macOS system sounds
        sound_map = {
            'start': '/System/Library/Sounds/Glass.aiff',
            'error': '/System/Library/Sounds/Basso.aiff',
        }
        
        sound_path = sound_map.get(sound_type)
        if sound_path and os.path.exists(sound_path):
            subprocess.run(
                ['afplay', sound_path],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
            
    def _cleanup_old_audio(self):
        """Remove old audio files, keeping only the most recent ones."""
        audio_files = sorted(AUDIO_CACHE_DIR.glob("tts_*.wav"), key=os.path.getmtime)
        if len(audio_files) > 5:
            for old_file in audio_files[:-5]:
                try:
                    old_file.unlink()
                except:
                    pass
                    
    def list_voices(self):
        """Print available voices."""
        if not self.engine:
            self.engine = TTSEngine()
            
        voices = self.engine.get_available_voices()
        print("\nAvailable Voices:")
        print("-" * 50)
        for voice_id, description in voices.items():
            default = " [DEFAULT]" if voice_id == DEFAULT_VOICE else ""
            print(f"  {voice_id:20s} - {description}{default}")
        print()


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(description='ClaritySpeaks System TTS')
    parser.add_argument('--voice', '-v', default=DEFAULT_VOICE,
                       help=f'Voice to use (default: {DEFAULT_VOICE})')
    parser.add_argument('--speed', '-s', type=float, default=DEFAULT_SPEED,
                       help=f'Speech speed (default: {DEFAULT_SPEED})')
    parser.add_argument('--list-voices', '-l', action='store_true',
                       help='List available voices')
    parser.add_argument('--daemon', '-d', action='store_true',
                       help='Run as background daemon')
    parser.add_argument('--test', '-t', action='store_true',
                       help='Run a quick test')
    
    args = parser.parse_args()
    
    # Handle list-voices
    if args.list_voices:
        service = TTSService()
        service.list_voices()
        return
        
    # Handle test mode
    if args.test:
        print("[Test] Running quick TTS test...")
        service = TTSService(voice=args.voice, speed=args.speed)
        service.initialize()
        
        test_text = "Hello! This is a test of the ClaritySpeaks system text-to-speech."
        output = service.engine.generate(test_text)
        
        print(f"[Test] Playing test audio: {output}")
        subprocess.run(['afplay', output])
        
        # Cleanup
        try:
            os.unlink(output)
        except:
            pass
            
        print("[Test] Complete!")
        return
        
    # Run service
    service = TTSService(voice=args.voice, speed=args.speed)
    
    # Handle graceful shutdown
    def signal_handler(sig, frame):
        print("\n[Service] Received shutdown signal")
        service.stop()
        sys.exit(0)
        
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    # Start service
    service.start(daemon_mode=args.daemon)


if __name__ == '__main__':
    main()
