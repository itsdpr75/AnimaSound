# AnimaSound - Quick Start Guide

## Installation Steps

### 1. Install System Dependencies (Linux)

```bash
# For Ubuntu/Debian-based systems
sudo apt update
sudo apt install python3.11 python3.11-venv python3.11-dev

# For Arch Linux
sudo pacman -S python3.11

# For Fedora
sudo dnf install python3.11 python3.11-devel
```

### 2. Create and Activate Virtual Environment

```bash
cd /home/noha/Documentos/animasound2
python3.11 -m venv venv
source venv/bin/activate
```

### 3. Install Python Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

Or install in development mode:

```bash
pip install -e .
```

### 4. Run the Application

```bash
# From the project directory
python scripts/run.py

# Or using the module directly
python -m anima.main
```

## Testing the Application

### Test with a Sample Audio File

1. **Prepare a test audio file**:
   - Use any WAV, MP3, FLAC, OGG, or M4A file
   - You can download sample files from: https://www.kozco.com/tech/piper25.html

2. **Launch the application**:
   ```bash
   python scripts/run.py
   ```

3. **Load the audio file**:
   - Drag and drop the file onto the drop zone, OR
   - Click "Browse Files" and select the file

4. **View the analysis**:
   - Audio information will be displayed (duration, sample rate, channels)
   - Automatic analysis runs in the background

5. **Apply effects**:
   - Try time stretching, pitch shifting, or other effects from the left panel
   - Adjust parameters and click "Apply"

6. **Visualize**:
   - Switch between different chart types using the tabs at the top
   - View waveform, spectrogram, mel spectrogram, chroma, or tempogram

## Building Standalone Executable

```bash
# Install PyInstaller if not already installed
pip install pyinstaller

# Run the build script
python scripts/build.py
```

The executable will be created in `dist/AnimaSound`.

## Troubleshooting

### Issue: "No module named 'PySide6'"
```bash
pip install PySide6
```

### Issue: "librosa import error"
```bash
pip install librosa numpy scipy soundfile audioread
```

### Issue: "matplotlib backend error"
```bash
pip install matplotlib
```

### Issue: Application window doesn't appear
- Check if you have a display server running
- Try setting the display: `export DISPLAY=:0`
- Check for errors in the terminal output

### Issue: Audio files won't load
- Install ffmpeg for better audio format support:
  ```bash
  sudo apt install ffmpeg  # Ubuntu/Debian
  sudo pacman -S ffmpeg    # Arch
  sudo dnf install ffmpeg  # Fedora
  ```

## Environment Variables (Optional)

```bash
# Set Qt platform plugin (if needed)
export QT_QPA_PLATFORM=xcb

# Enable Qt debugging
export QT_LOGGING_RULES="*.debug=true"

# Set matplotlib backend
export MPLBACKEND=Agg
```

## Performance Tips

1. **Use mono audio** for faster analysis when stereo is not needed
2. **Reduce sample rate** if processing is slow (resample to 22050 Hz)
3. **Close other applications** to free up system resources
4. **Use SSD storage** for faster file loading

## Keyboard Shortcuts (Future Implementation)

The following shortcuts are planned:
- `Ctrl+O`: Open file dialog
- `Ctrl+S`: Save processed audio
- `Ctrl+Z`: Undo last operation
- `Space`: Play/pause audio (when audio player is implemented)
- `1-5`: Switch between chart types

## Next Steps

The application is fully functional with the core features implemented. Future enhancements could include:

1. **Audio playback** with QMediaPlayer
2. **More effects** from the complete librosa API
3. **Batch processing** for multiple files
4. **Export presets** for common processing workflows
5. **Spectrum analyzer** visualization
6. **Real-time effects** preview
7. **Plugin system** for custom effects
8. **Session management** to save and load projects

## Support

For issues or questions:
1. Check the README.md file
2. Review error messages in the terminal
3. Verify all dependencies are installed
4. Check that Python 3.11 is being used

---

Enjoy using AnimaSound! 🎵
