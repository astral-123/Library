-- Nebula Hub Library
-- Modern UI Library with Left Sidebar
-- Purple Theme
-- By Astral

local NebulaHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Theme Colors (Purple)
local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Sidebar = Color3.fromRGB(15, 15, 20),
    TabButton = Color3.fromRGB(25, 25, 30),
    TabButtonActive = Color3.fromRGB(100, 50, 150),
    Primary = Color3.fromRGB(130, 70, 200),
    Secondary = Color3.fromRGB(100, 50, 150),
    Accent = Color3.fromRGB(160, 100, 230),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 160),
    Border = Color3.fromRGB(40, 40, 50),
    Toggle = Color3.fromRGB(130, 70, 200),
    Slider = Color3.fromRGB(130, 70, 200),
    SliderBg = Color3.fromRGB(30, 30, 35)
}

-- Utility Functions
local function Tween(instance, properties, duration)
    duration = duration or 0.2
    local tween = TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quad), properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragFrame)
    dragFrame = dragFrame or frame
    local dragging, dragInput, dragStart, startPos
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
        end
    end)
end

-- Create Window
function NebulaHub:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "Nebula Hub"
    local ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    
    -- ScreenGui
    local NebulaGui = Instance.new("ScreenGui")
    NebulaGui.Name = "NebulaHub_" .. HttpService:GenerateGUID(false)
    NebulaGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NebulaGui.ResetOnSpawn = false
    
    if gethui then
        NebulaGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(NebulaGui)
        NebulaGui.Parent = game.CoreGui
    else
        NebulaGui.Parent = game.CoreGui
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = NebulaGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Theme.Sidebar
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0, 20)
    TopBarCover.Position = UDim2.new(0, 0, 1, -20)
    TopBarCover.BackgroundColor3 = Theme.Sidebar
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowName
    Title.TextColor3 = Theme.Text
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Theme.TabButton
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Theme.Text
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        NebulaGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)})
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Theme.TabButton})
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar
    
    local SidebarCover = Instance.new("Frame")
    SidebarCover.Size = UDim2.new(0, 20, 1, 0)
    SidebarCover.Position = UDim2.new(1, -20, 0, 0)
    SidebarCover.BackgroundColor3 = Theme.Sidebar
    SidebarCover.BorderSizePixel = 0
    SidebarCover.Parent = Sidebar
    
    local SidebarCover2 = Instance.new("Frame")
    SidebarCover2.Size = UDim2.new(1, 0, 0, 20)
    SidebarCover2.Position = UDim2.new(0, 0, 0, -20)
    SidebarCover2.BackgroundColor3 = Theme.Sidebar
    SidebarCover2.BorderSizePixel = 0
    SidebarCover2.Parent = Sidebar
    
    -- Tab List
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, -10, 1, -10)
    TabList.Position = UDim2.new(0, 5, 0, 5)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 4
    TabList.ScrollBarImageColor3 = Theme.Primary
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.Parent = Sidebar
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabList
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -170, 1, -50)
    ContentFrame.Position = UDim2.new(0, 165, 0, 45)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    
    -- Make Draggable
    MakeDraggable(MainFrame, TopBar)
    
    -- Toggle UI
    local UIVisible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == ToggleKey then
            UIVisible = not UIVisible
            MainFrame.Visible = UIVisible
        end
    end)
    
    -- Window Object
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    -- Create Tab
    function Window:CreateTab(tabName)
        local Tab = {
            Name = tabName,
            Elements = {},
            Sections = {}
        }
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. tabName
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.BackgroundColor3 = Theme.TabButton
        TabButton.BorderSizePixel = 0
        TabButton.Text = "  " .. tabName
        TabButton.TextColor3 = Theme.TextDark
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = TabList
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Size = UDim2.new(0, 3, 0, 20)
        TabIndicator.Position = UDim2.new(0, 0, 0.5, -10)
        TabIndicator.BackgroundColor3 = Theme.Primary
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Visible = false
        TabIndicator.Parent = TabButton
        
        local TabIndicatorCorner = Instance.new("UICorner")
        TabIndicatorCorner.CornerRadius = UDim.new(1, 0)
        TabIndicatorCorner.Parent = TabIndicator
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tabName
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = Theme.Primary
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Visible = false
        TabContent.Parent = ContentFrame
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 8)
        TabContentLayout.Parent = TabContent
        
        local TabContentPadding = Instance.new("UIPadding")
        TabContentPadding.PaddingTop = UDim.new(0, 5)
        TabContentPadding.PaddingBottom = UDim.new(0, 5)
        TabContentPadding.PaddingLeft = UDim.new(0, 5)
        TabContentPadding.PaddingRight = UDim.new(0, 10)
        TabContentPadding.Parent = TabContent
        
        Tab.Content = TabContent
        
        -- Tab Button Click
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                t.Button.BackgroundColor3 = Theme.TabButton
                t.Button.TextColor3 = Theme.TextDark
                t.Indicator.Visible = false
            end
            
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Theme.TabButtonActive
            TabButton.TextColor3 = Theme.Text
            TabIndicator.Visible = true
            Window.CurrentTab = Tab
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Theme.TabButtonActive})
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Theme.TabButton})
            end
        end)
        
        Tab.Button = TabButton
        Tab.Indicator = TabIndicator
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabButton.BackgroundColor3 = Theme.TabButtonActive
            TabButton.TextColor3 = Theme.Text
            TabIndicator.Visible = true
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end
        
        -- Tab Functions
        
        -- Create Section
        function Tab:CreateSection(sectionName)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section_" .. sectionName
            SectionFrame.Size = UDim2.new(1, 0, 0, 30)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = sectionName
            SectionLabel.TextColor3 = Theme.Primary
            SectionLabel.TextSize = 14
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = SectionFrame
            
            local SectionLine = Instance.new("Frame")
            SectionLine.Size = UDim2.new(1, 0, 0, 1)
            SectionLine.Position = UDim2.new(0, 0, 1, -1)
            SectionLine.BackgroundColor3 = Theme.Border
            SectionLine.BorderSizePixel = 0
            SectionLine.Parent = SectionFrame
            
            table.insert(Tab.Sections, SectionFrame)
            return SectionFrame
        end
        
        -- Create Toggle
        function Tab:CreateToggle(config)
            config = config or {}
            local ToggleName = config.Name or "Toggle"
            local DefaultValue = config.Default or false
            local Callback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle_" .. ToggleName
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Theme.TabButton
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = ToggleName
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 13
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleButton.BackgroundColor3 = Theme.SliderBg
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "Circle"
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
            ToggleCircle.BackgroundColor3 = Theme.TextDark
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local ToggleCircleCorner = Instance.new("UICorner")
            ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCircleCorner.Parent = ToggleCircle
            
            local toggled = DefaultValue
            
            local function UpdateToggle()
                if toggled then
                    Tween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Theme.Toggle})
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Primary})
                else
                    Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Theme.TextDark})
                    Tween(ToggleButton, {BackgroundColor3 = Theme.SliderBg})
                end
                Callback(toggled)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
            end)
            
            UpdateToggle()
            
            table.insert(Tab.Elements, ToggleFrame)
            return ToggleFrame
        end
        
        -- Create Slider
        function Tab:CreateSlider(config)
            config = config or {}
            local SliderName = config.Name or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or 50
            local Callback = config.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider_" .. SliderName
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Theme.TabButton
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -80, 0, 20)
            SliderLabel.Position = UDim2.new(0, 12, 0, 8)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = SliderName
            SliderLabel.TextColor3 = Theme.Text
            SliderLabel.TextSize = 13
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 60, 0, 20)
            SliderValue.Position = UDim2.new(1, -70, 0, 8)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(Default)
            SliderValue.TextColor3 = Theme.Primary
            SliderValue.TextSize = 13
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Name = "SliderBar"
            SliderBar.Size = UDim2.new(1, -24, 0, 6)
            SliderBar.Position = UDim2.new(0, 12, 1, -16)
            SliderBar.BackgroundColor3 = Theme.SliderBg
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Theme.Slider
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local dragging = false
            local value = Default
            
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor(Min + (Max - Min) * pos)
                SliderValue.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                Callback(value)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            table.insert(Tab.Elements, SliderFrame)
            return SliderFrame
        end
        
        -- Create Button
        function Tab:CreateButton(config)
            config = config or {}
            local ButtonName = config.Name or "Button"
            local Callback = config.Callback or function() end
            
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = "Button_" .. ButtonName
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Theme.Primary
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Text = ButtonName
            ButtonFrame.TextColor3 = Theme.Text
            ButtonFrame.TextSize = 13
            ButtonFrame.Font = Enum.Font.GothamBold
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = ButtonFrame
            
            ButtonFrame.MouseButton1Click:Connect(function()
                Callback()
            end)
            
            ButtonFrame.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Accent})
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Primary})
            end)
            
            table.insert(Tab.Elements, ButtonFrame)
            return ButtonFrame
        end
        
        -- Create Dropdown
        function Tab:CreateDropdown(config)
            config = config or {}
            local DropdownName = config.Name or "Dropdown"
            local Options = config.Options or {"Option 1", "Option 2"}
            local Default = config.Default or Options[1]
            local Callback = config.Callback or function() end
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown_" .. DropdownName
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundColor3 = Theme.TabButton
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -100, 0, 40)
            DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = DropdownName
            DropdownLabel.TextColor3 = Theme.Text
            DropdownLabel.TextSize = 13
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0, 120, 0, 30)
            DropdownButton.Position = UDim2.new(1, -130, 0, 5)
            DropdownButton.BackgroundColor3 = Theme.SliderBg
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Text = Default
            DropdownButton.TextColor3 = Theme.Text
            DropdownButton.TextSize = 12
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.Parent = DropdownFrame
            
            local DropdownButtonCorner = Instance.new("UICorner")
            DropdownButtonCorner.CornerRadius = UDim.new(0, 6)
            DropdownButtonCorner.Parent = DropdownButton
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            DropdownArrow.Position = UDim2.new(1, -20, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Theme.TextDark
            DropdownArrow.TextSize = 10
            DropdownArrow.Font = Enum.Font.Gotham
            DropdownArrow.Parent = DropdownButton
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "List"
            DropdownList.Size = UDim2.new(1, -24, 0, 0)
            DropdownList.Position = UDim2.new(0, 12, 0, 45)
            DropdownList.BackgroundTransparency = 1
            DropdownList.BorderSizePixel = 0
            DropdownList.Parent = DropdownFrame
            
            local DropdownListLayout = Instance.new("UIListLayout")
            DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownListLayout.Padding = UDim.new(0, 2)
            DropdownListLayout.Parent = DropdownList
            
            local opened = false
            local selected = Default
            
            for i, option in ipairs(Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = Theme.SliderBg
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = Theme.Text
                OptionButton.TextSize = 12
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Parent = DropdownList
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    DropdownButton.Text = option
                    opened = false
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    Callback(option)
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Theme.Primary})
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Theme.SliderBg})
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                opened = not opened
                if opened then
                    local height = 45 + (#Options * 32)
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 180}, 0.2)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                end
            end)
            
            table.insert(Tab.Elements, DropdownFrame)
            return DropdownFrame
        end
        
        -- Create Label
        function Tab:CreateLabel(labelText)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label"
            LabelFrame.Size = UDim2.new(1, 0, 0, 30)
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = labelText
            Label.TextColor3 = Theme.TextDark
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = LabelFrame
            
            table.insert(Tab.Elements, LabelFrame)
            return LabelFrame
        end
        
        return Tab
    end
    
    return Window
end

return NebulaHub
