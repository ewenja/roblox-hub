---

## 🛡️ HihiHub UI Library

A lightweight and **anti-detection** Roblox UI library — fully standalone, scrollable, tab-supported, and obfuscated.

---

### ✅ Features

- `AddButton` — Create custom buttons  
- `AddToggle` / `AddRoundToggle` — Flat or rounded toggle switches with animation  
- `AddSlider` — Adjustable slider with min/max and callback  
- `AddKeybind` — Bind actions to key presses  
- `AddTextbox` — Input field for user text  
- `AddDropdown` — Dropdown selection menus  
- `Notify` — Show toast-like notifications  
- `AddTab` / `SwitchTab` — Tabbed UI system  
- Rounded corners & smooth transitions  
- Built-in hotkey toggle (e.g., RightCtrl / Insert)  
- Draggable & scrollable interface  
- Randomized UI element names for anti-cheat bypass  
- No dependencies — just plug & play!

---

### 🧪 Example

```lua
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ewenja/roblox-hub/refs/heads/main/HihiHub%20ui.lua"))()
local ui = lib:CreateWindow({
    Name = "MyScriptUI",
    Size = UDim2.new(0, 300, 0, 200),
    ToggleKeys = { Enum.KeyCode.RightControl }
})

ui:AddButton("Print Hello", function()
    print("Hello world!")
end)

ui:AddToggle("Enable Feature", false, function(val)
    print("Toggle =", val)
end)

ui:AddSlider("Volume", 0, 100, 50, function(val)
    print("Volume:", val)
end)

ui:AddKeybind("Trigger Action", Enum.KeyCode.K, function()
    print("Pressed K!")
end)

ui:AddTextbox("Enter Name", "Player123", function(text)
    print("Input:", text)
end)

ui:AddDropdown("Choose Weapon", {"AK", "M4", "AWP"}, 1, function(choice)
    print("Selected:", choice)
end)

local settingsTab = ui:AddTab("Settings")
settingsTab:AddButton("Reset", function()
    print("Reset clicked!")
end)

ui:SwitchTab("Settings")
ui:Notify("✅ Script loaded!", 3)
```

---

### 🔐 Anti-Detection

- Uses `gethui()` if available — safer than CoreGui  
- Randomized UI element names (e.g. `btn_729183`, `tab_201822`)  
- All callbacks wrapped in `pcall()` for error-proof execution  
- Clean visuals, no external modules, designed for stealth

---

📂 **GitHub:**  
https://github.com/ewenja/roblox-hub/blob/main/HihiHub%20ui.lua

---
