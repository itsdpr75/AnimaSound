#!/usr/bin/env python3
"""
Setup script for FontAwesome icons.
Downloads and configures QtAwesome resources if needed.
"""

import os
import sys

def setup_icons():
    """Set up FontAwesome icons for QtAwesome."""
    try:
        import qtawesome as qta
        
        # Test if we can load icons
        test_icon = qta.icon('fa5.music')
        print("QtAwesome is properly installed and working.")
        print(f"Test icon loaded: {test_icon}")
        
        # List some available icon prefixes
        print("\nAvailable icon prefixes:")
        prefixes = ['fa5', 'fa5s', 'fa5b', 'fa6', 'fa6s', 'fa6b', 'mdi', 'mdi6']
        for prefix in prefixes:
            try:
                qta.icon(f'{prefix}.music')
                print(f"  ✓ {prefix}")
            except Exception:
                print(f"  ✗ {prefix}")
        
        print("\nIcon setup complete!")
        
    except ImportError:
        print("Error: qtawesome is not installed.")
        print("Install it with: pip install qtawesome")
        sys.exit(1)
    except Exception as e:
        print(f"Error setting up icons: {e}")
        sys.exit(1)

if __name__ == "__main__":
    setup_icons()
