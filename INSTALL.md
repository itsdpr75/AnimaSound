# AnimaSound - Complete Installation Guide

## Quick Install

### Option 1: Automated Installation (Recommended)

```bash
cd /home/noha/Documentos/animasound2
./install.sh
```

### Option 2: Manual Installation

```bash
cd /home/noha/Documentos/animasound2

# Upgrade pip
pip install --upgrade pip

# Install all dependencies
pip install -r requirements.txt
```

### Option 3: Install in Development Mode

```bash
cd /home/noha/Documentos/animasound2
pip install -e .
```

## Step-by-Step Installation

### 1. Verify Python Version

Make sure you have Python 3.11:

```bash
python --version
# Should show: Python 3.11.x
```

If you don't have Python 3.11, install it:

```bash
# For Arch Linux/Garuda
sudo pacman -S python3.11

# Create virtual environment with Python 3.11
python3.11 -m venv venv
source venv/bin/activate
```

### 2. Activate Virtual Environment

Since you already have a venv, make sure it's activated:

```bash
cd /home/noha/Documentos/animasound2
source venv/bin/activate
```

You should see `(venv)` in your prompt.

### 3. Install Dependencies

Install all required packages:

```bash
pip install --upgrade pip
pip install PySide6 librosa numpy scipy matplotlib soundfile audioread qtawesome
```

Or use the requirements file:

```bash
pip install -r requirements.txt
```

### 4. Verify Installation

Test if the core packages are installed:

```bash
python -c "import PySide6; print('PySide6:', PySide6.__version__)"
python -c "import librosa; print('librosa:', librosa.__version__)"
python -c "import numpy; print('numpy:', numpy.__version__)"
python -c "import matplotlib; print('matplotlib:', matplotlib.__version__)"
```

### 5. Test QML Loading

Before running the full application, test QML loading:

```bash
python scripts/test_qml.py
```

This should open a window without errors.

### 6. Run the Application

```bash
python scripts/run.py
```

## Troubleshooting

### Issue: "No module named 'librosa'"

**Solution:**
```bash
pip install librosa
```

### Issue: "No module named 'PySide6'"

**Solution:**
```bash
pip install PySide6
```

This is a large package (~600MB), so it may take a while to download.

### Issue: QML Syntax Error

If you see QML syntax errors, the QML file has been fixed. Just run:

```bash
python scripts/run.py
```

### Issue: "QQmlApplicationEngine failed to load component"

**Solutions:**
1. Make sure you're running from the project root
2. Check that qml/Main.qml exists
3. Try the test script first: `python scripts/test_qml.py`

### Issue: Import errors for other modules

Install missing modules one by one:

```bash
pip install numpy scipy matplotlib soundfile audioread qtawesome
```

### Issue: Installation is slow

Some packages are large. PySide6 alone is ~600MB. Be patient during installation.

You can also try using a faster mirror:

```bash
pip install --no-cache-dir PySide6
```

### Issue: Conflicting packages

If you have conflicting packages installed, create a fresh virtual environment:

```bash
cd /home/noha/Documentos/animasound2
rm -rf venv
python3.11 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

## System Dependencies (Linux)

Some audio libraries may need to be installed:

```bash
# For Arch Linux/Garuda
sudo pacman -S portaudio pipewire pulseaudio-alsa

# For Ubuntu/Debian
sudo apt install portaudio19-dev libasound2-dev

# For Fedora
sudo dnf install portaudio-devel
```

## Verifying the Installation

Run this comprehensive check:

```bash
python -c "
import sys
print('Python version:', sys.version)

try:
    import PySide6
    print('✓ PySide6:', PySide6.__version__)
except:
    print('✗ PySide6 not installed')

try:
    import librosa
    print('✓ librosa:', librosa.__version__)
except:
    print('✗ librosa not installed')

try:
    import numpy
    print('✓ numpy:', numpy.__version__)
except:
    print('✗ numpy not installed')

try:
    import scipy
    print('✓ scipy:', scipy.__version__)
except:
    print('✗ scipy not installed')

try:
    import matplotlib
    print('✓ matplotlib:', matplotlib.__version__)
except:
    print('✗ matplotlib not installed')

try:
    import soundfile
    print('✓ soundfile installed')
except:
    print('✗ soundfile not installed')

try:
    import qtawesome
    print('✓ qtawesome installed')
except:
    print('✗ qtawesome not installed')
"
```

## Running the Application

### Development Mode

```bash
cd /home/noha/Documentos/animasound2
python scripts/run.py
```

### Test QML Only

```bash
python scripts/test_qml.py
```

### Direct Module Execution

```bash
python -m anima.main
```

## What to Expect

When the application runs successfully:

1. A modern dark-themed window opens
2. You see the AnimaSound logo and title
3. There's a drop zone for audio files
4. The window has standard minimize/maximize/close buttons
5. You can browse for audio files using the "Browse Files" button

## Next Steps After Installation

1. **Test with an audio file**: Drag and drop or browse for an audio file
2. **View analysis**: The app will automatically analyze the audio
3. **Try effects**: Use the left panel to apply effects
4. **View visualizations**: Switch between different chart types

## Uninstallation

To remove the application and dependencies:

```bash
# Deactivate virtual environment
deactivate

# Remove virtual environment (if desired)
rm -rf /home/noha/Documentos/animasound2/venv

# Or remove specific packages
pip uninstall PySide6 librosa numpy scipy matplotlib soundfile qtawesome
```

## Getting Help

If you encounter issues:

1. Check the error message in the terminal
2. Verify all dependencies are installed
3. Make sure you're using Python 3.11
4. Try the test script: `python scripts/test_qml.py`
5. Check that your virtual environment is activated

---

**Need more help?** Check the README.md file for detailed documentation.
