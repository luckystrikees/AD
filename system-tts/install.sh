#!/bin/bash
# ClaritySpeaks System TTS - Installation Script
# Sets up Python environment and downloads the Kokoro model

set -e  # Exit on error

echo "============================================"
echo "  ClaritySpeaks System TTS Installer"
echo "============================================"
echo ""

# Check Python version
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "✓ Python $PYTHON_VERSION detected"

# Check if Python 3.9+
python3 -c "import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)" 2>/dev/null || {
    echo "✗ Error: Python 3.9 or higher is required"
    exit 1
}

# Create virtual environment
VENV_DIR="$(pwd)/venv"
if [ -d "$VENV_DIR" ]; then
    echo "✓ Virtual environment already exists"
else
    echo "→ Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
    echo "✓ Virtual environment created"
fi

# Activate virtual environment
source "$VENV_DIR/bin/activate"

# Upgrade pip
echo "→ Upgrading pip..."
pip install --upgrade pip -q

# Install dependencies
echo "→ Installing Python dependencies..."
pip install -r requirements.txt

echo "✓ Dependencies installed"
echo ""

# Create cache directory
CACHE_DIR="$HOME/.cache/clarityspeaks-tts"
mkdir -p "$CACHE_DIR"
echo "✓ Cache directory created: $CACHE_DIR"
echo ""

# Test the installation
echo "→ Testing TTS engine..."
python3 tts_service.py --test

echo ""
echo "============================================"
echo "  Installation Complete!"
echo "============================================"
echo ""
echo "Usage:"
echo "  Run in foreground:  python3 tts_service.py"
echo "  List voices:        python3 tts_service.py --list-voices"
echo "  Change voice:       python3 tts_service.py --voice af_bella"
echo "  Change speed:       python3 tts_service.py --speed 1.2"
echo ""
echo "Default hotkey: Cmd+Shift+Space"
echo ""
echo "To install as background service (auto-start on login):"
echo "  ./install-launchd.sh"
echo ""
