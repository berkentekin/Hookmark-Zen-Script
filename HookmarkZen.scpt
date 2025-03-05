--- Add script to Hookmark > Settings > Scripts > (add Zen Browser) > Get Address
--- Made with DeepSeek R1

use scripting additions
use framework "AppKit"

-- Key mask constants
property NSShiftKeyMask : 131072
property NSAlternateKeyMask : 524288
property NSControlKeyMask : 262144
property NSEvent : a reference to current application's NSEvent

-- Wait until modifier keys (Shift/Control/Option) are released
set modifier_down to true
repeat while modifier_down
  set modifier_flags to NSEvent's modifierFlags()
  set option_down to ((modifier_flags div NSAlternateKeyMask) mod 2) = 1
  set shift_down to ((modifier_flags div NSShiftKeyMask) mod 2) = 1
  set control_down to ((modifier_flags div NSControlKeyMask) mod 2) = 1
  set modifier_down to option_down or shift_down or control_down
end repeat

-- Focus Zen Browser and retrieve window title
tell application "Zen"
  activate
  delay 0.2 -- Allow time for window focus
  set myName to name of front window
end tell

-- Attempt to directly fetch the URL from Zen's address bar
set theUrl to ""
tell application "System Events"
  tell process "Zen"
    -- Check for the address bar UI element (adjust hierarchy as needed)
    try
      set addressBar to text field 1 of group 1 of toolbar "Navigation" of group 1 of front window
      set theUrl to value of addressBar
    on error
      -- Fallback: Use clipboard copy method
      keystroke "l" using command down -- Focus address bar
      delay 0.1
      keystroke "c" using command down -- Copy URL
      delay 0.2
      set theUrl to (the clipboard as text)
    end try
  end tell
end tell

-- Construct Markdown link
if theUrl is not "" then
  return "[«" & myName & "»](" & theUrl & ")"
else
  return "Failed to retrieve URL"
end if
