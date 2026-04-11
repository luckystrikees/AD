# ClaritySpeaks System TTS

System-wide text-to-speech for macOS using **Kokoro AI voices** (same model as your ClaritySpeaks web app).

## Features

- **High-quality AI voices** using `onnx-community/Kokoro-82M-ONNX`
- **System-wide hotkey**: Press `Cmd+Shift+Space` anywhere to read selected text
- **28 voices**: American (female/male), British (female/male)
- **Adjustable speed**: 0.5x to 2.0x
- **Background service**: Runs silently, auto-starts on login
- **Queue management**: Handles rapid successive requests
- **Menu Bar App**: Native macOS app for easy settings control (see `ClaritySpeaksMenuBar/`)

## Quick Start

### 1. Install

```bash
./install.sh
```

This creates a virtual environment, installs dependencies, and runs a test.

### 2. Run

```bash
# Foreground mode (for testing)
python3 tts_service.py

# Background service (auto-start on login)
./install-launchd.sh
```

### 3. Use

1. Select text in any app
2. Press `Cmd+Shift+Space`
3. Hear AI voice read the text
4. Press `Cmd+Shift+Space` again to stop playback

## Available Voices

| Voice ID | Description |
|----------|-------------|
| `af_bella` | American female, quality B (default) |
| `af_heart` | American female, heart trait |
| `af_nicole` | American female, headphones trait |
| `am_michael` | American male, quality B |
| `bf_emma` | British female, quality B |
| `bm_george` | British male, quality B |

List all voices: `python3 tts_service.py --list-voices`

## Configuration

```bash
# Change voice
python3 tts_service.py --voice am_michael

# Change speed
python3 tts_service.py --speed 1.2

# Both
python3 tts_service.py --voice af_bella --speed 0.9
```

## Service Management

```bash
# Start service
launchctl start com.clarityspeaks.tts

# Stop service
launchctl stop com.clarityspeaks.tts

# Uninstall from auto-start
./uninstall-launchd.sh
```

## Logs

- Service log: `~/.cache/clarityspeaks-tts/tts-service.log`
- Error log: `~/.cache/clarityspeaks-tts/tts-service-error.log`

## File Structure

```
system-tts/
├── tts_engine.py          # Kokoro TTS engine
├── hotkey_listener.py     # Global hotkey (pynput)
├── text_capture.py        # AppleScript text capture
├── tts_service.py         # Main orchestrator
├── requirements.txt       # Python dependencies
├── install.sh             # Setup script
├── install-launchd.sh     # Install as background service
├── uninstall-launchd.sh   # Remove background service
├── com.clarityspeaks.tts.plist  # macOS launchd config
└── README.md              # This file
```

## Troubleshooting

### No text captured
- Grant **Accessibility permissions** to Terminal/iTerm in System Settings > Privacy & Security > Accessibility
- Some apps don't support text selection via clipboard

### Hotkey not working
- Check for hotkey conflicts in System Settings > Keyboard > Keyboard Shortcuts
- Try running in foreground mode to see debug output

### Model download takes too long
- First run downloads ~300MB model to `~/.cache/huggingface`
- Subsequent runs use cached model (instant)

### Audio sounds gurgled
- Check sample rate (should be 24000)
- Try different voice

## Requirements

- macOS 12+ (Monterey or later)
- Python 3.9+
- Internet connection (first run only, for model download)
