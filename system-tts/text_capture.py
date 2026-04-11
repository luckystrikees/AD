#!/usr/bin/env python3
"""
Text Capture Module
Uses AppleScript to get the currently selected text in any application.
"""

import subprocess
import re


def get_selected_text():
    """
    Get the currently selected text using AppleScript.
    
    Returns:
        Selected text string, or None if no text is selected
    """
    # AppleScript to copy selected text via Edit menu
    applescript = '''
    tell application "System Events"
        set frontmostApp to name of first process whose frontmost is true
        tell process frontmostApp
            -- Try to get selected text via clipboard
            set oldClipboard to the clipboard
            delay 0.1
            -- Copy selection
            keystroke "c" using command down
            delay 0.2
            set newClipboard to the clipboard
            -- Restore old clipboard
            set the clipboard to oldClipboard
            return newClipboard
        end tell
    end tell
    '''
    
    try:
        result = subprocess.run(
            ['osascript', '-e', applescript],
            capture_output=True,
            text=True,
            timeout=3
        )
        
        if result.returncode == 0 and result.stdout.strip():
            text = result.stdout.strip()
            # Filter out common non-text clipboard items
            if text and len(text) > 0 and not text.startswith('file://'):
                return text
                
    except subprocess.TimeoutExpired:
        print("[Text Capture] Timeout - no selection")
    except Exception as e:
        print(f"[Text Capture] Error: {e}")
    
    return None


def get_selected_text_via_gui_script():
    """
    Alternative method using GUI scripting for apps that support it.
    Falls back to the clipboard method if GUI scripting fails.
    """
    # First try the standard clipboard method
    text = get_selected_text()
    if text:
        return text
    
    # Fallback: try to get text from focused text field
    applescript = '''
    tell application "System Events"
        set frontmostApp to name of first process whose frontmost is true
        try
            tell process frontmostApp
                set focusedUIElement to first UI element whose focused is true
                if class of focusedUIElement is text area then
                    return value of focusedUIElement
                else if class of focusedUIElement is text field then
                    return value of focusedUIElement
                end if
            end tell
        end try
        return ""
    end tell
    '''
    
    try:
        result = subprocess.run(
            ['osascript', '-e', applescript],
            capture_output=True,
            text=True,
            timeout=3
        )
        
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()
            
    except Exception:
        pass
    
    return None


def sanitize_text(text):
    """Clean up captured text for TTS."""
    if not text:
        return None
    
    # Remove excessive whitespace
    text = re.sub(r'\n{3,}', '\n\n', text)
    text = re.sub(r' {2,}', ' ', text)
    
    # Truncate to reasonable length
    if len(text) > 1000:
        # Try to break at sentence boundary
        sentences = text[:1000].rsplit('.', 1)
        if len(sentences) > 1:
            text = sentences[0] + '.'
        else:
            text = text[:1000]
    
    return text.strip()


if __name__ == '__main__':
    # Test text capture
    print("[Text Capture] Select some text in another app, then press Enter...")
    input()
    
    text = get_selected_text()
    if text:
        print(f"\nCaptured text ({len(text)} chars):")
        print(text[:200])
    else:
        print("No text captured.")
