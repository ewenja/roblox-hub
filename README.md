---

### 🛡️ HihiHub UI Library

A lightweight and **anti-detection friendly** UI library for Roblox scripts.  
It supports customizable controls, randomized element names, toggle hotkeys, and more — all in a single standalone file.

---

#### ✅ Features:

- Custom button creation: `AddButton`
- Toggle switch UI: `AddToggle`
- Sliders with value range: `AddSlider`
- Keybinding support: `AddKeybind`
- Built-in UI toggle (default: RightCtrl / Insert)
- Draggable UI window
- Rounded corners and smooth transitions
- Randomized element names (for extra obfuscation)
- Zero external dependencies — plug and play!

---

#### 🧪 Example Usage:

```lua
-- Load the UI Library
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ewenja/roblox-hub/refs/heads/main/HihiHub%20ui.lua"))()

-- Create a new UI window
local ui = lib:CreateWindow({
    Name = "MyScriptUI", -- Window title (displayed at the top)
    Size = UDim2.new(0, 300, 0, 200), -- UI size (width x height)
    ToggleKeys = { Enum.KeyCode.RightControl } -- Toggle UI visibility
})

-- Add a simple button
ui:AddButton("Print Hello", function()
    print("Hello world!") -- Will print when the button is clicked
end)

-- Add a toggle button
ui:AddToggle("Test Toggle", false, function(val)
    print("Toggle = ", val) -- Prints true/false when toggled
end)

-- Add a slider from 0 to 100
ui:AddSlider("Brightness", 0, 100, 50, function(val)
    print("Brightness:", val) -- Gets called when the slider value changes
end)

-- Add a keybind (pressing K will trigger the function)
ui:AddKeybind("Trigger Test", Enum.KeyCode.K, function()
    print("Pressed K!")
end)
```

---

#### 🔐 About Security:

- Uses `gethui()` if available for extra stealth  
  (places the UI in a hidden container rather than `CoreGui`).
- Randomizes names for buttons and frames (e.g., `btn_123456`)  
  to avoid simple string-based detections.
- Wraps all callbacks in `pcall()` to prevent errors from breaking the script.
- Fully draggable, clean layout, and super easy to reuse in any script.

---
