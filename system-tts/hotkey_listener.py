#!/usr/bin/env python3
"""
Global Hotkey Listener
Listens for Cmd+Shift+Space to trigger TTS generation.
Uses pynput for cross-platform keyboard event handling.
"""

import threading
import time
from pynput import keyboard


# Hotkey configuration
HOTKEY_MODIFIERS = {keyboard.Key.cmd, keyboard.Key.shift}
HOTKEY_KEY = keyboard.Key.space
HOTKEY_NAME = "Cmd+Shift+Space"


class HotkeyListener:
    """Listens for global hotkey combinations."""
    
    def __init__(self, callback):
        """
        Initialize the hotkey listener.
        
        Args:
            callback: Function to call when hotkey is pressed
        """
        self.callback = callback
        self.listener = None
        self._modifiers_pressed = set()
        self._running = False
        
    def start(self):
        """Start listening for the hotkey."""
        self._running = True
        self.listener = keyboard.Listener(
            on_press=self._on_press,
            on_release=self._on_release,
            suppress=False  # Don't block the hotkey from other uses
        )
        self.listener.start()
        print(f"[Hotkey] Listening for {HOTKEY_NAME}...")
        
    def stop(self):
        """Stop listening for the hotkey."""
        self._running = False
        if self.listener:
            self.listener.stop()
            self.listener = None
        print("[Hotkey] Listener stopped.")
        
    def _on_press(self, key):
        """Handle key press events."""
        self._modifiers_pressed.add(key)
        
        # Check if hotkey combination is pressed
        if (key == HOTKEY_KEY and 
            keyboard.Key.cmd in self._modifiers_pressed and 
            keyboard.Key.shift in self._modifiers_pressed):
            self.callback()
            
    def _on_release(self, key):
        """Handle key release events."""
        self._modifiers_pressed.discard(key)
        
    def is_running(self):
        """Check if the listener is running."""
        return self._running


if __name__ == '__main__':
    # Test the hotkey listener
    def on_hotkey():
        print("🔥 Hotkey pressed!")
    
    listener = HotkeyListener(on_hotkey)
    listener.start()
    
    print(f"Press {HOTKEY_NAME} to trigger. Press Ctrl+C to exit.")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        listener.stop()
        print("Exiting.")
