#!/usr/bin/env python3
"""
ChartBackend - Backend for matplotlib chart generation.
Generates chart images and sends them to QML.
"""

import io
import tempfile
import os
import threading
import numpy as np
import librosa
import librosa.display
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.figure import Figure
from PySide6.QtCore import QObject, Signal, Slot, Property, QThread
from PySide6.QtGui import QImage


class ChartWorker(QObject):
    """Worker thread for chart generation."""
    
    finished = Signal()
    chart_done = Signal(str, str)  # chart_type, image_path
    chart_error_signal = Signal(str)  # error message
    
    def __init__(self, generate_func, chart_type, audio_data, sample_rate, temp_dir):
        super().__init__()
        self.generate_func = generate_func
        self.chart_type = chart_type
        self.audio_data = audio_data
        self.sample_rate = sample_rate
        self.temp_dir = temp_dir
    
    @Slot()
    def run(self):
        """Run the chart generation in a worker thread."""
        try:
            image = self.generate_func()
            if image:
                # Save to file
                image_path = os.path.join(self.temp_dir, f'animasound_chart_{self.chart_type}.png')
                if image.save(image_path):
                    self.chart_done.emit(self.chart_type, image_path)
                else:
                    self.chart_error_signal.emit(f"Failed to save {self.chart_type} chart")
            else:
                self.chart_error_signal.emit(f"Chart generation returned None")
        except Exception as e:
            self.chart_error_signal.emit(f"Error generating {self.chart_type}: {str(e)}")
        finally:
            self.finished.emit()


class ChartBackend(QObject):
    """Backend for generating and managing matplotlib charts."""

    chart_ready = Signal(str)  # chart type
    chart_error = Signal(str)  # error message
    chart_image_changed = Signal()  # emitted when chart image changes
    chart_progress = Signal(float)  # 0-100
    all_charts_complete = Signal()  # emitted when all charts are done
    
    def __init__(self):
        super().__init__()
        self._audio_data = None
        self._sample_rate = None
        self._current_chart = ""
        self._chart_image = QImage()  # Store the current chart image
        self._chart_image_path = ""  # Path to saved image
        self._temp_dir = tempfile.gettempdir()
        self._worker_thread = None
        self._worker = None
        self._chart_queue = ['waveform', 'spectrogram', 'melspectrogram', 'chroma', 'tempogram']
        self._current_chart_index = 0
        self._worker_thread = None
        self._worker = None
        
    def set_audio_data(self, y, sr):
        """Set the audio data for chart generation."""
        self._audio_data = y
        self._sample_rate = sr
    
    def _prepare_audio(self):
        """Prepare audio for visualization (convert to mono if needed)."""
        if self._audio_data is None:
            return None
        
        y = self._audio_data
        if y.ndim > 1:
            y = librosa.to_mono(y)
        return y
    
    def _create_figure(self, width=800, height=300):
        """Create a figure with dark theme."""
        fig = Figure(figsize=(width/100, height/100), dpi=100)
        fig.patch.set_facecolor('#1e1e2e')
        return fig
    
    def _save_figure(self, fig, chart_type):
        """Save figure to QImage and file."""
        buf = io.BytesIO()
        fig.savefig(buf, format='png', facecolor='#1e1e2e', edgecolor='none', 
                   bbox_inches='tight', dpi=100)
        buf.seek(0)
        plt.close(fig)
        
        image = QImage.fromData(buf.getvalue())
        self._chart_image = image
        
        # Also save to file for QML to access
        image_path = os.path.join(self._temp_dir, f'animasound_chart_{chart_type}.png')
        image.save(image_path)
        self._chart_image_path = image_path
        
        self.chart_image_changed.emit()
        return image
    
    def generate_waveform(self, width=800, height=300):
        """Generate waveform chart."""
        y = self._prepare_audio()
        if y is None:
            return None
        
        try:
            fig = self._create_figure(width, height)
            ax = fig.add_subplot(111)
            ax.set_facecolor('#1e1e2e')
            
            librosa.display.waveshow(y, sr=self._sample_rate, ax=ax, color='#A855F7')
            ax.set_title('Waveform', color='#ffffff', fontsize=12)
            ax.set_xlabel('Time (s)', color='#ffffff')
            ax.set_ylabel('Amplitude', color='#ffffff')
            ax.tick_params(colors='#ffffff')
            for spine in ax.spines.values():
                spine.set_color('#444444')
            
            fig.tight_layout()
            return self._save_figure(fig, 'waveform')
            
        except Exception as e:
            self.chart_error.emit(f"Error generating waveform: {str(e)}")
            return None
    
    def generate_spectrogram(self, width=800, height=300):
        """Generate spectrogram chart."""
        y = self._prepare_audio()
        if y is None:
            return None
        
        try:
            fig = self._create_figure(width, height)
            ax = fig.add_subplot(111)
            ax.set_facecolor('#1e1e2e')
            
            D = librosa.amplitude_to_db(np.abs(librosa.stft(y)), ref=np.max)
            img = librosa.display.specshow(D, y_axis='log', x_axis='time', ax=ax, cmap='magma')
            ax.set_title('Spectrogram', color='#ffffff', fontsize=12)
            fig.colorbar(img, ax=ax, format="%+2.0f dB")
            ax.tick_params(colors='#ffffff')
            
            fig.tight_layout()
            return self._save_figure(fig, 'spectrogram')
            
        except Exception as e:
            self.chart_error.emit(f"Error generating spectrogram: {str(e)}")
            return None
    
    def generate_melspectrogram(self, width=800, height=300):
        """Generate mel spectrogram chart."""
        y = self._prepare_audio()
        if y is None:
            return None
        
        try:
            fig = self._create_figure(width, height)
            ax = fig.add_subplot(111)
            ax.set_facecolor('#1e1e2e')
            
            mel_spec = librosa.feature.melspectrogram(y=y, sr=self._sample_rate)
            mel_spec_db = librosa.amplitude_to_db(mel_spec, ref=np.max)
            img = librosa.display.specshow(mel_spec_db, x_axis='time', y_axis='mel', ax=ax, cmap='magma')
            ax.set_title('Mel Spectrogram', color='#ffffff', fontsize=12)
            fig.colorbar(img, ax=ax, format="%+2.0f dB")
            ax.tick_params(colors='#ffffff')
            
            fig.tight_layout()
            return self._save_figure(fig, 'melspectrogram')
            
        except Exception as e:
            self.chart_error.emit(f"Error generating mel spectrogram: {str(e)}")
            return None
    
    def generate_chroma(self, width=800, height=300):
        """Generate chromagram chart."""
        y = self._prepare_audio()
        if y is None:
            return None
        
        try:
            fig = self._create_figure(width, height)
            ax = fig.add_subplot(111)
            ax.set_facecolor('#1e1e2e')
            
            chroma = librosa.feature.chroma_stft(y=y, sr=self._sample_rate)
            img = librosa.display.specshow(chroma, y_axis='chroma', x_axis='time', ax=ax, cmap='magma')
            ax.set_title('Chromagram', color='#ffffff', fontsize=12)
            fig.colorbar(img, ax=ax)
            ax.tick_params(colors='#ffffff')
            
            fig.tight_layout()
            return self._save_figure(fig, 'chroma')
            
        except Exception as e:
            self.chart_error.emit(f"Error generating chromagram: {str(e)}")
            return None
    
    def generate_tempogram(self, width=800, height=300):
        """Generate tempogram chart."""
        y = self._prepare_audio()
        if y is None:
            return None
        
        try:
            fig = self._create_figure(width, height)
            ax = fig.add_subplot(111)
            ax.set_facecolor('#1e1e2e')
            
            tempogram = librosa.feature.tempogram(y=y, sr=self._sample_rate)
            img = librosa.display.specshow(tempogram, x_axis='time', y_axis='tempo', ax=ax, cmap='magma')
            ax.set_title('Tempogram', color='#ffffff', fontsize=12)
            fig.colorbar(img, ax=ax)
            ax.tick_params(colors='#ffffff')
            
            fig.tight_layout()
            return self._save_figure(fig, 'tempogram')
            
        except Exception as e:
            self.chart_error.emit(f"Error generating tempogram: {str(e)}")
            return None
    
    @Slot(str)
    def generate_chart(self, chart_type):
        """Generate a chart by type in a background thread and emit signal."""
        generators = {
            'waveform': self.generate_waveform,
            'spectrogram': self.generate_spectrogram,
            'melspectrogram': self.generate_melspectrogram,
            'chroma': self.generate_chroma,
            'tempogram': self.generate_tempogram,
        }

        generator = generators.get(chart_type)
        if not generator:
            self.chart_error.emit(f"Unknown chart type: {chart_type}")
            return

        # Emit progress start
        self.chart_progress.emit(10)

        # Stop any existing worker thread
        if self._worker_thread and self._worker_thread.isRunning():
            self._worker_thread.quit()
            self._worker_thread.wait()

        # Create and start worker thread
        self._worker_thread = QThread()
        self._worker = ChartWorker(generator, chart_type, self._audio_data,
                                   self._sample_rate, self._temp_dir)
        self._worker.moveToThread(self._worker_thread)

        # Connect signals
        self._worker_thread.started.connect(self._worker.run)
        self._worker.finished.connect(self._worker_thread.quit)
        self._worker.chart_done.connect(self._on_chart_done)
        self._worker.chart_error_signal.connect(self._on_chart_error)

        # Emit more progress
        self.chart_progress.emit(50)

        # Start thread
        self._worker_thread.start()
    
    def _on_chart_done(self, chart_type, image_path):
        """Handle chart completion and generate next chart."""
        self.chart_progress.emit(100)
        self.chart_ready.emit(chart_type)
        
        # Generate next chart in queue
        self._current_chart_index += 1
        if self._current_chart_index < len(self._chart_queue):
            next_chart = self._chart_queue[self._current_chart_index]
            progress = 10 + (self._current_chart_index * 15)
            self.chart_progress.emit(min(progress, 90))
            self.generate_chart(next_chart)
        else:
            self.all_charts_complete.emit()
            self._current_chart_index = 0

    def _on_chart_error(self, error_msg):
        """Called when chart generation fails."""
        self.chart_error.emit(error_msg)
    
    @Property(str)
    def current_chart(self):
        return self._current_chart
    
    @Property(QImage)
    def chart_image(self):
        """Get the current chart image."""
        return self._chart_image
    
    @Property(str, notify=chart_image_changed)
    def chart_image_path(self):
        """Get the path to the current chart image file."""
        return self._chart_image_path
