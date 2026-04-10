#!/usr/bin/env python3
"""
AudioProcessor - Bridge class for librosa operations.
Exposes librosa functionality to QML through Qt signals and slots.
"""

import os
import time
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor

import numpy as np
import librosa
import soundfile as sf
from PySide6.QtCore import QObject, Signal, Slot, Property, QThread
from PySide6.QtWidgets import QFileDialog


class AudioProcessor(QObject):
    """Bridge class for librosa operations."""
    
    # Signals
    file_loaded = Signal(str, float, int, int)
    analysis_complete = Signal(dict)
    processing_started = Signal(str)  # Status text
    processing_complete = Signal(dict)
    error_occurred = Signal(str)
    progress_updated = Signal(float)  # 0-100
    directory_listed = Signal(list)
    
    def __init__(self):
        super().__init__()
        self._audio_data = None
        self._sample_rate = None
        self._file_path = ""
        self._processed_data = None
        
    @Slot(str)
    def load_file(self, file_path):
        """Load an audio file (async with progress)."""
        self._run_in_background(self._load_file_task, file_path)
    
    def _load_file_task(self, file_path):
        """Actual file loading with progress."""
        try:
            self.processing_started.emit(f"Loading audio file...")
            self.progress_updated.emit(20)
            
            y, sr = librosa.load(file_path, sr=None, mono=False)
            self.progress_updated.emit(60)
            
            channels = 1 if y.ndim == 1 else y.shape[0]
            duration = librosa.get_duration(y=y, sr=sr)
            self.progress_updated.emit(80)
            
            self._audio_data = y
            self._sample_rate = sr
            self._file_path = file_path
            self._processed_data = None
            
            filename = Path(file_path).name
            self.progress_updated.emit(100)
            
            self.file_loaded.emit(filename, float(duration), int(sr), int(channels))
            
            # Run analysis after loading
            self.analyze_audio()
            
        except Exception as e:
            self.error_occurred.emit(f"Error loading file: {str(e)}")
    
    def analyze_audio(self):
        """Perform initial audio analysis with progress."""
        if self._audio_data is None or self._sample_rate is None:
            return
        
        try:
            self.processing_started.emit("Analyzing audio...")
            self.progress_updated.emit(10)
            
            y = self._audio_data
            sr = self._sample_rate
            
            y_mono = librosa.to_mono(y) if y.ndim > 1 else y
            self.progress_updated.emit(30)
            
            # Beat tracking
            tempo, beat_frames = librosa.beat.beat_track(y=y_mono, sr=sr)
            if isinstance(tempo, np.ndarray):
                tempo = float(tempo[0]) if len(tempo) > 0 else 0.0
            else:
                tempo = float(tempo)
            
            beat_frames_list = beat_frames.tolist() if hasattr(beat_frames, 'tolist') else []
            beat_times = librosa.frames_to_time(beat_frames_list if beat_frames_list else [0], sr=sr).tolist()
            self.progress_updated.emit(50)
            
            # Onset detection
            onset_frames = librosa.onset.onset_detect(y=y_mono, sr=sr)
            onset_times = librosa.frames_to_time(onset_frames, sr=sr).tolist()
            self.progress_updated.emit(70)
            
            # Features
            rms = librosa.feature.rms(y=y_mono)[0]
            spectral_centroid = librosa.feature.spectral_centroid(y=y_mono, sr=sr)[0]
            zcr = librosa.feature.zero_crossing_rate(y=y_mono)[0]
            self.progress_updated.emit(90)
            
            results = {
                'tempo': tempo,
                'beat_times': beat_times[:100],
                'onset_times': onset_times[:100],
                'rms': rms.tolist(),
                'spectral_centroid': spectral_centroid.tolist(),
                'zcr': zcr.tolist(),
            }
            
            self.progress_updated.emit(100)
            self.analysis_complete.emit(results)
            
        except Exception as e:
            self.error_occurred.emit(f"Error analyzing audio: {str(e)}")
    
    @Slot(float)
    def time_stretch(self, rate):
        """Time stretch the audio (async)."""
        if self._audio_data is None:
            self.error_occurred.emit("No audio loaded")
            return
        
        self._run_in_background(self._time_stretch_task, rate)
    
    def _time_stretch_task(self, rate):
        """Actual time stretch processing."""
        try:
            self.processing_started.emit(f"Time stretching (rate: {rate:.2f})x...")
            self.progress_updated.emit(30)
            
            y_stretched = librosa.effects.time_stretch(self._audio_data, rate=rate)
            self.progress_updated.emit(80)
            
            self._processed_data = y_stretched
            self.progress_updated.emit(100)
            self.processing_complete.emit({'status': 'Time stretch complete', 'rate': rate})
        except Exception as e:
            self.error_occurred.emit(f"Error in time stretch: {str(e)}")

    @Slot(float)
    def pitch_shift(self, n_steps):
        """Pitch shift the audio (async)."""
        if self._audio_data is None:
            self.error_occurred.emit("No audio loaded")
            return
        
        self._run_in_background(self._pitch_shift_task, n_steps)
    
    def _pitch_shift_task(self, n_steps):
        """Actual pitch shift processing."""
        try:
            self.processing_started.emit(f"Pitch shifting ({n_steps:+.0f} semitones)...")
            self.progress_updated.emit(30)
            
            y_shifted = librosa.effects.pitch_shift(
                self._audio_data,
                sr=self._sample_rate,
                n_steps=n_steps
            )
            self.progress_updated.emit(80)
            
            self._processed_data = y_shifted
            self.progress_updated.emit(100)
            self.processing_complete.emit({'status': 'Pitch shift complete', 'n_steps': n_steps})
        except Exception as e:
            self.error_occurred.emit(f"Error in pitch shift: {str(e)}")

    @Slot()
    def separate_hpss(self):
        """Separate harmonic and percussive components (async)."""
        if self._audio_data is None:
            self.error_occurred.emit("No audio loaded")
            return
        
        self._run_in_background(self._hpss_task)
    
    def _hpss_task(self):
        """Actual HPSS processing."""
        try:
            self.processing_started.emit("Separating harmonic/percussive...")
            self.progress_updated.emit(40)
            
            y_harmonic, y_percussive = librosa.effects.hpss(self._audio_data)
            self.progress_updated.emit(80)
            
            self._processed_data = {'harmonic': y_harmonic, 'percussive': y_percussive}
            self.progress_updated.emit(100)
            self.processing_complete.emit({'status': 'HPSS separation complete'})
        except Exception as e:
            self.error_occurred.emit(f"Error in HPSS separation: {str(e)}")

    @Slot(float)
    def trim_silence(self, top_db):
        """Trim silence from audio (async)."""
        if self._audio_data is None:
            self.error_occurred.emit("No audio loaded")
            return
        
        self._run_in_background(self._trim_task, top_db)
    
    def _trim_task(self, top_db):
        """Actual trim processing."""
        try:
            self.processing_started.emit(f"Trimming silence (threshold: -{top_db:.0f}dB)...")
            self.progress_updated.emit(40)
            
            y_trimmed, _ = librosa.effects.trim(self._audio_data, top_db=top_db)
            self.progress_updated.emit(80)
            
            self._processed_data = y_trimmed
            self.progress_updated.emit(100)
            self.processing_complete.emit({'status': 'Silence trimmed', 'top_db': top_db})
        except Exception as e:
            self.error_occurred.emit(f"Error trimming silence: {str(e)}")

    @Slot()
    def normalize_audio(self):
        """Normalize the audio (async)."""
        if self._audio_data is None:
            self.error_occurred.emit("No audio loaded")
            return
        
        self._run_in_background(self._normalize_task)
    
    def _normalize_task(self):
        """Actual normalize processing."""
        try:
            self.processing_started.emit("Normalizing audio...")
            self.progress_updated.emit(50)
            
            y_normalized = librosa.util.normalize(self._audio_data)
            self.progress_updated.emit(80)
            
            self._processed_data = y_normalized
            self.progress_updated.emit(100)
            self.processing_complete.emit({'status': 'Normalization complete'})
        except Exception as e:
            self.error_occurred.emit(f"Error normalizing audio: {str(e)}")
    
    def _run_in_background(self, task_func, *args):
        """Run a task in a background thread."""
        from PySide6.QtCore import QTimer
        
        def worker():
            try:
                task_func(*args)
            except Exception as e:
                QTimer.singleShot(0, lambda: self.error_occurred.emit(str(e)))
        
        import threading
        thread = threading.Thread(target=worker, daemon=True)
        thread.start()
    
    @Slot(str)
    def save_audio(self, output_path):
        """Save the processed audio."""
        if self._processed_data is None:
            self.error_occurred.emit("No processed audio to save")
            return
        
        try:
            if isinstance(self._processed_data, dict):
                for key, data in self._processed_data.items():
                    path = output_path.replace('.wav', f'_{key}.wav')
                    sf.write(path, data.T if data.ndim > 1 else data, self._sample_rate)
            else:
                sf.write(
                    output_path, 
                    self._processed_data.T if self._processed_data.ndim > 1 else self._processed_data, 
                    self._sample_rate
                )
            
            self.processing_complete.emit({'status': f'Audio saved to {output_path}'})
        except Exception as e:
            self.error_occurred.emit(f"Error saving audio: {str(e)}")
    
    @Slot(str)
    def list_directory(self, path):
        """List directory contents and emit signal."""
        try:
            if not path or path == "":
                path = str(Path.home())
            
            path_obj = Path(path)
            if not path_obj.exists():
                path_obj = Path.home()
            
            items = []
            if str(path_obj) != "/":
                items.append({
                    "name": "..",
                    "path": str(path_obj.parent),
                    "isDir": True
                })
            
            for item in sorted(path_obj.iterdir(), key=lambda x: (not x.is_dir(), x.name.lower())):
                if item.is_dir() or item.suffix.lower() in ['.wav', '.mp3', '.flac', '.ogg', '.m4a', '.aiff', '.aif']:
                    items.append({
                        "name": item.name,
                        "path": str(item),
                        "isDir": item.is_dir()
                    })
            
            self.directory_listed.emit(items)
        except Exception as e:
            self.error_occurred.emit(f"Error listing directory: {str(e)}")
            self.directory_listed.emit([])
    
    @Slot()
    def browse_file(self):
        """Open file browser dialog to select audio file."""
        file_path, _ = QFileDialog.getOpenFileName(
            None,
            "Select Audio File",
            str(Path.home()),
            "Audio Files (*.wav *.mp3 *.flac *.ogg *.m4a *.aiff *.aif);;All Files (*)"
        )
        
        if file_path:
            self.load_file(file_path)
    
    @Slot()
    def browse_save(self):
        """Open save file dialog."""
        file_path, _ = QFileDialog.getSaveFileName(
            None,
            "Save Audio",
            str(Path.home()) + "/output.wav",
            "WAV Files (*.wav);;All Files (*)"
        )
        
        if file_path:
            self.save_audio(file_path)
    
    @Property(str)
    def file_path(self):
        return self._file_path
    
    @Property(bool)
    def has_audio(self):
        return self._audio_data is not None
    
    # Getter methods for audio data
    def get_audio_data(self):
        return self._audio_data
    
    def get_sample_rate(self):
        return self._sample_rate
