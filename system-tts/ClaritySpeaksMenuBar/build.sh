#!/bin/bash
# Build the ClaritySpeaks MenuBar app from command line

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$SCRIPT_DIR/ClaritySpeaksMenuBar"
BUILD_DIR="$SCRIPT_DIR/build"
APP_NAME="ClaritySpeaksMenuBar.app"

echo "============================================"
echo "  Building ClaritySpeaks MenuBar App"
echo "============================================"
echo ""

# Check if Xcode command line tools are installed
if ! xcode-select -p &>/dev/null; then
    echo "✗ Error: Xcode command line tools not found"
    echo "  Install with: xcode-select --install"
    exit 1
fi

echo "✓ Xcode tools found"

# Clean previous build
if [ -d "$BUILD_DIR" ]; then
    echo "→ Cleaning previous build..."
    rm -rf "$BUILD_DIR"
fi

# Create build directory
mkdir -p "$BUILD_DIR"

# Build the app
echo "→ Building app..."
xcodebuild -project "$PROJECT_DIR/ClaritySpeaksMenuBar.xcodeproj" \
    -target ClaritySpeaksMenuBar \
    -configuration Release \
    CONFIGURATION_BUILD_DIR="$BUILD_DIR" \
    clean build

# Check if build succeeded
if [ ! -d "$BUILD_DIR/$APP_NAME" ]; then
    echo "✗ Build failed!"
    exit 1
fi

echo ""
echo "✓ Build successful!"
echo ""
echo "App location: $BUILD_DIR/$APP_NAME"
echo ""

# Ask if user wants to install to Applications
read -p "Install to /Applications? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Stop any running instance
    killall ClaritySpeaksMenuBar 2>/dev/null || true
    
    # Install
    if [ -d "/Applications/$APP_NAME" ]; then
        echo "→ Replacing existing app..."
        rm -rf "/Applications/$APP_NAME"
    fi
    
    cp -R "$BUILD_DIR/$APP_NAME" "/Applications/"
    echo "✓ Installed to /Applications/$APP_NAME"
    echo ""
    echo "You can now launch ClaritySpeaks from your menu bar!"
fi
