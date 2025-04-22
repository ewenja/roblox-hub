# HihiHub UI Library
一款專為 Roblox 安全設計的輕量級 UI Library 內建防偵測邏輯 支援：

- ✅ 自訂按鈕 `AddButton`
- ✅ 滑桿 `AddSlider`
- ✅ 熱鍵綁定 `AddKeybind`
- ✅ 開關 `AddToggle`
- ✅ 淡入淡出動畫
- ✅ 陰影、圓角美化
- ✅ UI 混淆名稱
- ✅ UI 顯示/隱藏熱鍵（預設：右Ctrl / Insert）

### 💻 用法：

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

ui:AddToggle("開關測試", false, function(val)
    print("Toggle = ", val)
end)

ui:AddSlider("亮度", 0, 100, 50, function(val)
    print("目前亮度：", val)
end)

ui:AddKeybind("觸發測試", Enum.KeyCode.K, function()
    print("按下了 K 鍵！")
end)
