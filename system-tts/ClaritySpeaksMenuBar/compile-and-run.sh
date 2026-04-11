#!/bin/bash
# Compile and launch ClaritySpeaks MenuBar app

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR="$SCRIPT_DIR/build"
APP_BUNDLE="$BUILD_DIR/ClaritySpeaksMenuBar.app"
SDK_PATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"

echo "Compiling ClaritySpeaks MenuBar..."

swiftc \
    -target x86_64-apple-macosx13.0 \
    -sdk "$SDK_PATH" \
    -o "$APP_BUNDLE/Contents/MacOS/ClaritySpeaksMenuBar" \
    "$SCRIPT_DIR/ClaritySpeaksMenuBar/"*.swift \
    -framework AppKit \
    -framework SwiftUI \
    2>&1

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
    echo "Launching app..."
    open "$APP_BUNDLE"
else
    echo "✗ Compilation failed"
    exit 1
fi
