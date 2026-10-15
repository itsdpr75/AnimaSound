- abandoned unu
- 40% del codigo es IA (qwen)

# AnimaSound

A modern desktop application for audio analysis and manipulation, built with PySide6 and librosa.

## Features

- **Drag & Drop Interface**: Easily load audio files by dragging them into the application
- **Audio Analysis**: Automatic extraction of audio features including:
  - Duration and sample rate
  - Tempo (BPM) detection
  - Beat and onset detection
  - Spectral features (centroid, bandwidth, contrast, flatness)
  - RMS energy and zero crossing rate
- **Audio Effects & Processing**:
  - Time stretching (change speed without affecting pitch)
  - Pitch shifting (change pitch without affecting duration)
  - Harmonic/percussive source separation (HPSS)
  - Silence trimming
  - Audio normalization
- **Visualization**:
  - Waveform display
  - Spectrogram
  - Mel spectrogram
  - Chromagram
  - Tempogram
- **Modern UI**: Dark theme with lilac accent color, designed for KDE Plasma integration

## Tech Stack

- **Python 3.11**: Core programming language
- **PySide6**: Qt6 bindings for Python (GUI framework)
- **QML**: Declarative UI framework for modern interfaces
- **librosa**: Audio analysis and music information retrieval
- **matplotlib**: Chart visualization
- **numpy/scipy**: Numerical computing
- **soundfile**: High-quality audio I/O
- **qtawesome**: FontAwesome icon integration

## Installation

### Prerequisites

- Python 3.11
- pip package manager

### Setup

1. **Clone or download** the repository

2. **Create a virtual environment** (recommended):
   ```bash
   python3.11 -m venv venv
   source venv/bin/activate  # On Linux/macOS
   # or
   venv\Scripts\activate  # On Windows
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```
   
   Or install directly from pyproject.toml:
   ```bash
   pip install -e .
   ```

## Usage

### Running the Application

**Development mode**:
```bash
python scripts/run.py
```

Or directly:
```bash
python -m anima.main
```

**From anywhere** (after installation):
```bash
animasound
```

### Using the Application

1. **Load an audio file**:
   - Drag and drop an audio file onto the drop zone
   - Or click "Browse Files" to select a file
   - Supported formats: WAV, MP3, FLAC, OGG, M4A

2. **View audio information**:
   - File name, duration, sample rate, and channels are displayed
   - Automatic analysis provides tempo, beat times, and spectral features

3. **Apply effects**:
   - Use the left panel to access audio effects
   - Adjust parameters using sliders
   - Click "Apply" to process the audio

4. **Visualize audio**:
   - Switch between different visualization types using the tabs:
     - Waveform: Time-domain representation
     - Spectrogram: Frequency content over time
     - Mel Spectrogram: Perceptually-informed spectrogram
     - Chroma: Pitch class representation
     - Tempogram: Tempo content over time

5. **Save processed audio**:
   - Click "Save As..." to export the processed audio
   - Supported format: WAV

## Building Standalone Executable

To create a standalone executable for Linux:

```bash
python scripts/build.py
```

This will use PyInstaller to package the application. The executable will be located in `dist/AnimaSound`.

## Project Structure

```
animasound/
├── src/
│   └── anima/
│       ├── __init__.py
│       ├── main.py              # Application entry point
│       ├── processor.py         # AudioProcessor bridge class
│       └── chart_backend.py     # Matplotlib chart backend
├── qml/
│   └── Main.qml                 # Main UI definition
├── scripts/
│   ├── run.py                   # Development runner
│   ├── build.py                 # Build script (PyInstaller)
│   └── setup_icons.py           # Icon setup utility
├── resources/                   # Application resources
├── pyproject.toml               # Project configuration
├── requirements.txt             # Python dependencies
└── README.md                    # This file
```

## Supported Audio Features

### Analysis (librosa)
- **Beat & Tempo**: `beat_track()`, `tempo()`, `plp()`
- **Onset Detection**: `onset_detect()`, `onset_strength()`, `onset_backtrack()`
- **Spectral Features**: 
  - `spectral_centroid()`
  - `spectral_bandwidth()`
  - `spectral_contrast()`
  - `spectral_flatness()`
  - `spectral_rolloff()`
  - `mfcc()`
  - `melspectrogram()`
  - `chroma_stft()`, `chroma_cqt()`, `chroma_cens()`
  - `rms()`
  - `zero_crossing_rate()`
  - `tonnetz()`
  - `poly_features()`
- **Rhythm Features**: `tempogram()`, `fourier_tempogram()`

### Effects (librosa.effects)
- `time_stretch()` - Change tempo without affecting pitch
- `pitch_shift()` - Change pitch without affecting duration
- `hpss()` - Harmonic/percussive separation
- `trim()` - Remove silence
- `split()` - Split into non-silent intervals
- `remix()` - Reorder time intervals
- `preemphasis()` / `deemphasis()` - Pre/de-emphasis filtering

### Utilities (librosa.util)
- `normalize()` - Normalize audio signal
- `fix_length()` - Adjust signal length
- `frame()` - Frame-based processing
- `peak_pick()` - Peak detection
- `nnls()` - Non-negative least squares
- `sync()` - Feature synchronization

### Filters (librosa.filters)
- `mel()` - Mel filterbank
- `chroma()` - Chroma filterbank
- `constant_q()` - Constant-Q filterbank
- `diagonal_filter()` - Diagonal filtering

## Customization

### Color Theme

The application uses a dark theme with lilac accent. To customize:

Edit `qml/Main.qml` and modify these properties:
```qml
readonly property string accentColor: "#A855F7"
readonly property string accentColorLight: "#C084FC"
readonly property string backgroundColor: "#121218"
readonly property string surfaceColor: "#1e1e2e"
```

### KDE Plasma Integration

The application is designed to integrate with KDE Plasma desktop:
- Uses system palette colors where possible
- Follows modern desktop design patterns
- Supports high DPI displays

## Troubleshooting

### Common Issues

**Issue**: "ModuleNotFoundError: No module named 'librosa'"
- **Solution**: Install dependencies: `pip install -r requirements.txt`

**Issue**: "Could not find Main.qml"
- **Solution**: Ensure you're running from the project root directory

**Issue**: Audio playback not working
- **Solution**: Install multimedia codecs for your system

**Issue**: Charts not displaying
- **Solution**: Ensure matplotlib is properly installed and configured

## Development

### Adding New Features

1. **Add new audio processing**:
   - Edit `src/anima/processor.py`
   - Add new `@Slot` methods for QML access
   - Emit signals to update UI

2. **Add new visualizations**:
   - Edit `src/anima/chart_backend.py`
   - Add new chart generation methods
   - Connect to QML chart view

3. **Modify UI**:
   - Edit `qml/Main.qml`
   - Add new QML components
   - Connect to Python slots via context properties

### Code Style

- Follow PEP 8 for Python code
- Use Qt Quick Controls 2.15 conventions for QML
- Document all public methods and classes

## License

MIT License - See LICENSE file for details

## Contributing

Contributions are welcome! Please submit pull requests or open issues for bugs and feature requests.

## Acknowledgments

- [librosa](https://librosa.org/) - Audio analysis library
- [PySide6](https://doc.qt.io/qtforpython/) - Qt for Python
- [QtAwesome](https://github.com/spyder-ide/qtawesome) - Icon library

---

**AnimaSound** - Audio analysis made simple and beautiful 🎵
