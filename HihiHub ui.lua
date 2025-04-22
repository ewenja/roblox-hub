local SafeUILib = {}
SafeUILib.__index = SafeUILib

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
function SafeUILib:CreateWindow(opts)
	opts = opts or {}
	local toggleKeys = opts.ToggleKeys or { Enum.KeyCode.RightControl, Enum.KeyCode.Insert }
	local windowName = opts.Name or tostring(math.random(100000, 999999))
	local windowSize = opts.Size or UDim2.new(0, 300, 0, 200)
	local backgroundColor = opts.BackgroundColor or Color3.fromRGB(30, 30, 30)

	local gui = Instance.new("ScreenGui")
	gui.Name = windowName
	gui.DisplayOrder = 999999
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = gethui and gethui() or game:GetService("CoreGui")

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "Main_" .. math.random(1, 1e6)
        mainFrame.Size = UDim2.new(windowSize.X.Scale, windowSize.X.Offset, windowSize.Y.Scale, windowSize.Y.Offset)
	mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = backgroundColor
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	mainFrame.Parent = gui

	local corner = Instance.new("UICorner", mainFrame)
	corner.CornerRadius = UDim.new(0, 6)

	-- UI 標題
	local lblName = "lbl_" .. tostring(math.random(10000, 99999))
	local t = Instance.new("TextLabel")
	t.Name = lblName
	t.Size = UDim2.new(1, 0, 0, 30)
	t.Position = UDim2.new(0, 0, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = opts.Name or ("Hub_" .. tostring(math.random(100, 999)))
	t.TextColor3 = Color3.fromRGB(255, 255, 255)
	t.Font = Enum.Font.SourceSansBold
	t.TextSize = 18
	t.TextStrokeTransparency = 0.8
	t.Parent = mainFrame

	-- 拖曳功能
	local dragging, dragStart, startPos
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

	-- 顯示/隱藏功能
	local open = false
	UIS.InputBegan:Connect(function(input, gpe)
		if not gpe and table.find(toggleKeys, input.KeyCode) then
			open = not open
			mainFrame.Visible = open
		end
	end)

	-- 建立滾動框
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "scroll_" .. math.random(100000, 999999)
	scroll.Size = UDim2.new(1, 0, 1, -30)
	scroll.Position = UDim2.new(0, 0, 0, 30)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.BackgroundTransparency = 1
	scroll.ScrollBarThickness = 4
	scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	scroll.Parent = mainFrame

	-- 回傳 UI 控制物件
	local self = setmetatable({
		Gui = gui,
		Frame = mainFrame,
		Scroll = scroll,
		Tabs = {},
		Buttons = {},
		NextY = 40
	}, SafeUILib)

	return self
end

function SafeUILib:AddButton(text, callback)
    self.Buttons = self.Buttons or {}
    local name = "btn_" .. math.random(100000, 999999)
    local parentFrame = self.Frame or self.__parent and self.__parent.Frame
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, self.NextY)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.Parent = self:GetParentFrame()

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
    self.Frame.Size = UDim2.new(self.Frame.Size.X.Scale, self.Frame.Size.X.Offset, 0, self.NextY + 10)
end
function SafeUILib:AddDropdown(title, options, defaultIndex, callback)
        self.Buttons = self.Buttons or {}
	local selectedIndex = defaultIndex or 1
	local selectedText = options[selectedIndex] or "Select"
        local parentFrame = self.Frame or self.__parent and self.__parent.Frame
	local dropdown = Instance.new("TextButton")
	dropdown.Name = "dropdown_" .. math.random(100000, 999999)
	dropdown.Size = UDim2.new(1, -20, 0, 30)
	dropdown.Position = UDim2.new(0, 10, 0, self.NextY)
	dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	dropdown.Text = title .. ": " .. selectedText
	dropdown.TextColor3 = Color3.new(1, 1, 1)
	dropdown.Font = Enum.Font.SourceSans
	dropdown.TextSize = 14
	dropdown.Parent = self:GetParentFrame()

	local corner = Instance.new("UICorner", dropdown)
	corner.CornerRadius = UDim.new(0, 6)

	local isOpen = false
	local optionButtons = {}

	dropdown.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		for _, btn in pairs(optionButtons) do
			btn.Visible = isOpen
		end
	end)

	for i, opt in ipairs(options) do
		local optBtn = Instance.new("TextButton")
		optBtn.Name = "opt_" .. math.random(100000, 999999)
		optBtn.Size = UDim2.new(1, -40, 0, 25)
		optBtn.Position = UDim2.new(0, 20, 0, self.NextY + 30 + ((i - 1) * 25))
		optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		optBtn.Text = opt
		optBtn.TextColor3 = Color3.new(1, 1, 1)
		optBtn.Font = Enum.Font.SourceSans
		optBtn.TextSize = 14
		optBtn.Visible = false
		optBtn.Parent = self:GetParentFrame()

		local btnCorner = Instance.new("UICorner", optBtn)
		btnCorner.CornerRadius = UDim.new(0, 6)

		optBtn.MouseButton1Click:Connect(function()
			selectedIndex = i
			selectedText = opt
			dropdown.Text = title .. ": " .. opt
			isOpen = false
			for _, b in pairs(optionButtons) do b.Visible = false end
			if callback then pcall(callback, opt) end
		end)

		table.insert(optionButtons, optBtn)
	end

	self.NextY = self.NextY + (#options * 25) + 40
end
function SafeUILib:AddTextbox(label, defaultText, callback)
        self.Buttons = self.Buttons or {}
        local parentFrame = self.Frame or self.__parent and self.__parent.Frame
	local textbox = Instance.new("TextBox")
	textbox.Name = "txt_" .. math.random(100000, 999999)
	textbox.Size = UDim2.new(1, -20, 0, 30)
	textbox.Position = UDim2.new(0, 10, 0, self.NextY)
	textbox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	textbox.PlaceholderText = label
	textbox.Text = defaultText or ""
	textbox.TextColor3 = Color3.new(1, 1, 1)
	textbox.Font = Enum.Font.SourceSans
	textbox.TextSize = 14
	textbox.ClearTextOnFocus = false
	textbox.Parent = self:GetParentFrame()

	local corner = Instance.new("UICorner", textbox)
	corner.CornerRadius = UDim.new(0, 6)

	textbox.FocusLost:Connect(function(enterPressed)
		if enterPressed and callback then
			pcall(callback, textbox.Text)
		end
	end)

	self.NextY = self.NextY + 35
        self.Frame.Size = UDim2.new(self.Frame.Size.X.Scale, self.Frame.Size.X.Offset, 0, self.NextY + 10)
end
function SafeUILib:Notify(text, duration)
	local notify = Instance.new("TextLabel")
	notify.Name = "notify_" .. math.random(100000, 999999)
	notify.Size = UDim2.new(0, 250, 0, 40)
	notify.Position = UDim2.new(1, -260, 1, -50)
	notify.AnchorPoint = Vector2.new(1, 1)
	notify.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	notify.Text = text
	notify.TextColor3 = Color3.new(1, 1, 1)
	notify.Font = Enum.Font.SourceSansBold
	notify.TextSize = 16
	notify.Parent = self.Gui

	local corner = Instance.new("UICorner", notify)
	corner.CornerRadius = UDim.new(0, 6)

	notify.BackgroundTransparency = 1
	notify.TextTransparency = 1
	notify:TweenSizeAndPosition(
		UDim2.new(0, 250, 0, 40),
		UDim2.new(1, -260, 1, -60),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.25,
		true
	)

	notify.BackgroundTransparency = 0
	notify.TextTransparency = 0

	task.delay(duration or 3, function()
		notify:Destroy()
	end)
end

function SafeUILib:AddToggle(text, default, callback)
    self.Buttons = self.Buttons or {}
    local name = "toggle_" .. math.random(100000, 999999)
    local state = default or false
    local parentFrame = self.Frame or self.__parent and self.__parent.Frame
    local toggle = Instance.new("TextButton")
    toggle.Name = name
    toggle.Size = UDim2.new(1, -20, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, self.NextY)
    toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(45, 45, 45)
    toggle.Text = text .. (state and " [✓]" or " [ ]")
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.SourceSans
    toggle.TextSize = 14
    toggle.Parent = self:GetParentFrame()

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
    self.Frame.Size = UDim2.new(self.Frame.Size.X.Scale, self.Frame.Size.X.Offset, 0, self.NextY + 10)
end

function SafeUILib:AddSlider(text, minValue, maxValue, defaultValue, callback)
    self.Buttons = self.Buttons or {}
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
    label.Parent = self:GetParentFrame()

    local sliderBack = Instance.new("Frame")
    sliderBack.Name = "bar_" .. math.random(100000,999999)
    sliderBack.Size = UDim2.new(1, -20, 0, 8)
    sliderBack.Position = UDim2.new(0, 10, 0, self.NextY + 20)
    sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBack.Parent = self:GetParentFrame()

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
    self.Frame.Size = UDim2.new(self.Frame.Size.X.Scale, self.Frame.Size.X.Offset, 0, self.NextY + 10)
end
function SafeUILib:AddTab(tabName)
    self.Buttons = self.Buttons or {}
    local tabId = "tab_" .. tostring(math.random(100000, 999999))
    local parentFrame = self.Frame or self.__parent and self.__parent.Frame
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = tabId
    tabFrame.Size = UDim2.new(1, 0, 0, 0) -- 高度會自動由 ScrollingFrame 控制
    tabFrame.BackgroundTransparency = 1
    tabFrame.AutomaticSize = Enum.AutomaticSize.Y
    tabFrame.Visible = false
    tabFrame.Parent = self.Scroll

    self.Tabs[tabName] = tabFrame

    return setmetatable({
        Frame = tabFrame,
        NextY = 10,
        Buttons = {},
        __parent = self
    }, SafeUILib)
end

function SafeUILib:AddKeybind(labelText, defaultKey, callback)
    self.Buttons = self.Buttons or {}
    local currentKey = defaultKey or Enum.KeyCode.E
    local listening = false
    local parentFrame = self.Frame or self.__parent and self.__parent.Frame
    local button = Instance.new("TextButton")
    button.Name = "keybind_" .. math.random(100000,999999)
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, self.NextY)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.Text = labelText .. " [" .. currentKey.Name .. "]"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.Parent = self:GetParentFrame()

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
    self.Frame.Size = UDim2.new(self.Frame.Size.X.Scale, self.Frame.Size.X.Offset, 0, self.NextY + 10)
end
function SafeUILib:SwitchTab(tabName)
    for name, tab in pairs(self.Tabs) do
        tab.Visible = (name == tabName)
    end
end
function SafeUILib:GetParentFrame()
    return self.Frame or (self.__parent and self.__parent.Frame)
end
-- 完整 return
return SafeUILib
