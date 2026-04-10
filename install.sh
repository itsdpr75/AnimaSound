#!/bin/bash
# AnimaSound Installation Script
# This script installs all necessary dependencies

set -e  # Exit on error

echo "🎵 AnimaSound - Installing dependencies..."
echo ""

# Check if we're in a virtual environment
if [ -z "$VIRTUAL_ENV" ]; then
    echo "⚠️  Warning: No virtual environment detected."
    echo "    It's recommended to install in a virtual environment."
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "📦 Upgrading pip..."
python -m pip install --upgrade pip

echo ""
echo "📦 Installing core dependencies..."
python -m pip install \
    PySide6 \
    librosa \
    numpy \
    scipy \
    matplotlib \
    soundfile \
    audioread \
    qtawesome

echo ""
echo "📦 Installing development dependencies..."
python -m pip install \
    pyinstaller \
    pytest

echo ""
echo "✅ All dependencies installed successfully!"
echo ""
echo "To run the application:"
echo "  python scripts/run.py"
echo ""
echo "Or test QML loading only:"
echo "  python scripts/test_qml.py"
echo ""
