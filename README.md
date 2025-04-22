### 🛡️ HihiHub UI Library

一個專為 Roblox 腳本安全設計的輕量級 UI Library 
具備防偵測邏輯與混淆處理，支援常見的 UI 控件與快捷鍵開關

---

#### ✅ 特色功能：

- 自訂按鈕 `AddButton`
- 開關切換 `AddToggle`
- 滑桿選擇 `AddSlider`
- 熱鍵綁定 `AddKeybind`
- 快捷鍵切換 UI 顯示（預設：右 Ctrl / Insert）
- 支援 UI 拖曳移動
- 圓角樣式、動畫過渡
- 元素名稱自動混淆（降低被檢測機率）
- 單一檔案、無外部依賴、可即貼即用

---

#### 🧪 範例使用：

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
