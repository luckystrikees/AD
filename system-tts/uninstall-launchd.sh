#!/bin/bash
# Uninstall ClaritySpeaks TTS macOS background service

set -e

echo "============================================"
echo "  Uninstalling ClaritySpeaks TTS Service"
echo "============================================"
echo ""

LAUNCHD_DIR="$HOME/Library/LaunchAgents"
TARGET_PLIST="$LAUNCHD_DIR/com.clarityspeaks.tts.plist"

# Stop the service if running
if launchctl list | grep -q "com.clarityspeaks.tts"; then
    echo "→ Stopping service..."
    launchctl stop com.clarityspeaks.tts
    echo "✓ Service stopped"
fi

# Unload the service
if [ -f "$TARGET_PLIST" ]; then
    echo "→ Unloading service..."
    launchctl unload "$TARGET_PLIST" 2>/dev/null || true
    rm "$TARGET_PLIST"
    echo "✓ Service unloaded and plist removed"
fi

echo ""
echo "✓ Uninstallation Complete!"
echo ""
echo "The TTS service has been removed from auto-start."
echo "You can still run it manually with: python3 tts_service.py"
echo ""
