#!/usr/bin/env python3
"""
AnimaSound - Main Application Entry Point
A modern desktop application for audio analysis and manipulation.
"""

import sys
import os
from pathlib import Path

from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl, Qt

from anima.processor import AudioProcessor
from anima.chart_backend import ChartBackend


def get_qml_path():
    """Get the path to the main QML file."""
    possible_paths = [
        Path(__file__).parent.parent.parent / "qml" / "Main.qml",
        Path(__file__).parent.parent / "qml" / "Main.qml",
        Path.cwd() / "qml" / "Main.qml",
    ]
    
    for path in possible_paths:
        if path.exists():
            return QUrl.fromLocalFile(str(path))
    
    raise FileNotFoundError("Could not find Main.qml")


def main():
    """Main application entry point."""
    QApplication.setHighDpiScaleFactorRoundingPolicy(Qt.HighDpiScaleFactorRoundingPolicy.PassThrough)
    
    app = QApplication(sys.argv)
    app.setApplicationName("AnimaSound")
    app.setOrganizationName("AnimaSound")
    app.setApplicationVersion("0.1.0")
    
    engine = QQmlApplicationEngine()
    
    # Add components directory to import paths
    qml_components_path = Path(__file__).parent.parent.parent / "qml" / "components"
    if qml_components_path.exists():
        engine.addImportPath(str(qml_components_path.parent))
    
    # Create and register the audio processor
    audio_processor = AudioProcessor()
    engine.rootContext().setContextProperty("audioProcessor", audio_processor)
    
    # Create and register the chart backend
    chart_backend = ChartBackend()
    engine.rootContext().setContextProperty("chartBackend", chart_backend)
    
    # Connect audio processor to chart backend
    def on_audio_loaded(filename, duration, sr, channels):
        """When audio is loaded, update chart backend."""
        chart_backend.set_audio_data(
            audio_processor.get_audio_data(),
            audio_processor.get_sample_rate()
        )
        # Generate default waveform
        chart_backend.generate_chart('waveform')
    
    audio_processor.file_loaded.connect(on_audio_loaded)
    
    # Connect chart progress to audio processor progress
    chart_backend.chart_progress.connect(audio_processor.progress_updated)
    
    # Load the QML file
    try:
        qml_url = get_qml_path()
        engine.load(qml_url)
    except FileNotFoundError as e:
        print(f"Error: {e}")
        sys.exit(1)
    
    if not engine.rootObjects():
        print("Error: Failed to load QML")
        sys.exit(1)
    
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
