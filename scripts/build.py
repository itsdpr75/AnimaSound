#!/usr/bin/env python3
"""
Build script for AnimaSound.
Packages the application into a standalone executable for Linux using PyInstaller.
"""

import subprocess
import sys
import os

def build():
    """Build the AnimaSound application."""
    # Get the project root directory
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    
    # PyInstaller command
    cmd = [
        sys.executable, '-m', 'PyInstaller',
        '--name=AnimaSound',
        '--windowed',  # No console on Windows/macOS
        '--onefile',  # Single executable
        '--add-data', f'{os.path.join(project_root, "qml")}{os.pathsep}qml',
        '--add-data', f'{os.path.join(project_root, "resources")}{os.pathsep}resources',
        '--hidden-import=librosa',
        '--hidden-import=librosa.core',
        '--hidden-import=librosa.feature',
        '--hidden-import=librosa.effects',
        '--hidden-import=librosa.beat',
        '--hidden-import=librosa.onset',
        '--hidden-import=librosa.decompose',
        '--hidden-import=librosa.segment',
        '--hidden-import=librosa.sequence',
        '--hidden-import=librosa.filters',
        '--hidden-import=librosa.util',
        '--hidden-import=librosa.display',
        '--hidden-import=soundfile',
        '--hidden-import=audioread',
        '--hidden-import=qtawesome',
        '--hidden-import=matplotlib',
        '--hidden-import=numpy',
        '--hidden-import=scipy',
        os.path.join(project_root, 'src', 'anima', 'main.py'),
    ]
    
    print("Building AnimaSound...")
    print(f"Command: {' '.join(cmd)}")
    
    # Run PyInstaller
    result = subprocess.run(cmd, cwd=project_root)
    
    if result.returncode == 0:
        print("\nBuild successful!")
        print(f"Executable location: {os.path.join(project_root, 'dist', 'AnimaSound')}")
    else:
        print("\nBuild failed!")
        sys.exit(1)

if __name__ == "__main__":
    build()
