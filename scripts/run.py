#!/usr/bin/env python3
"""
Development runner for AnimaSound.
Runs the application in development mode with hot reload support.
"""

import sys
import os

# Add the src directory to the Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from anima.main import main

if __name__ == "__main__":
    main()
