-- Solix Hub Style UI Library
-- Two-Column Layout with Transparent Background
-- Purple Theme
-- Created by Astral

local SolixUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Theme Colors (Purple)
local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(10, 10, 15),
    TopBar = Color3.fromRGB(8, 8, 12),
    Section = Color3.fromRGB(18, 18, 23),
    Element = Color3.fromRGB(22, 22, 27),
    Primary = Color3.fromRGB(130, 70, 200),      -- Violet
    Secondary = Color3.fromRGB(100, 50, 160),     -- Violet foncé
    Accent = Color3.fromRGB(160, 100, 230),       -- Violet clair
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 160),
    Toggle = Color3.fromRGB(130, 70, 200),
    ToggleOff = Color3.fromRGB(60, 60, 70),
    Slider = Color3.fromRGB(130, 70, 200),
    SliderBg = Color3.fromRGB(30, 30, 40),
    Border = Color3.fromRGB(40, 40, 50)
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
            Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)
end

-- Create Window
function SolixUI:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "Solix Hub"
    local ToggleKey = config.ToggleKey or Enum.KeyCode.V
    
    -- ScreenGui
    local SolixGui = Instance.new("ScreenGui")
    SolixGui.Name = "SolixHub_" .. HttpService:GenerateGUID(false)
    SolixGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SolixGui.ResetOnSpawn = false
    
    if gethui then
        SolixGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(SolixGui)
        SolixGui.Parent = game.CoreGui
    else
        SolixGui.Parent = game.CoreGui
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 780, 0, 520)
    MainFrame.Position = UDim2.new(0.5, -390, 0.5, -260)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = SolixGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Border
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.5
    MainStroke.Parent = MainFrame
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.3
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Theme.TopBar
    TopBar.BackgroundTransparency = 0.3
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowName
    Title.TextColor3 = Theme.Text
    Title.TextSize = 13
    Title.Font = Enum.Font.Gotham
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(1, -55, 0, 2.5)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Theme.Text
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TopBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -28, 0, 2.5)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "X"
    MinimizeButton.TextColor3 = Theme.Text
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    -- Minimize Message
    local MinimizeMessage = Instance.new("TextLabel")
    MinimizeMessage.Name = "MinimizeMessage"
    MinimizeMessage.Size = UDim2.new(0, 150, 0, 25)
    MinimizeMessage.Position = UDim2.new(1, -160, 1, -35)
    MinimizeMessage.BackgroundColor3 = Theme.Background
    MinimizeMessage.BackgroundTransparency = 0.2
    MinimizeMessage.BorderSizePixel = 0
    MinimizeMessage.Text = "Press V to open"
    MinimizeMessage.TextColor3 = Theme.Text
    MinimizeMessage.TextSize = 11
    MinimizeMessage.Font = Enum.Font.Gotham
    MinimizeMessage.Visible = false
    MinimizeMessage.Parent = SolixGui
    
    local MinimizeMsgCorner = Instance.new("UICorner")
    MinimizeMsgCorner.CornerRadius = UDim.new(0, 4)
    MinimizeMsgCorner.Parent = MinimizeMessage
    
    local MinimizeMsgStroke = Instance.new("UIStroke")
    MinimizeMsgStroke.Color = Theme.Primary
    MinimizeMsgStroke.Thickness = 1
    MinimizeMsgStroke.Parent = MinimizeMessage
    
    -- Minimize/Close functionality
    local isMinimized = false
    
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = true
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        task.wait(0.2)
        MainFrame.Visible = false
        MinimizeMessage.Visible = true
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        SolixGui:Destroy()
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -30)
    Sidebar.Position = UDim2.new(0, 0, 0, 30)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BackgroundTransparency = 0.3
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    -- Search Bar
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Name = "SearchFrame"
    SearchFrame.Size = UDim2.new(1, -10, 0, 30)
    SearchFrame.Position = UDim2.new(0, 5, 0, 5)
    SearchFrame.BackgroundColor3 = Theme.Element
    SearchFrame.BackgroundTransparency = 0.3
    SearchFrame.BorderSizePixel = 0
    SearchFrame.Parent = Sidebar
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 4)
    SearchCorner.Parent = SearchFrame
    
    local SearchIcon = Instance.new("TextLabel")
    SearchIcon.Size = UDim2.new(0, 20, 1, 0)
    SearchIcon.Position = UDim2.new(0, 5, 0, 0)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Text = "🔍"
    SearchIcon.TextColor3 = Theme.TextDark
    SearchIcon.TextSize = 12
    SearchIcon.Font = Enum.Font.Gotham
    SearchIcon.Parent = SearchFrame
    
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -30, 1, 0)
    SearchBox.Position = UDim2.new(0, 25, 0, 0)
    SearchBox.BackgroundTransparency = 1
    SearchBox.PlaceholderText = "Search.."
    SearchBox.PlaceholderColor3 = Theme.TextDark
    SearchBox.Text = ""
    SearchBox.TextColor3 = Theme.Text
    SearchBox.TextSize = 11
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = SearchFrame
    
    -- Tab List
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, -10, 1, -45)
    TabList.Position = UDim2.new(0, 5, 0, 40)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 3
    TabList.ScrollBarImageColor3 = Theme.Primary
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.Parent = Sidebar
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 2)
    TabListLayout.Parent = TabList
    
    -- Content Container (Two Columns)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -155, 1, -35)
    ContentContainer.Position = UDim2.new(0, 153, 0, 33)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    -- Resize Handle
    local ResizeHandle = Instance.new("Frame")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
    ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
    ResizeHandle.BackgroundColor3 = Theme.Primary
    ResizeHandle.BackgroundTransparency = 0.5
    ResizeHandle.BorderSizePixel = 0
    ResizeHandle.Parent = MainFrame
    
    local ResizeCorner = Instance.new("UICorner")
    ResizeCorner.CornerRadius = UDim.new(0, 3)
    ResizeCorner.Parent = ResizeHandle
    
    -- Resize functionality
    local resizing = false
    local resizeStart, sizeStart
    
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            sizeStart = MainFrame.AbsoluteSize
        end
    end)
    
    ResizeHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = math.max(600, sizeStart.X + delta.X)
            local newHeight = math.max(400, sizeStart.Y + delta.Y)
            MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    -- Make Draggable
    MakeDraggable(MainFrame, TopBar)
    
    -- Toggle UI
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == ToggleKey then
            if isMinimized then
                isMinimized = false
                MinimizeMessage.Visible = false
                MainFrame.Visible = true
                MainFrame.Size = UDim2.new(0, 0, 0, 0)
                Tween(MainFrame, {Size = UDim2.new(0, 780, 0, 520)}, 0.2)
            else
                isMinimized = true
                Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
                task.wait(0.2)
                MainFrame.Visible = false
                MinimizeMessage.Visible = true
            end
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
            LeftColumn = {},
            RightColumn = {}
        }
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. tabName
        TabButton.Size = UDim2.new(1, 0, 0, 28)
        TabButton.BackgroundColor3 = Theme.Element
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.Parent = TabList
        
        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Size = UDim2.new(0, 2, 1, -6)
        TabIndicator.Position = UDim2.new(0, 0, 0, 3)
        TabIndicator.BackgroundColor3 = Theme.Primary
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Visible = false
        TabIndicator.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -10, 1, 0)
        TabLabel.Position = UDim2.new(0, 10, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Theme.TextDark
        TabLabel.TextSize = 12
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content (Two Columns)
        local TabContent = Instance.new("Frame")
        TabContent.Name = "TabContent_" .. tabName
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        -- Left Column
        local LeftColumn = Instance.new("ScrollingFrame")
        LeftColumn.Name = "LeftColumn"
        LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)
        LeftColumn.Position = UDim2.new(0, 0, 0, 0)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.BorderSizePixel = 0
        LeftColumn.ScrollBarThickness = 4
        LeftColumn.ScrollBarImageColor3 = Theme.Primary
        LeftColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
        LeftColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y
        LeftColumn.Parent = TabContent
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 8)
        LeftLayout.Parent = LeftColumn
        
        local LeftPadding = Instance.new("UIPadding")
        LeftPadding.PaddingTop = UDim.new(0, 5)
        LeftPadding.PaddingBottom = UDim.new(0, 5)
        LeftPadding.PaddingRight = UDim.new(0, 5)
        LeftPadding.Parent = LeftColumn
        
        -- Right Column
        local RightColumn = Instance.new("ScrollingFrame")
        RightColumn.Name = "RightColumn"
        RightColumn.Size = UDim2.new(0.48, 0, 1, 0)
        RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
        RightColumn.BackgroundTransparency = 1
        RightColumn.BorderSizePixel = 0
        RightColumn.ScrollBarThickness = 4
        RightColumn.ScrollBarImageColor3 = Theme.Primary
        RightColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
        RightColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y
        RightColumn.Parent = TabContent
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 8)
        RightLayout.Parent = RightColumn
        
        local RightPadding = Instance.new("UIPadding")
        RightPadding.PaddingTop = UDim.new(0, 5)
        RightPadding.PaddingBottom = UDim.new(0, 5)
        RightPadding.PaddingLeft = UDim.new(0, 5)
        RightPadding.Parent = RightColumn
        
        Tab.LeftColumn = LeftColumn
        Tab.RightColumn = RightColumn
        Tab.Content = TabContent
        
        -- Tab Button Click
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                t.Button.BackgroundTransparency = 1
                t.Label.TextColor3 = Theme.TextDark
                t.Indicator.Visible = false
            end
            
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0.7
            TabLabel.TextColor3 = Theme.Text
            TabIndicator.Visible = true
            Window.CurrentTab = Tab
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                TabButton.BackgroundTransparency = 0.8
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                TabButton.BackgroundTransparency = 1
            end
        end)
        
        Tab.Button = TabButton
        Tab.Label = TabLabel
        Tab.Indicator = TabIndicator
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabButton.BackgroundTransparency = 0.7
            TabLabel.TextColor3 = Theme.Text
            TabIndicator.Visible = true
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end
        
        -- Tab Functions
        
        function Tab:AddSection(sectionName, column)
            column = column or "left"
            local parentColumn = column == "left" and LeftColumn or RightColumn
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section_" .. sectionName
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderSizePixel = 0
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.Parent = parentColumn
            
            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Padding = UDim.new(0, 5)
            SectionLayout.Parent = SectionFrame
            
            -- Section Title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, 0, 0, 25)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = Theme.Text
            SectionTitle.TextSize = 13
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            local Section = {
                Frame = SectionFrame,
                Column = column
            }
            
            function Section:AddToggle(config)
                config = config or {}
                local ToggleName = config.Name or "Toggle"
                local DefaultValue = config.Default or false
                local Callback = config.Callback or function() end
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "Toggle_" .. ToggleName
                ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
                ToggleFrame.BackgroundColor3 = Theme.Element
                ToggleFrame.BackgroundTransparency = 0.5
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Parent = SectionFrame
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 3)
                ToggleCorner.Parent = ToggleFrame
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -35, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 8, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = ToggleName
                ToggleLabel.TextColor3 = Theme.Text
                ToggleLabel.TextSize = 11
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleButton = Instance.new("Frame")
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Size = UDim2.new(0, 14, 0, 14)
                ToggleButton.Position = UDim2.new(1, -22, 0.5, -7)
                ToggleButton.BackgroundColor3 = Theme.ToggleOff
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Parent = ToggleFrame
                
                local ToggleCorner2 = Instance.new("UICorner")
                ToggleCorner2.CornerRadius = UDim.new(0, 3)
                ToggleCorner2.Parent = ToggleButton
                
                local toggled = DefaultValue
                
                local function UpdateToggle()
                    if toggled then
                        Tween(ToggleButton, {BackgroundColor3 = Theme.Toggle})
                    else
                        Tween(ToggleButton, {BackgroundColor3 = Theme.ToggleOff})
                    end
                    Callback(toggled)
                end
                
                local ToggleClick = Instance.new("TextButton")
                ToggleClick.Size = UDim2.new(1, 0, 1, 0)
                ToggleClick.BackgroundTransparency = 1
                ToggleClick.Text = ""
                ToggleClick.Parent = ToggleFrame
                
                ToggleClick.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    UpdateToggle()
                end)
                
                UpdateToggle()
                
                return ToggleFrame
            end
            
            function Section:AddSlider(config)
                config = config or {}
                local SliderName = config.Name or "Slider"
                local Min = config.Min or 0
                local Max = config.Max or 100
                local Default = config.Default or 50
                local Callback = config.Callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = "Slider_" .. SliderName
                SliderFrame.Size = UDim2.new(1, 0, 0, 45)
                SliderFrame.BackgroundColor3 = Theme.Element
                SliderFrame.BackgroundTransparency = 0.5
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Parent = SectionFrame
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 3)
                SliderCorner.Parent = SliderFrame
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(1, -60, 0, 18)
                SliderLabel.Position = UDim2.new(0, 8, 0, 5)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = SliderName
                SliderLabel.TextColor3 = Theme.Text
                SliderLabel.TextSize = 11
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Size = UDim2.new(0, 50, 0, 18)
                SliderValue.Position = UDim2.new(1, -55, 0, 5)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(Default)
                SliderValue.TextColor3 = Theme.Text
                SliderValue.TextSize = 11
                SliderValue.Font = Enum.Font.Gotham
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = SliderFrame
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "SliderBar"
                SliderBar.Size = UDim2.new(1, -16, 0, 5)
                SliderBar.Position = UDim2.new(0, 8, 1, -12)
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
                    Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
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
                
                return SliderFrame
            end
            
            function Section:AddDropdown(config)
                config = config or {}
                local DropdownName = config.Name or "Dropdown"
                local Options = config.Options or {"Option 1", "Option 2"}
                local Default = config.Default or Options[1]
                local Callback = config.Callback or function() end
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = "Dropdown_" .. DropdownName
                DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
                DropdownFrame.BackgroundColor3 = Theme.Element
                DropdownFrame.BackgroundTransparency = 0.5
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.ClipsDescendants = true
                DropdownFrame.Parent = SectionFrame
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 3)
                DropdownCorner.Parent = DropdownFrame
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Size = UDim2.new(1, -80, 0, 30)
                DropdownLabel.Position = UDim2.new(0, 8, 0, 0)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = DropdownName
                DropdownLabel.TextColor3 = Theme.Text
                DropdownLabel.TextSize = 11
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(0, 100, 0, 22)
                DropdownButton.Position = UDim2.new(1, -105, 0, 4)
                DropdownButton.BackgroundColor3 = Theme.SliderBg
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Text = Default
                DropdownButton.TextColor3 = Theme.Text
                DropdownButton.TextSize = 10
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.Parent = DropdownFrame
                
                local DropdownButtonCorner = Instance.new("UICorner")
                DropdownButtonCorner.CornerRadius = UDim.new(0, 3)
                DropdownButtonCorner.Parent = DropdownButton
                
                local DropdownArrow = Instance.new("TextLabel")
                DropdownArrow.Size = UDim2.new(0, 15, 1, 0)
                DropdownArrow.Position = UDim2.new(1, -15, 0, 0)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Text = "▼"
                DropdownArrow.TextColor3 = Theme.TextDark
                DropdownArrow.TextSize = 8
                DropdownArrow.Font = Enum.Font.Gotham
                DropdownArrow.Parent = DropdownButton
                
                local DropdownList = Instance.new("Frame")
                DropdownList.Name = "List"
                DropdownList.Size = UDim2.new(1, -16, 0, 0)
                DropdownList.Position = UDim2.new(0, 8, 0, 35)
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
                    OptionButton.Size = UDim2.new(1, 0, 0, 24)
                    OptionButton.BackgroundColor3 = Theme.SliderBg
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Theme.Text
                    OptionButton.TextSize = 10
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Parent = DropdownList
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 3)
                    OptionCorner.Parent = OptionButton
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selected = option
                        DropdownButton.Text = option
                        opened = false
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 30)}, 0.15)
                        Tween(DropdownArrow, {Rotation = 0}, 0.15)
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
                        local height = 35 + (#Options * 26)
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, height)}, 0.15)
                        Tween(DropdownArrow, {Rotation = 180}, 0.15)
                    else
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 30)}, 0.15)
                        Tween(DropdownArrow, {Rotation = 0}, 0.15)
                    end
                end)
                
                return DropdownFrame
            end
            
            function Section:AddLabel(config)
                config = config or {}
                local LabelText = config.Text or "Label"
                local Icon = config.Icon or ""
                
                local LabelFrame = Instance.new("Frame")
                LabelFrame.Name = "Label"
                LabelFrame.Size = UDim2.new(1, 0, 0, 25)
                LabelFrame.BackgroundColor3 = Theme.Element
                LabelFrame.BackgroundTransparency = 0.5
                LabelFrame.BorderSizePixel = 0
                LabelFrame.Parent = SectionFrame
                
                local LabelCorner = Instance.new("UICorner")
                LabelCorner.CornerRadius = UDim.new(0, 3)
                LabelCorner.Parent = LabelFrame
                
                local IconLabel = Instance.new("TextLabel")
                IconLabel.Size = UDim2.new(0, 20, 1, 0)
                IconLabel.Position = UDim2.new(0, 5, 0, 0)
                IconLabel.BackgroundTransparency = 1
                IconLabel.Text = Icon
                IconLabel.TextColor3 = Theme.Primary
                IconLabel.TextSize = 12
                IconLabel.Font = Enum.Font.Gotham
                IconLabel.Parent = LabelFrame
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -30, 1, 0)
                Label.Position = UDim2.new(0, Icon ~= "" and 25 or 8, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = LabelText
                Label.TextColor3 = Theme.Text
                Label.TextSize = 11
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = LabelFrame
                
                return LabelFrame
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

return SolixUI
