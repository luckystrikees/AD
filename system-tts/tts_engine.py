#!/usr/bin/env python3
"""
Kokoro TTS Engine
Uses the onnx-community/Kokoro-82M-ONNX model for high-quality text-to-speech.
Generates WAV audio files from text input.
"""

import os
import tempfile
import wave
import numpy as np
from pathlib import Path
from kokoro import KPipeline

# Voice definitions (matching the web app)
VOICES = {
    # American Female
    'af_heart': 'American female voice with heart trait',
    'af_alloy': 'American female voice, quality B',
    'af_aoede': 'American female voice, quality B',
    'af_bella': 'American female voice with fire trait',
    'af_jessica': 'American female voice, quality C',
    'af_kore': 'American female voice, quality B',
    'af_nicole': 'American female voice with headphones trait',
    'af_nova': 'American female voice, quality B',
    'af_river': 'American female voice, quality C',
    'af_sarah': 'American female voice, quality B',
    'af_sky': 'American female voice, quality B',
    # American Male
    'am_adam': 'American male voice, quality D',
    'am_echo': 'American male voice, quality C',
    'am_eric': 'American male voice, quality C',
    'am_fenrir': 'American male voice, quality B',
    'am_liam': 'American male voice, quality C',
    'am_michael': 'American male voice, quality B',
    'am_onyx': 'American male voice, quality C',
    'am_puck': 'American male voice, quality B',
    'am_santa': 'American male voice, quality C',
    # British Female
    'bf_emma': 'British female voice, quality B',
    'bf_isabella': 'British female voice, quality B',
    'bf_alice': 'British female voice',
    'bf_lily': 'British female voice',
    # British Male
    'bm_george': 'British male voice, quality B',
    'bm_lewis': 'British male voice, quality C',
    'bm_daniel': 'British male voice',
    'bm_fable': 'British male voice',
}

# Default settings
DEFAULT_VOICE = 'af_bella'
DEFAULT_SPEED = 1.0
SAMPLE_RATE = 24000


class TTSEngine:
    """Kokoro-based TTS engine with ONNX backend."""
    
    def __init__(self, voice=None, speed=None, model_path=None):
        """
        Initialize the TTS engine.
        
        Args:
            voice: Voice ID to use (default: af_bella)
            speed: Speech speed multiplier (default: 1.0)
            model_path: Path to cached model (optional, uses HF cache)
        """
        self.voice = voice or DEFAULT_VOICE
        self.speed = speed or DEFAULT_SPEED
        self.pipeline = None
        self._initialized = False
        
        print(f"[TTS Engine] Initializing with voice: {self.voice}, speed: {self.speed}")
        
    def initialize(self):
        """Load the Kokoro model. Call once before generating speech."""
        if self._initialized:
            return
            
        try:
            print("[TTS Engine] Loading Kokoro model (first run downloads ~300MB)...")
            # KPipeline automatically uses ONNX backend
            # It will download from onnx-community/Kokoro-82M-ONNX if not cached
            self.pipeline = KPipeline(lang_code='a')  # 'a' for American English
            self._initialized = True
            print("[TTS Engine] Model loaded successfully!")
        except Exception as e:
            print(f"[TTS Engine] Error loading model: {e}")
            raise
    
    def generate(self, text, output_path=None, voice=None, speed=None):
        """
        Generate speech from text.
        
        Args:
            text: Text to convert to speech
            output_path: Path to save WAV file (default: temp file)
            voice: Override default voice
            speed: Override default speed
            
        Returns:
            Path to generated WAV file
        """
        if not self._initialized:
            self.initialize()
            
        voice = voice or self.voice
        speed = speed or self.speed
        
        # Sanitize text
        text = self._sanitize_text(text)
        if not text:
            text = "Hello."
        
        print(f"[TTS Engine] Generating: '{text[:50]}...' (voice: {voice}, speed: {speed})")
        
        # Generate audio using KPipeline
        # The pipeline yields (graphemes, phonemes, audio) tuples
        audio_segments = []
        
        for _, _, audio in self.pipeline(text, voice=voice, speed=speed):
            if audio is not None:
                audio_segments.append(audio)
        
        if not audio_segments:
            raise ValueError("No audio generated from text")
        
        # Concatenate audio segments
        full_audio = np.concatenate(audio_segments)
        
        # Create output path if not provided
        if output_path is None:
            fd, output_path = tempfile.mkstemp(suffix='.wav')
            os.close(fd)
        
        # Save as WAV file
        self._save_wav(output_path, full_audio, SAMPLE_RATE)
        
        print(f"[TTS Engine] Saved audio to: {output_path}")
        return output_path
    
    def _sanitize_text(self, text):
        """Sanitize input text for TTS."""
        if not text:
            return ""
        
        # Remove control characters
        text = ''.join(c for c in text if ord(c) >= 32 or c in '\n\r\t')
        
        # Replace multiple whitespace with single space
        import re
        text = re.sub(r'\s+', ' ', text)
        
        # Truncate to reasonable length
        text = text[:1000]
        
        return text.strip()
    
    def _save_wav(self, path, audio, sample_rate):
        """Save audio array as WAV file."""
        # Normalize audio to 16-bit range
        audio = np.clip(audio, -1.0, 1.0)
        audio_int16 = (audio * 32767).astype(np.int16)
        
        with wave.open(path, 'wb') as wf:
            wf.setnchannels(1)  # Mono
            wf.setsampwidth(2)  # 16-bit
            wf.setframerate(sample_rate)
            wf.writeframes(audio_int16.tobytes())
    
    def get_available_voices(self):
        """Return dict of available voices with descriptions."""
        return VOICES.copy()
    
    def cleanup(self):
        """Release resources."""
        self.pipeline = None
        self._initialized = False


if __name__ == '__main__':
    # Test the engine
    engine = TTSEngine(voice='af_bella')
    engine.initialize()
    
    test_text = "Hello! This is a test of the Kokoro text-to-speech engine."
    output = engine.generate(test_text)
    print(f"Test audio saved to: {output}")
    
    # Play the audio
    import subprocess
    subprocess.run(['afplay', output])
    
    # Cleanup
    os.unlink(output)
    engine.cleanup()
    print("Test complete!")
