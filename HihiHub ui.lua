local SafeUILib = {}
SafeUILib.__index = SafeUILib

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

function SafeUILib:CreateWindow(opts)
	opts = opts or {}
	local toggleKeys = opts.ToggleKeys or { Enum.KeyCode.RightControl, Enum.KeyCode.Insert }
	local windowName = opts.Name or tostring(math.random(100000, 999999))
	local windowSize = opts.Size or UDim2.new(0, 300, 0, 200)
	local backgroundColor = opts.BackgroundColor or Color3.fromRGB(30,30,30)

	local gui = Instance.new("ScreenGui")
	gui.Name = windowName
	gui.DisplayOrder = 999999
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	if gethui then
		gui.Parent = gethui()
	else
		gui.Parent = game:GetService("CoreGui")
	end

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "Main_" .. math.random(1, 1e6)
	mainFrame.Size = windowSize
	mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = backgroundColor
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	mainFrame.Parent = gui

	local corner = Instance.new("UICorner", mainFrame)
	corner.CornerRadius = UDim.new(0, 6)

	-- 拖曳功能
	local dragging, dragInput, dragStart, startPos
	mainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	-- 顯示切換熱鍵
	local open = false
	UIS.InputBegan:Connect(function(input, gpe)
		if not gpe and table.find(toggleKeys, input.KeyCode) then
			open = not open
			mainFrame.Visible = open
		end
	end)

	local self = setmetatable({
		Gui = gui,
		Frame = mainFrame,
		Buttons = {},
		NextY = 10
	}, SafeUILib)

	return self
end
function SafeUILib:AddButton(text, callback)
    local name = "btn_" .. math.random(100000, 999999)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, self.NextY)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.Parent = self.Frame

    local corner = Instance.new("UICorner", button)
    corner.Name = "corner_" .. math.random(1000,9999)
    corner.CornerRadius = UDim.new(0, 6)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)

    button.MouseButton1Click:Connect(function()
        if callback then
            pcall(callback)
        end
    end)

    table.insert(self.Buttons, button)
    self.NextY = self.NextY + 35
end

function SafeUILib:AddToggle(text, default, callback)
    local name = "toggle_" .. math.random(100000, 999999)
    local state = default or false

    local toggle = Instance.new("TextButton")
    toggle.Name = name
    toggle.Size = UDim2.new(1, -20, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, self.NextY)
    toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(45, 45, 45)
    toggle.Text = text .. (state and " [✓]" or " [ ]")
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.SourceSans
    toggle.TextSize = 14
    toggle.Parent = self.Frame

    local corner = Instance.new("UICorner", toggle)
    corner.Name = "corner_" .. math.random(1000,9999)
    corner.CornerRadius = UDim.new(0, 6)

    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = text .. (state and " [✓]" or " [ ]")
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(45, 45, 45)
        if callback then
            pcall(callback, state)
        end
    end)

    table.insert(self.Buttons, toggle)
    self.NextY = self.NextY + 35
end

function SafeUILib:AddSlider(text, minValue, maxValue, defaultValue, callback)
    local value = defaultValue or minValue

    local label = Instance.new("TextLabel")
    label.Name = "lbl_" .. math.random(100000,999999)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, self.NextY)
    label.BackgroundTransparency = 1
    label.Text = string.format("%s: %d", text, value)
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = self.Frame

    local sliderBack = Instance.new("Frame")
    sliderBack.Name = "bar_" .. math.random(100000,999999)
    sliderBack.Size = UDim2.new(1, -20, 0, 8)
    sliderBack.Position = UDim2.new(0, 10, 0, self.NextY + 20)
    sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBack.Parent = self.Frame

    local backCorner = Instance.new("UICorner", sliderBack)
    backCorner.Name = "corner_" .. math.random(1000,9999)
    backCorner.CornerRadius = UDim.new(0, 4)

    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "fill_" .. math.random(100000,999999)
    sliderFill.Size = UDim2.new((value - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.Parent = sliderBack

    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.Name = "corner_" .. math.random(1000,9999)
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
            label.Text = string.format("%s: %d", text, value)
            if callback then
                pcall(callback, value)
            end
        end
    end)

    self.NextY = self.NextY + 40
end

function SafeUILib:AddKeybind(labelText, defaultKey, callback)
    local currentKey = defaultKey or Enum.KeyCode.E
    local listening = false

    local button = Instance.new("TextButton")
    button.Name = "keybind_" .. math.random(100000,999999)
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, self.NextY)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.Text = labelText .. " [" .. currentKey.Name .. "]"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.Parent = self.Frame

    local corner = Instance.new("UICorner", button)
    corner.Name = "corner_" .. math.random(1000,9999)
    corner.CornerRadius = UDim.new(0, 6)

    button.MouseButton1Click:Connect(function()
        button.Text = labelText .. " [Press a key...]"
        listening = true
    end)

    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe then
            if listening then
                listening = false
                currentKey = input.KeyCode
                button.Text = labelText .. " [" .. currentKey.Name .. "]"
            elseif input.KeyCode == currentKey then
                if callback then pcall(callback) end
            end
        end
    end)

    self.NextY = self.NextY + 35
end
self.NextY = 10
self.Buttons = {}
-- 完整 return
return SafeUILib
