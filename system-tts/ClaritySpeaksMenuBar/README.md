# ClaritySpeaks MenuBar App

A native macOS menu bar application for controlling the ClaritySpeaks TTS system.

## Features

- **Menu Bar Control**: Quick access to TTS settings from your menu bar
- **Voice Selection**: Choose from 28 AI voices (American/British, Female/Male)
- **Speed Control**: Adjustable speech speed (0.5x - 2.0x) with presets
- **Service Status**: See if the TTS service is running at a glance
- **Quick Actions**: Test speech, stop speaking, restart service
- **Settings Window**: Full configuration panel with tabs

## Screenshots

The app adds a waveform icon to your menu bar:
```
🔊 ClaritySpeaks Menu
├── Status: ● Running
├── Test Speech
├── Stop Speaking
├── Voice ▸
│   ├── Heart (American Female)
│   ├── Bella (American Female)
│   └── ...
├── Speed ▸
│   ├── 0.50x
│   ├── 1.00x
│   └── 2.00x
├── Settings…
└── Quit
```

## Building

### Prerequisites

- macOS 13.0+ (Ventura or later)
- Xcode 15.0+ or Command Line Tools

### Build from Command Line

```bash
./build.sh
```

### Build in Xcode

1. Open `ClaritySpeaksMenuBar.xcodeproj`
2. Select your signing team in Signing & Capabilities
3. Press `Cmd+R` to run

## Installation

### Option 1: Build Script
```bash
./build.sh
# Answer 'y' when prompted to install to /Applications
```

### Option 2: Manual
```bash
# Build
xcodebuild -project ClaritySpeaksMenuBar.xcodeproj -target ClaritySpeaksMenuBar -configuration Release

# Copy to Applications
cp -R build/ClaritySpeaksMenuBar.app /Applications/
```

## Usage

1. **Launch the app** from /Applications or Spotlight
2. **Find the waveform icon** (🔊) in your menu bar
3. **Click the icon** to access the menu:
   - Check service status
   - Test speech
   - Change voice/speed
   - Open Settings

### Settings Window

Open via `Menu > Settings…` or `Cmd+,`

**Tab 1: General**
- Service start/stop
- Hotkey toggle
- Auto-start on login
- Notifications

**Tab 2: Voices**
- Voice selection (grouped by region)
- Speed slider with presets

**Tab 3: Advanced**
- Service paths
- Log access
- Troubleshooting buttons

## Permissions

The app requires:

1. **Accessibility**: For global hotkey monitoring
2. **Apple Events**: To capture selected text from other apps

Grant these in **System Settings > Privacy & Security**.

## File Structure

```
ClaritySpeaksMenuBar/
├── ClaritySpeaksMenuBar.xcodeproj/
│   └── project.pbxproj
├── ClaritySpeaksMenuBar/
│   ├── ClaritySpeaksMenuBarApp.swift  # App entry point + menu bar
│   ├── SettingsManager.swift          # Settings persistence
│   ├── SpeechService.swift            # Python service bridge
│   ├── SettingsView.swift             # Settings window UI
│   ├── Info.plist                     # App configuration
│   └── Assets.xcassets/               # App icons/colors
└── build.sh                           # Build script
```

## Architecture

```
MenuBar App (Swift)          Python TTS Service
┌─────────────────┐          ┌──────────────────┐
│  Menu Bar Icon  │          │  tts_service.py  │
│       ↓         │          │        ↓         │
│  SettingsManager│◄────────►│  tts_engine.py   │
│       ↓         │  config  │        ↓         │
│ SpeechService   │─────────►│  hotkey_listener │
│       ↓         │  stdout  │        ↓         │
│  SettingsView   │          │  text_capture.py │
└─────────────────┘          └──────────────────┘
```

**Communication Flow:**
1. Swift app writes config to `~/.cache/clarityspeaks-tts/config.json`
2. Python service reads config on startup
3. Swift app launches Python service as subprocess
4. Service output parsed for status updates

## Troubleshooting

**App won't launch:**
- Check Console.app for crash logs
- Ensure macOS 13.0+ is installed

**Service not found:**
- Update `findServicePath()` in `SpeechService.swift` with your path
- Default: `/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/system-tts/tts_service.py`

**Hotkey not working:**
- Grant Accessibility permissions
- Check for hotkey conflicts in System Settings

## Development

### Run from Xcode
```bash
open ClaritySpeaksMenuBar.xcodeproj
# Cmd+R to run
```

### Clean Build
```bash
rm -rf build/
./build.sh
```

## License

Part of the ClaritySpeaks TTS project.
