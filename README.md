---

### 🛡️ HihiHub UI Library

A lightweight and **anti-detection friendly** UI library for Roblox scripts.  
It supports scrollable interfaces, dynamic tab support, randomized element names, toggle hotkeys, and more — all in a single standalone file.

---

#### ✅ Features:

- Custom button creation: `AddButton`
- Toggle switch UI: `AddToggle`
- Sliders with value range: `AddSlider`
- Keybinding support: `AddKeybind`
- Text input support: `AddTextbox`
- Dropdown selection: `AddDropdown`
- Built-in UI toggle (default: RightCtrl / Insert)
- Draggable UI window
- Scrollable content
- Tab system (`AddTab`, `SwitchTab`)
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
    Name = "MyScriptUI", -- Displayed at the top of the UI
    Size = UDim2.new(0, 300, 0, 200), -- Window size (width, height)
    ToggleKeys = { Enum.KeyCode.RightControl } -- Key(s) to toggle visibility
})

-- Add a simple button
ui:AddButton("Print Hello", function()
    print("Hello world!")
end)

-- Add a toggle switch
ui:AddToggle("Enable Feature", false, function(val)
    print("Toggle =", val)
end)

-- Add a slider
ui:AddSlider("Volume", 0, 100, 50, function(val)
    print("Volume:", val)
end)

-- Add a keybind
ui:AddKeybind("Trigger Action", Enum.KeyCode.K, function()
    print("Pressed K!")
end)

-- Add a textbox
ui:AddTextbox("Enter Name", "Player123", function(text)
    print("Input:", text)
end)

-- Add a dropdown
ui:AddDropdown("Choose Weapon", {"AK", "M4", "AWP"}, 1, function(choice)
    print("Selected:", choice)
end)

-- Add a tab (for modular UI)
local settingsTab = ui:AddTab("Settings")
settingsTab:AddButton("Reset", function()
    print("Reset clicked!")
end)

-- Switch to tab
ui:SwitchTab("Settings")

-- Show a notification
ui:Notify("✅ Script loaded successfully!", 3)
```

---

#### 🔐 About Security:

- ✅ Uses `gethui()` if available to hide the GUI from detection tools  
  *(e.g., avoids `CoreGui` when possible).*
- 🔒 Randomized element names (e.g. `btn_183002`, `tab_394001`)  
  to prevent simple string-based detection from anti-cheat systems.
- 🧱 All callback functions are wrapped in `pcall()` for fault tolerance.
- 🧼 Clean and minimal UI, super easy to reuse in any script.

---
