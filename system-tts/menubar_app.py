#!/usr/bin/env python3
"""
ClaritySpeaks MenuBar App
macOS native menubar app using rumps (Rubberband User Menu bar Python System).
"""

import os
import sys
import json
import subprocess
import threading
from pathlib import Path

import rumps

# Config path
CONFIG_DIR = Path.home() / ".cache" / "clarityspeaks-tts"
CONFIG_FILE = CONFIG_DIR / "config.json"

# Default settings
DEFAULTS = {
    "voice": "af_bella",
    "speed": 1.0,
    "hotkey_enabled": True,
    "auto_start": False,
}

# Voice definitions
VOICES = [
    ("af_heart", "❤️ Heart (US Female)"),
    ("af_alloy", "Alloy (US Female)"),
    ("af_aoede", "Aoede (US Female)"),
    ("af_bella", "🔥 Bella (US Female)"),
    ("af_jessica", "Jessica (US Female)"),
    ("af_kore", "Kore (US Female)"),
    ("af_nicole", "🎧 Nicole (US Female)"),
    ("af_nova", "Nova (US Female)"),
    ("af_river", "River (US Female)"),
    ("af_sarah", "Sarah (US Female)"),
    ("af_sky", "Sky (US Female)"),
    ("am_adam", "Adam (US Male)"),
    ("am_echo", "Echo (US Male)"),
    ("am_eric", "Eric (US Male)"),
    ("am_fenrir", "Fenrir (US Male)"),
    ("am_liam", "Liam (US Male)"),
    ("am_michael", "Michael (US Male)"),
    ("am_onyx", "Onyx (US Male)"),
    ("am_puck", "Puck (US Male)"),
    ("am_santa", "Santa (US Male)"),
    ("bf_emma", "Emma (UK Female)"),
    ("bf_isabella", "Isabella (UK Female)"),
    ("bf_alice", "Alice (UK Female)"),
    ("bf_lily", "Lily (UK Female)"),
    ("bm_george", "George (UK Male)"),
    ("bm_lewis", "Lewis (UK Male)"),
    ("bm_daniel", "Daniel (UK Male)"),
    ("bm_fable", "Fable (UK Male)"),
]

SPEEDS = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]


class Settings:
    """Manages app settings with JSON persistence."""
    
    def __init__(self):
        self._data = DEFAULTS.copy()
        self._load()
    
    def _load(self):
        if CONFIG_FILE.exists():
            try:
                with open(CONFIG_FILE) as f:
                    self._data.update(json.load(f))
            except:
                pass
    
    def save(self):
        CONFIG_DIR.mkdir(parents=True, exist_ok=True)
        with open(CONFIG_FILE, 'w') as f:
            json.dump(self._data, f, indent=2)
    
    @property
    def voice(self):
        return self._data.get("voice", DEFAULTS["voice"])
    
    @voice.setter
    def voice(self, value):
        self._data["voice"] = value
        self.save()
    
    @property
    def speed(self):
        return self._data.get("speed", DEFAULTS["speed"])
    
    @speed.setter
    def speed(self, value):
        self._data["speed"] = value
        self.save()
    
    @property
    def auto_start(self):
        return self._data.get("auto_start", DEFAULTS["auto_start"])
    
    @auto_start.setter
    def auto_start(self, value):
        self._data["auto_start"] = value
        self.save()


class TTSService:
    """Manages the Python TTS backend process."""
    
    def __init__(self):
        self.process = None
        self._running = False
    
    @property
    def is_running(self):
        return self._running and self.process and self.process.poll() is None
    
    def start(self):
        if self.is_running:
            return
        
        script_dir = Path(__file__).parent
        tts_service = script_dir / "tts_service.py"
        venv_python = script_dir / "venv" / "bin" / "python3"
        
        python_path = str(venv_python) if venv_python.exists() else sys.executable
        
        if not tts_service.exists():
            rumps.notification("ClaritySpeaks", "Error", "TTS service not found")
            return
        
        try:
            self.process = subprocess.Popen(
                [python_path, str(tts_service), "--daemon"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            self._running = True
        except Exception as e:
            rumps.notification("ClaritySpeaks", "Error", str(e))
    
    def stop(self):
        if self.process and self.is_running:
            self.process.terminate()
            self._running = False
    
    def test_speech(self):
        def _speak():
            subprocess.run(
                ["/usr/bin/say", "Hello! This is a test of ClaritySpeaks text-to-speech."],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
        threading.Thread(target=_speak, daemon=True).start()


class ClaritySpeaksApp(rumps.App):
    """Main menubar app."""
    
    def __init__(self):
        self.settings = Settings()
        self.tts = TTSService()
        
        super().__init__(
            name="ClaritySpeaks",
            title="🔊",
            quit_button=None,
        )
        
        # Build menu
        self.menu = [
            rumps.MenuItem("ClaritySpeaks TTS", callback=None),
            None,
            self._build_status_item(),
            None,
            self._build_service_toggle(),
            rumps.MenuItem("🎤 Test Speech", callback=self.test_speech),
            None,
            self._build_voice_menu(),
            self._build_speed_menu(),
            None,
            rumps.MenuItem("Settings…", callback=self.open_settings),
            None,
            rumps.MenuItem("Quit", callback=self.quit_app),
        ]
        
        # Auto-start if configured
        if self.settings.auto_start:
            self.tts.start()
    
    def _build_status_item(self):
        status = "● Running" if self.tts.is_running else "○ Stopped"
        return rumps.MenuItem(status, callback=None)
    
    def _build_service_toggle(self):
        if self.tts.is_running:
            return rumps.MenuItem("⏹ Stop Service", callback=self.toggle_service)
        else:
            return rumps.MenuItem("▶ Start Service", callback=self.toggle_service)
    
    def _build_voice_menu(self):
        voice_menu = rumps.MenuItem("Voice")
        
        for voice_id, voice_name in VOICES:
            item = rumps.MenuItem(voice_name, callback=self.select_voice)
            item._voice_id = voice_id
            if self.settings.voice == voice_id:
                item.state = True
            voice_menu.add(item)
        
        return voice_menu
    
    def _build_speed_menu(self):
        speed_menu = rumps.MenuItem("Speed")
        
        for speed in SPEEDS:
            item = rumps.MenuItem(f"{speed:.2f}x", callback=self.select_speed)
            item._speed = speed
            if abs(self.settings.speed - speed) < 0.01:
                item.state = True
            speed_menu.add(item)
        
        return speed_menu
    
    @rumps.clicked("▶ Start Service")
    @rumps.clicked("⏹ Stop Service")
    def toggle_service(self, sender):
        if self.tts.is_running:
            self.tts.stop()
        else:
            self.tts.start()
        self._update_menu()
    
    @rumps.clicked("🎤 Test Speech")
    def test_speech(self, sender):
        self.tts.test_speech()
    
    def select_voice(self, sender):
        voice_id = sender._voice_id
        self.settings.voice = voice_id
        
        # Update checkmarks
        voice_menu = None
        for item in self.menu:
            if isinstance(item, rumps.MenuItem) and item.title == "Voice":
                voice_menu = item
                break
        
        if voice_menu:
            for item in voice_menu:
                if isinstance(item, rumps.MenuItem):
                    item.state = (getattr(item, '_voice_id', None) == voice_id)
    
    def select_speed(self, sender):
        speed = sender._speed
        self.settings.speed = speed
        
        # Update checkmarks
        speed_menu = None
        for item in self.menu:
            if isinstance(item, rumps.MenuItem) and item.title == "Speed":
                speed_menu = item
                break
        
        if speed_menu:
            for item in speed_menu:
                if isinstance(item, rumps.MenuItem):
                    item.state = (abs(getattr(item, '_speed', 0) - speed) < 0.01)
    
    @rumps.clicked("Settings…")
    def open_settings(self, sender):
        if not CONFIG_FILE.exists():
            self.settings.save()
        subprocess.run(["open", str(CONFIG_FILE)])
    
    def quit_app(self, sender):
        self.tts.stop()
        rumps.quit()
    
    def _update_menu(self):
        """Rebuild menu to reflect state changes."""
        status = "● Running" if self.tts.is_running else "○ Stopped"
        
        # Find and update status item
        for i, item in enumerate(self.menu):
            if isinstance(item, rumps.MenuItem):
                if item.title in ["● Running", "○ Stopped"]:
                    self.menu[i] = rumps.MenuItem(status, callback=None)
                elif item.title in ["▶ Start Service", "⏹ Stop Service"]:
                    if self.tts.is_running:
                        self.menu[i] = rumps.MenuItem("⏹ Stop Service", callback=self.toggle_service)
                    else:
                        self.menu[i] = rumps.MenuItem("▶ Start Service", callback=self.toggle_service)


if __name__ == "__main__":
    print("ClaritySpeaks MenuBar app starting...")
    app = ClaritySpeaksApp()
    app.run()
