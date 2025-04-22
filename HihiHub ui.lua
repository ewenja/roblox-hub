local SafeUILib = {}
SafeUILib.__index = SafeUILib

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function SafeUILib:CreateWindow(opts)
    opts = opts or {}
    local toggleKeys = opts.ToggleKeys or { Enum.KeyCode.RightControl, Enum.KeyCode.Insert }
    local windowName = opts.Name or tostring(math.random(100000, 999999))
    local windowSize = opts.Size or UDim2.new(0, 300, 0, 150)
    local backgroundColor = opts.BackgroundColor or Color3.fromRGB(30,30,30)

    local gui = Instance.new("ScreenGui")
    gui.ResetOnSpawn = false
    gui.Name = windowName
    if gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainUI_" .. tostring(math.random(100000,999999))
    mainFrame.Size = windowSize
    mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = backgroundColor
    mainFrame.Visible = false
    mainFrame.Parent = gui

    -- 美化 gay
    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Color3.fromRGB(80, 80, 80)
    stroke.Thickness = 1

    -- 陰影 gay
    local shadow = Instance.new("ImageLabel", mainFrame)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0.5, -15, 0.5, -15)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = -1

    -- 顯示/隱藏熱鍵
    local open = false
    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and table.find(toggleKeys, input.KeyCode) then
            open = not open
            local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25), {
                Size = open and windowSize or UDim2.new(0, 0, 0, 0)
            })
            if open then mainFrame.Visible = true end
            tween:Play()
            if not open then
                tween.Completed:Connect(function()
                    mainFrame.Visible = false
                end)
            end
        end
    end)

    local self = setmetatable({
        Gui = gui,
        Frame = mainFrame,
        Buttons = {},
    }, SafeUILib)

    return self
end

function SafeUILib:AddButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, 10 + (#self.Buttons * 35))
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.Parent = self.Frame

    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", button)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1

    -- Hover 效果 gay love
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end)

    -- 點擊執行
    button.MouseButton1Click:Connect(function()
        if callback then
            pcall(callback)
        end
    end)

    table.insert(self.Buttons, button)
end
function SafeUILib:AddKeybind(labelText, defaultKey, callback)
    local currentKey = defaultKey or Enum.KeyCode.E

    local label = Instance.new("TextButton")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, 10 + (#self.Buttons * 35))
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    label.Text = labelText .. " [" .. currentKey.Name .. "]"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.Parent = self.Frame

    local corner = Instance.new("UICorner", label)
    corner.CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", label)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1

    local listening = false

    label.MouseButton1Click:Connect(function()
        label.Text = labelText .. " [Press a key...]"
        listening = true
    end)

    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe then
            if listening then
                listening = false
                currentKey = input.KeyCode
                label.Text = labelText .. " [" .. currentKey.Name .. "]"
            elseif input.KeyCode == currentKey and callback then
                pcall(callback)
            end
        end
    end)

    table.insert(self.Buttons, label)
end
function SafeUILib:AddSlider(labelText, minValue, maxValue, defaultValue, callback)
    local value = defaultValue or minValue

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 10 + (#self.Buttons * 35))
    label.BackgroundTransparency = 1
    label.Text = string.format("%s: %d", labelText, value)
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = self.Frame

    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, -20, 0, 8)
    sliderBack.Position = label.Position + UDim2.new(0, 0, 0, 20)
    sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBack.Parent = self.Frame
    local backCorner = Instance.new("UICorner", sliderBack)
    backCorner.CornerRadius = UDim.new(0, 4)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((value - minValue)/(maxValue - minValue), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    sliderFill.Parent = sliderBack
    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.CornerRadius = UDim.new(0, 4)

    local dragging = false

    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - sliderBack.AbsolutePosition.X
            local percent = math.clamp(pos / sliderBack.AbsoluteSize.X, 0, 1)
            value = math.floor(minValue + (maxValue - minValue) * percent)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = string.format("%s: %d", labelText, value)
            if callback then
                pcall(callback, value)
            end
        end
    end)

    -- 塞兩個元素gay gay gay
    table.insert(self.Buttons, label)
    table.insert(self.Buttons, sliderBack)
end
function SafeUILib:AddToggle(labelText, defaultValue, callback)
    local state = defaultValue or false

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -20, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, 10 + (#self.Buttons * 35))
    toggle.BackgroundColor3 = state and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(40, 40, 40)
    toggle.Text = labelText .. (state and " [✓]" or " [ ]")
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.SourceSans
    toggle.TextSize = 14
    toggle.Parent = self.Frame

    local corner = Instance.new("UICorner", toggle)
    corner.CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", toggle)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1

    toggle.MouseEnter:Connect(function()
        TweenService:Create(toggle, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Color3.fromRGB(120, 220, 120) or Color3.fromRGB(60, 60, 60)
        }):Play()
    end)

    toggle.MouseLeave:Connect(function()
        TweenService:Create(toggle, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(40, 40, 40)
        }):Play()
    end)

    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = labelText .. (state and " [✓]" or " [ ]")
        TweenService:Create(toggle, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(40, 40, 40)
        }):Play()
        if callback then
            pcall(callback, state)
        end
    end)

    table.insert(self.Buttons, toggle)
end

return SafeUILib
