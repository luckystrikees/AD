#!/bin/bash
# Install ClaritySpeaks TTS as a macOS background service (auto-start on login)

set -e

echo "============================================"
echo "  Installing ClaritySpeaks TTS Service"
echo "============================================"
echo ""

# Get the absolute path to the current directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLIST_FILE="$SCRIPT_DIR/com.clarityspeaks.tts.plist"
LAUNCHD_DIR="$HOME/Library/LaunchAgents"
TARGET_PLIST="$LAUNCHD_DIR/com.clarityspeaks.tts.plist"

# Check if virtual environment exists
if [ ! -d "$SCRIPT_DIR/venv" ]; then
    echo "✗ Error: Virtual environment not found. Run install.sh first."
    exit 1
fi

# Update plist with correct paths
PYTHON_PATH="$SCRIPT_DIR/venv/bin/python3"
SERVICE_PATH="$SCRIPT_DIR/tts_service.py"

# Create LaunchAgents directory if it doesn't exist
mkdir -p "$LAUNCHD_DIR"

# Copy plist to LaunchAgents
cp "$PLIST_FILE" "$TARGET_PLIST"

# Update paths in the plist
sed -i '' "s|/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/system-tts|$SCRIPT_DIR|g" "$TARGET_PLIST"
sed -i '' "s|/Users/macbookpro16|$HOME|g" "$TARGET_PLIST"

echo "✓ Service plist installed to: $TARGET_PLIST"

# Load the service
echo "→ Loading service..."
launchctl load "$TARGET_PLIST" 2>/dev/null || true

echo ""
echo "============================================"
echo "  Service Installed Successfully!"
echo "============================================"
echo ""
echo "The TTS service will now start automatically on login."
echo ""
echo "To start it now: launchctl start com.clarityspeaks.tts"
echo "To stop it:      launchctl stop com.clarityspeaks.tts"
echo "To uninstall:    ./uninstall-launchd.sh"
echo ""
echo "Hotkey: Cmd+Shift+Space"
echo ""
