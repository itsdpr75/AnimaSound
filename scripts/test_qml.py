#!/usr/bin/env python3
"""
Test script to verify QML loads correctly without requiring all dependencies.
"""

import sys
import os

# Add the src directory to the Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl, QCoreApplication, Qt

def main():
    """Test QML loading."""
    app = QGuiApplication(sys.argv)
    app.setApplicationName("AnimaSound Test")
    
    engine = QQmlApplicationEngine()
    
    # Load the QML file
    qml_path = os.path.join(os.path.dirname(__file__), '..', 'qml', 'Main.qml')
    qml_url = QUrl.fromLocalFile(os.path.abspath(qml_path))
    
    print(f"Loading QML from: {qml_url.toLocalFile()}")
    engine.load(qml_url)
    
    if not engine.rootObjects():
        print("Error: Failed to load QML")
        sys.exit(1)
    else:
        print("✓ QML loaded successfully!")
        print("✓ Application window should be visible")
    
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
