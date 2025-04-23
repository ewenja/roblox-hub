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
ui:AddRoundToggle("Auto Farm", false, function(state)
    print("RoundToggle state:", state)
end)

local settingsTab = ui:AddTab("Settings")
settingsTab:AddButton("Reset", function()
    print("Reset clicked!")
end)
ui:AddCustomButton({
    Text = "⚙ Custom Style",
    Color = Color3.fromRGB(20, 20, 60),
    HoverColor = Color3.fromRGB(40, 40, 90),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    CornerRadius = 12,
    BackgroundTransparency = 0.05,
    BorderColor = Color3.fromRGB(0, 200, 255),
    Callback = function()
        print("Custom styled button clicked!")
    end
})
ui:AddTextbox("ESPColor (R,G,B)", "0,255,0", function(input) 
    local r, g, b = input:match("(%d+),(%d+),(%d+)")
    if r and g and b then
        local color = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
        -- esp is here
        print("選擇顏色:", color)
    end
end)
ui:AddColorPicker("ESPColor", Color3.fromRGB(255, 255, 255), function(newColor)
    print("Color：", newColor)
end)
ui:AddColorPickerNative("You Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Color：", color)
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
