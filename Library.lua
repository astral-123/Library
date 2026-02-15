-- By Astral
--q

local NebulaUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Theme Colors
local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(10, 10, 15),
    TopBar = Color3.fromRGB(8, 8, 12),
    Element = Color3.fromRGB(22, 22, 27),
    Primary = Color3.fromRGB(130, 70, 200),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 160),
    Toggle = Color3.fromRGB(130, 70, 200),
    ToggleOff = Color3.fromRGB(60, 60, 70),
    Slider = Color3.fromRGB(130, 70, 200),
    SliderBg = Color3.fromRGB(30, 30, 40),
    Border = Color3.fromRGB(40, 40, 50)
}

-- Thèmes disponibles
local Themes = {
    ["Default"] = {
        Background = Color3.fromRGB(15, 15, 20),
        Sidebar = Color3.fromRGB(10, 10, 15),
        TopBar = Color3.fromRGB(8, 8, 12),
        Element = Color3.fromRGB(22, 22, 27),
        Primary = Color3.fromRGB(130, 70, 200),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 160),
        Toggle = Color3.fromRGB(130, 70, 200),
        ToggleOff = Color3.fromRGB(60, 60, 70),
        Slider = Color3.fromRGB(130, 70, 200),
        SliderBg = Color3.fromRGB(30, 30, 40),
        Border = Color3.fromRGB(40, 40, 50)
    },
    ["AmberGlow"] = {
        Background = Color3.fromRGB(20, 15, 10),
        Sidebar = Color3.fromRGB(15, 12, 8),
        TopBar = Color3.fromRGB(12, 10, 7),
        Element = Color3.fromRGB(27, 22, 17),
        Primary = Color3.fromRGB(255, 170, 0),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 160, 140),
        Toggle = Color3.fromRGB(255, 170, 0),
        ToggleOff = Color3.fromRGB(70, 60, 50),
        Slider = Color3.fromRGB(255, 170, 0),
        SliderBg = Color3.fromRGB(40, 35, 25),
        Border = Color3.fromRGB(50, 45, 35)
    },
    ["Amethyst"] = {
        Background = Color3.fromRGB(18, 10, 25),
        Sidebar = Color3.fromRGB(13, 8, 20),
        TopBar = Color3.fromRGB(10, 6, 17),
        Element = Color3.fromRGB(25, 15, 32),
        Primary = Color3.fromRGB(155, 89, 182),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(170, 150, 180),
        Toggle = Color3.fromRGB(155, 89, 182),
        ToggleOff = Color3.fromRGB(65, 55, 75),
        Slider = Color3.fromRGB(155, 89, 182),
        SliderBg = Color3.fromRGB(35, 25, 45),
        Border = Color3.fromRGB(45, 35, 55)
    },
    ["Bloom"] = {
        Background = Color3.fromRGB(25, 15, 20),
        Sidebar = Color3.fromRGB(20, 12, 17),
        TopBar = Color3.fromRGB(17, 10, 14),
        Element = Color3.fromRGB(32, 20, 27),
        Primary = Color3.fromRGB(255, 105, 180),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(190, 150, 170),
        Toggle = Color3.fromRGB(255, 105, 180),
        ToggleOff = Color3.fromRGB(75, 60, 70),
        Slider = Color3.fromRGB(255, 105, 180),
        SliderBg = Color3.fromRGB(45, 30, 40),
        Border = Color3.fromRGB(55, 40, 50)
    },
    ["DarkBlue"] = {
        Background = Color3.fromRGB(10, 15, 25),
        Sidebar = Color3.fromRGB(8, 12, 20),
        TopBar = Color3.fromRGB(6, 10, 17),
        Element = Color3.fromRGB(15, 22, 32),
        Primary = Color3.fromRGB(52, 152, 219),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 170, 190),
        Toggle = Color3.fromRGB(52, 152, 219),
        ToggleOff = Color3.fromRGB(55, 65, 75),
        Slider = Color3.fromRGB(52, 152, 219),
        SliderBg = Color3.fromRGB(25, 35, 45),
        Border = Color3.fromRGB(35, 45, 55)
    },
    ["Green"] = {
        Background = Color3.fromRGB(10, 20, 15),
        Sidebar = Color3.fromRGB(8, 15, 12),
        TopBar = Color3.fromRGB(6, 12, 10),
        Element = Color3.fromRGB(15, 27, 22),
        Primary = Color3.fromRGB(46, 204, 113),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 180, 160),
        Toggle = Color3.fromRGB(46, 204, 113),
        ToggleOff = Color3.fromRGB(55, 70, 60),
        Slider = Color3.fromRGB(46, 204, 113),
        SliderBg = Color3.fromRGB(25, 40, 30),
        Border = Color3.fromRGB(35, 50, 40)
    },
    ["Ocean"] = {
        Background = Color3.fromRGB(10, 20, 30),
        Sidebar = Color3.fromRGB(8, 16, 25),
        TopBar = Color3.fromRGB(6, 13, 20),
        Element = Color3.fromRGB(15, 27, 37),
        Primary = Color3.fromRGB(26, 188, 156),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 180, 190),
        Toggle = Color3.fromRGB(26, 188, 156),
        ToggleOff = Color3.fromRGB(55, 70, 80),
        Slider = Color3.fromRGB(26, 188, 156),
        SliderBg = Color3.fromRGB(25, 40, 50),
        Border = Color3.fromRGB(35, 50, 60)
    },
    ["Serenity"] = {
        Background = Color3.fromRGB(15, 20, 25),
        Sidebar = Color3.fromRGB(12, 17, 22),
        TopBar = Color3.fromRGB(10, 14, 18),
        Element = Color3.fromRGB(20, 27, 32),
        Primary = Color3.fromRGB(108, 92, 231),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(160, 170, 180),
        Toggle = Color3.fromRGB(108, 92, 231),
        ToggleOff = Color3.fromRGB(60, 65, 75),
        Slider = Color3.fromRGB(108, 92, 231),
        SliderBg = Color3.fromRGB(30, 40, 45),
        Border = Color3.fromRGB(40, 50, 55)
    },
    ["Crimson"] = {
        Background = Color3.fromRGB(20, 10, 10),
        Sidebar = Color3.fromRGB(17, 8, 8),
        TopBar = Color3.fromRGB(14, 7, 7),
        Element = Color3.fromRGB(27, 15, 15),
        Primary = Color3.fromRGB(231, 76, 60),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(190, 150, 150),
        Toggle = Color3.fromRGB(231, 76, 60),
        ToggleOff = Color3.fromRGB(75, 55, 55),
        Slider = Color3.fromRGB(231, 76, 60),
        SliderBg = Color3.fromRGB(40, 25, 25),
        Border = Color3.fromRGB(50, 35, 35)
    },
    ["Sunset"] = {
        Background = Color3.fromRGB(22, 15, 18),
        Sidebar = Color3.fromRGB(18, 12, 15),
        TopBar = Color3.fromRGB(15, 10, 12),
        Element = Color3.fromRGB(28, 20, 24),
        Primary = Color3.fromRGB(255, 121, 63),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(190, 160, 170),
        Toggle = Color3.fromRGB(255, 121, 63),
        ToggleOff = Color3.fromRGB(70, 60, 65),
        Slider = Color3.fromRGB(255, 121, 63),
        SliderBg = Color3.fromRGB(38, 30, 33),
        Border = Color3.fromRGB(48, 40, 43)
    }
}

-- Config System
local ConfigSystem = {
    Flags = {}
}

-- Utility Functions
local function Tween(instance, properties, duration, style)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quart
    local tween = TweenService:Create(instance, TweenInfo.new(duration, style, Enum.EasingDirection.Out), properties)
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
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Fonction pour appliquer un thème
local function ApplyTheme(themeName, guiElements)
    local theme = Themes[themeName] or Themes["Default"]
    
    for key, value in pairs(theme) do
        Theme[key] = value
    end
    
    if guiElements then
        for _, element in pairs(guiElements) do
            if element.Type == "Background" then
                Tween(element.Instance, {BackgroundColor3 = theme.Background}, 0.3)
            elseif element.Type == "Sidebar" then
                Tween(element.Instance, {BackgroundColor3 = theme.Sidebar}, 0.3)
            elseif element.Type == "TopBar" then
                Tween(element.Instance, {BackgroundColor3 = theme.TopBar}, 0.3)
            elseif element.Type == "Element" then
                Tween(element.Instance, {BackgroundColor3 = theme.Element}, 0.3)
            elseif element.Type == "Primary" then
                Tween(element.Instance, {BackgroundColor3 = theme.Primary}, 0.3)
            elseif element.Type == "Border" then
                if element.Instance:IsA("UIStroke") then
                    Tween(element.Instance, {Color = theme.Border}, 0.3)
                end
            elseif element.Type == "PrimaryBorder" then
                if element.Instance:IsA("UIStroke") then
                    Tween(element.Instance, {Color = theme.Primary}, 0.3)
                end
            end
        end
    end
end

-- Create Window
function NebulaUI:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "Nebula Hub"
    local ToggleKey = config.ToggleKey or Enum.KeyCode.V
    local KeySystem = config.KeySystem or false
    local Key = config.Key or "NebulaHub2024"
    local Resizable = config.Resizable or true
    
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
    
    local GUIElements = {}
    
    local NotificationContainer = Instance.new("Frame")
    NotificationContainer.Name = "NotificationContainer"
    NotificationContainer.Size = UDim2.new(0, 300, 1, 0)
    NotificationContainer.Position = UDim2.new(1, -310, 0, 10)
    NotificationContainer.BackgroundTransparency = 1
    NotificationContainer.Parent = NebulaGui
    
    local NotificationLayout = Instance.new("UIListLayout")
    NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotificationLayout.Padding = UDim.new(0, 10)
    NotificationLayout.Parent = NotificationContainer
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -390, 0.5, -260)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = not KeySystem
    MainFrame.Parent = NebulaGui
    
    table.insert(GUIElements, {Type = "Background", Instance = MainFrame})
    
    if not KeySystem then
        Tween(MainFrame, {Size = UDim2.new(0, 780, 0, 520)}, 0.5, Enum.EasingStyle.Back)
    end
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Border
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.5
    MainStroke.Parent = MainFrame
    
    table.insert(GUIElements, {Type = "Border", Instance = MainStroke})
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Theme.TopBar
    TopBar.BackgroundTransparency = 0.3
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    table.insert(GUIElements, {Type = "TopBar", Instance = TopBar})
    
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
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -28, 0, 2.5)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Theme.Text
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
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
    MinimizeMessage.Parent = NebulaGui
    
    table.insert(GUIElements, {Type = "Background", Instance = MinimizeMessage})
    
    local MinimizeMsgCorner = Instance.new("UICorner")
    MinimizeMsgCorner.CornerRadius = UDim.new(0, 4)
    MinimizeMsgCorner.Parent = MinimizeMessage
    
    local MinimizeMsgStroke = Instance.new("UIStroke")
    MinimizeMsgStroke.Color = Theme.Primary
    MinimizeMsgStroke.Thickness = 1
    MinimizeMsgStroke.Parent = MinimizeMessage
    
    table.insert(GUIElements, {Type = "PrimaryBorder", Instance = MinimizeMsgStroke})
    
    local isMinimized = false
    
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = true
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
        task.wait(0.3)
        MainFrame.Visible = false
        MinimizeMessage.Visible = true
        Tween(MinimizeMessage, {BackgroundTransparency = 0.1}, 0.2)
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
        task.wait(0.3)
        NebulaGui:Destroy()
    end)
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -30)
    Sidebar.Position = UDim2.new(0, 0, 0, 30)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BackgroundTransparency = 0.3
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    table.insert(GUIElements, {Type = "Sidebar", Instance = Sidebar})
    
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Name = "SearchFrame"
    SearchFrame.Size = UDim2.new(1, -10, 0, 30)
    SearchFrame.Position = UDim2.new(0, 5, 0, 5)
    SearchFrame.BackgroundColor3 = Theme.Element
    SearchFrame.BackgroundTransparency = 0.3
    SearchFrame.BorderSizePixel = 0
    SearchFrame.Parent = Sidebar
    
    table.insert(GUIElements, {Type = "Element", Instance = SearchFrame})
    
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
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -155, 1, -35)
    ContentContainer.Position = UDim2.new(0, 153, 0, 33)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    if Resizable then
        local ResizeHandle = Instance.new("Frame")
        ResizeHandle.Name = "ResizeHandle"
        ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
        ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
        ResizeHandle.BackgroundColor3 = Theme.Primary
        ResizeHandle.BackgroundTransparency = 0.5
        ResizeHandle.BorderSizePixel = 0
        ResizeHandle.Parent = MainFrame
        
        table.insert(GUIElements, {Type = "Primary", Instance = ResizeHandle})
        
        local ResizeCorner = Instance.new("UICorner")
        ResizeCorner.CornerRadius = UDim.new(0, 3)
        ResizeCorner.Parent = ResizeHandle
        
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
    end
    
    MakeDraggable(MainFrame, TopBar)
    
    local currentToggleKey = ToggleKey
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == currentToggleKey then
            if isMinimized then
                isMinimized = false
                MinimizeMessage.Visible = false
                MainFrame.Visible = true
                MainFrame.Size = UDim2.new(0, 0, 0, 0)
                Tween(MainFrame, {Size = UDim2.new(0, 780, 0, 520)}, 0.4, Enum.EasingStyle.Back)
            else
                isMinimized = true
                Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
                task.wait(0.3)
                MainFrame.Visible = false
                MinimizeMessage.Visible = true
            end
        end
    end)
    
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        ToggleKey = currentToggleKey,
        GUIElements = GUIElements,
        HasSettingsTab = false
    }
    
    function Window:Notification(config)
        config = config or {}
        local NotifTitle = config.Title or "Notification"
        local NotifText = config.Text or "This is a notification"
        local Duration = config.Duration or 3
        
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(1, 0, 0, 0)
        NotifFrame.BackgroundColor3 = Theme.Background
        NotifFrame.BackgroundTransparency = 0.1
        NotifFrame.BorderSizePixel = 0
        NotifFrame.ClipsDescendants = true
        NotifFrame.Parent = NotificationContainer
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 6)
        NotifCorner.Parent = NotifFrame
        
        local NotifStroke = Instance.new("UIStroke")
        NotifStroke.Color = Theme.Primary
        NotifStroke.Thickness = 1
        NotifStroke.Parent = NotifFrame
        
        local NotifLayout = Instance.new("UIListLayout")
        NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
        NotifLayout.Padding = UDim.new(0, 5)
        NotifLayout.Parent = NotifFrame
        
        local NotifPadding = Instance.new("UIPadding")
        NotifPadding.PaddingTop = UDim.new(0, 10)
        NotifPadding.PaddingBottom = UDim.new(0, 10)
        NotifPadding.PaddingLeft = UDim.new(0, 10)
        NotifPadding.PaddingRight = UDim.new(0, 10)
        NotifPadding.Parent = NotifFrame
        
        local NotifTitleLabel = Instance.new("TextLabel")
        NotifTitleLabel.Size = UDim2.new(1, 0, 0, 18)
        NotifTitleLabel.BackgroundTransparency = 1
        NotifTitleLabel.Text = NotifTitle
        NotifTitleLabel.TextColor3 = Theme.Text
        NotifTitleLabel.TextSize = 13
        NotifTitleLabel.Font = Enum.Font.GothamBold
        NotifTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitleLabel.Parent = NotifFrame
        
        local NotifTextLabel = Instance.new("TextLabel")
        NotifTextLabel.Size = UDim2.new(1, 0, 0, 0)
        NotifTextLabel.BackgroundTransparency = 1
        NotifTextLabel.Text = NotifText
        NotifTextLabel.TextColor3 = Theme.TextDark
        NotifTextLabel.TextSize = 11
        NotifTextLabel.Font = Enum.Font.Gotham
        NotifTextLabel.TextXAlignment = Enum.TextXAlignment.Left
        NotifTextLabel.TextWrapped = true
        NotifTextLabel.TextYAlignment = Enum.TextYAlignment.Top
        NotifTextLabel.AutomaticSize = Enum.AutomaticSize.Y
        NotifTextLabel.Parent = NotifFrame
        
        NotifFrame.Size = UDim2.new(1, 0, 0, NotifTitleLabel.AbsoluteSize.Y + NotifTextLabel.AbsoluteSize.Y + 25)
        
        Tween(NotifFrame, {BackgroundTransparency = 0.1}, 0.3)
        
        task.delay(Duration, function()
            Tween(NotifFrame, {BackgroundTransparency = 1}, 0.3)
            Tween(NotifStroke, {Transparency = 1}, 0.3)
            task.wait(0.3)
            NotifFrame:Destroy()
        end)
    end
    
    function Window:SaveConfig(configName)
        configName = configName or "DefaultConfig"
        
        local configData = {}
        for flag, obj in pairs(ConfigSystem.Flags) do
            configData[flag] = obj.Value
        end
        
        local json = HttpService:JSONEncode(configData)
        
        if writefile then
            writefile("NebulaHub_" .. configName .. ".json", json)
            return true
        else
            return false
        end
    end
    
    function Window:LoadConfig(configName)
        configName = configName or "DefaultConfig"
        
        if readfile and isfile and isfile("NebulaHub_" .. configName .. ".json") then
            local success, configData = pcall(function()
                return HttpService:JSONDecode(readfile("NebulaHub_" .. configName .. ".json"))
            end)
            
            if success then
                for flag, value in pairs(configData) do
                    if ConfigSystem.Flags[flag] then
                        ConfigSystem.Flags[flag]:Set(value)
                    end
                end
                return true
            end
        end
        return false
    end
    
    function Window:GetConfigList()
        local configs = {}
        
        if listfiles then
            for _, file in ipairs(listfiles()) do
                local configName = file:match("NebulaHub_(.+)%.json")
                if configName then
                    table.insert(configs, configName)
                end
            end
        end
        
        if #configs == 0 then
            table.insert(configs, "None")
        end
        
        return configs
    end
    
    function Window:CreateTab(tabName)
        local isSettings = (tabName == "Settings")
        
        if isSettings and Window.HasSettingsTab then
            return Window.SettingsTabObj
        end
        
        if isSettings then
            Window.HasSettingsTab = true
        end
        
        local Tab = {
            Name = tabName,
            IsSettings = isSettings
        }
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. tabName
        TabButton.Size = UDim2.new(1, 0, 0, 28)
        TabButton.BackgroundColor3 = Theme.Element
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.LayoutOrder = isSettings and 9999 or #Window.Tabs
        TabButton.Parent = TabList
        
        table.insert(GUIElements, {Type = "Element", Instance = TabButton})
        
        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Size = UDim2.new(0, 2, 1, -6)
        TabIndicator.Position = UDim2.new(0, 0, 0, 3)
        TabIndicator.BackgroundColor3 = Theme.Primary
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Visible = false
        TabIndicator.Parent = TabButton
        
        table.insert(GUIElements, {Type = "Primary", Instance = TabIndicator})
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -10, 1, 0)
        TabLabel.Position = UDim2.new(0, 10, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = isSettings and "⚙️" or tabName
        TabLabel.TextColor3 = Theme.TextDark
        TabLabel.TextSize = isSettings and 16 or 12
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        local TabContent = Instance.new("Frame")
        TabContent.Name = "TabContent_" .. tabName
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
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
        
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
                Tween(t.Label, {TextColor3 = Theme.TextDark}, 0.2)
                t.Indicator.Visible = false
            end
            
            TabContent.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0.7}, 0.2)
            Tween(TabLabel, {TextColor3 = Theme.Text}, 0.2)
            TabIndicator.Visible = true
            Window.CurrentTab = Tab
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.8}, 0.15)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Label = TabLabel
        Tab.Indicator = TabIndicator
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabButton.BackgroundTransparency = 0.7
            TabLabel.TextColor3 = Theme.Text
            TabIndicator.Visible = true
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end
        
        if isSettings then
            Window.SettingsTabObj = Tab
            
            task.defer(function()
                local SettingsLeft = Tab:AddSection("UI Settings", "left")
                
                SettingsLeft:AddKeybind({
                    Name = "Toggle UI",
                    Default = currentToggleKey,
                    Flag = "ToggleKey",
                    Callback = function(key)
                        currentToggleKey = key
                        Window.ToggleKey = key
                        MinimizeMessage.Text = "Press " .. key.Name .. " to open"
                    end
                })
                
                local themeNames = {}
                for themeName, _ in pairs(Themes) do
                    table.insert(themeNames, themeName)
                end
                table.sort(themeNames)
                
                SettingsLeft:AddDropdown({
                    Name = "Theme",
                    Options = themeNames,
                    Default = "Default",
                    Flag = "Theme",
                    Callback = function(themeName)
                        ApplyTheme(themeName, Window.GUIElements)
                        Window:Notification({
                            Title = "Theme Changed",
                            Text = "Applied " .. themeName .. " theme!",
                            Duration = 2
                        })
                    end
                })
                
                local SettingsRight = Tab:AddSection("Config System", "right")

                -- Dans la fonction qui crée le Settings tab, ajoutez cette section :

local SettingsBackground = Tab:AddSection("Background Image", "right")

local backgroundImageId = ""

SettingsBackground:AddInput({
    Name = "Image ID/Link",
    PlaceholderText = "rbxassetid://123456789",
    Flag = "BackgroundImageID",
    Callback = function(text)
        backgroundImageId = text
    end
})

SettingsBackground:AddButton({
    Name = "Load Background",
    Callback = function()
        if backgroundImageId == "" then
            Window:Notification({
                Title = "Error",
                Text = "Please enter an image ID!",
                Duration = 3
            })
            return
        end
        
        -- Nettoyer l'ID si c'est un lien complet
        local imageId = backgroundImageId
        if string.find(imageId, "rbxassetid://") then
            -- Déjà au bon format
        elseif string.find(imageId, "roblox.com") then
            -- Extraire l'ID d'un lien
            imageId = string.match(imageId, "(%d+)")
            if imageId then
                imageId = "rbxassetid://" .. imageId
            end
        elseif tonumber(imageId) then
            -- Juste un nombre
            imageId = "rbxassetid://" .. imageId
        end
        
        -- Vérifier si l'image de fond existe déjà
        local existingBg = MainFrame:FindFirstChild("CustomBackground")
        if existingBg then
            existingBg:Destroy()
        end
        
        -- Créer l'image de fond
        local BackgroundImage = Instance.new("ImageLabel")
        BackgroundImage.Name = "CustomBackground"
        BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
        BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
        BackgroundImage.BackgroundTransparency = 1
        BackgroundImage.Image = imageId
        BackgroundImage.ImageTransparency = 0.7 -- Ajustez la transparence (0 = opaque, 1 = invisible)
        BackgroundImage.ScaleType = Enum.ScaleType.Crop
        BackgroundImage.ZIndex = 0
        BackgroundImage.Parent = MainFrame
        
        -- S'assurer que le corner est appliqué
        local BgCorner = Instance.new("UICorner")
        BgCorner.CornerRadius = UDim.new(0, 4)
        BgCorner.Parent = BackgroundImage
        
        Window:Notification({
            Title = "Success",
            Text = "Background image loaded!",
            Duration = 3
        })
    end
})

SettingsBackground:AddSlider({
    Name = "Image Transparency",
    Min = 0,
    Max = 100,
    Default = 70,
    Flag = "BackgroundTransparency",
    Callback = function(value)
        local existingBg = MainFrame:FindFirstChild("CustomBackground")
        if existingBg then
            existingBg.ImageTransparency = value / 100
        end
    end
})

SettingsBackground:AddButton({
    Name = "Remove Background",
    Callback = function()
        local existingBg = MainFrame:FindFirstChild("CustomBackground")
        if existingBg then
            Tween(existingBg, {ImageTransparency = 1}, 0.3)
            task.wait(0.3)
            existingBg:Destroy()
            Window:Notification({
                Title = "Removed",
                Text = "Background image removed!",
                Duration = 2
            })
        else
            Window:Notification({
                Title = "Error",
                Text = "No background to remove!",
                Duration = 2
            })
        end
    end
})
                
                local configNameInput = ""
                local selectedConfig = "None"
                
                SettingsRight:AddInput({
                    Name = "Config Name",
                    PlaceholderText = "MyConfig",
                    Callback = function(text)
                        configNameInput = text
                    end
                })
                
                SettingsRight:AddDropdown({
                    Name = "Select Config",
                    Options = Window:GetConfigList(),
                    Default = "None",
                    Callback = function(value)
                        selectedConfig = value
                    end
                })
                
                SettingsRight:AddButton({
                    Name = "Save Config",
                    Callback = function()
                        if configNameInput ~= "" then
                            local success = Window:SaveConfig(configNameInput)
                            if success then
                                Window:Notification({
                                    Title = "Saved",
                                    Text = "Config '" .. configNameInput .. "' saved!",
                                    Duration = 3
                                })
                            else
                                Window:Notification({
                                    Title = "Error",
                                    Text = "Failed to save!",
                                    Duration = 3
                                })
                            end
                        else
                            Window:Notification({
                                Title = "Error",
                                Text = "Enter a config name!",
                                Duration = 3
                            })
                        end
                    end
                })
                
                SettingsRight:AddButton({
                    Name = "Load Config",
                    Callback = function()
                        if selectedConfig ~= "None" then
                            local success = Window:LoadConfig(selectedConfig)
                            if success then
                                Window:Notification({
                                    Title = "Loaded",
                                    Text = "Config '" .. selectedConfig .. "' loaded!",
                                    Duration = 3
                                })
                            else
                                Window:Notification({
                                    Title = "Error",
                                    Text = "Failed to load!",
                                    Duration = 3
                                })
                            end
                        else
                            Window:Notification({
                                Title = "Error",
                                Text = "Select a config!",
                                Duration = 3
                            })
                        end
                    end
                })
                
                SettingsRight:AddButton({
                    Name = "Delete Config",
                    Callback = function()
                        if selectedConfig ~= "None" then
                            if delfile then
                                delfile("NebulaHub_" .. selectedConfig .. ".json")
                                Window:Notification({
                                    Title = "Deleted",
                                    Text = "Config deleted!",
                                    Duration = 3
                                })
                                selectedConfig = "None"
                            else
                                Window:Notification({
                                    Title = "Error",
                                    Text = "delfile not supported!",
                                    Duration = 3
                                })
                            end
                        else
                            Window:Notification({
                                Title = "Error",
                                Text = "Select a config!",
                                Duration = 3
                            })
                        end
                    end
                })
            end)
        end
        
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
            
            local Section = {Frame = SectionFrame, Column = column}
            
            function Section:AddLabel(config)
                config = config or {}
                local LabelText = config.Text or "Label"
                
                local LabelFrame = Instance.new("Frame")
                LabelFrame.Size = UDim2.new(1, 0, 0, 20)
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Parent = SectionFrame
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -8, 1, 0)
                Label.Position = UDim2.new(0, 8, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = LabelText
                Label.TextColor3 = Theme.TextDark
                Label.TextSize = 11
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextWrapped = true
                Label.Parent = LabelFrame
                
                return {SetText = function(self, text) Label.Text = text end}
            end
            
            function Section:AddParagraph(config)
                config = config or {}
                local Title = config.Title or "Paragraph"
                local Content = config.Content or "Content"
                
                local ParagraphFrame = Instance.new("Frame")
                ParagraphFrame.Size = UDim2.new(1, 0, 0, 0)
                ParagraphFrame.BackgroundColor3 = Theme.Element
                ParagraphFrame.BackgroundTransparency = 0.5
                ParagraphFrame.BorderSizePixel = 0
                ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y
                ParagraphFrame.Parent = SectionFrame
                
                table.insert(GUIElements, {Type = "Element", Instance = ParagraphFrame})
                
                local PCorner = Instance.new("UICorner")
                PCorner.CornerRadius = UDim.new(0, 3)
                PCorner.Parent = ParagraphFrame
                
                local PLayout = Instance.new("UIListLayout")
                PLayout.SortOrder = Enum.SortOrder.LayoutOrder
                PLayout.Padding = UDim.new(0, 3)
                PLayout.Parent = ParagraphFrame
                
                local PPadding = Instance.new("UIPadding")
                PPadding.PaddingTop = UDim.new(0, 8)
                PPadding.PaddingBottom = UDim.new(0, 8)
                PPadding.PaddingLeft = UDim.new(0, 8)
                PPadding.PaddingRight = UDim.new(0, 8)
                PPadding.Parent = ParagraphFrame
                
                local PTitle = Instance.new("TextLabel")
                PTitle.Size = UDim2.new(1, 0, 0, 18)
                PTitle.BackgroundTransparency = 1
                PTitle.Text = Title
                PTitle.TextColor3 = Theme.Text
                PTitle.TextSize = 12
                PTitle.Font = Enum.Font.GothamBold
                PTitle.TextXAlignment = Enum.TextXAlignment.Left
                PTitle.Parent = ParagraphFrame
                
                local PContent = Instance.new("TextLabel")
                PContent.Size = UDim2.new(1, 0, 0, 0)
                PContent.BackgroundTransparency = 1
                PContent.Text = Content
                PContent.TextColor3 = Theme.TextDark
                PContent.TextSize = 10
                PContent.Font = Enum.Font.Gotham
                PContent.TextXAlignment = Enum.TextXAlignment.Left
                PContent.TextWrapped = true
                PContent.TextYAlignment = Enum.TextYAlignment.Top
                PContent.AutomaticSize = Enum.AutomaticSize.Y
                PContent.Parent = ParagraphFrame
                
                return {SetText = function(self, title, content) PTitle.Text = title PContent.Text = content end}
            end
            
            function Section:AddToggle(config)
                config = config or {}
                local Name = config.Name or "Toggle"
                local Default = config.Default or false
                local Flag = config.Flag
                local Callback = config.Callback or function() end
                
                local TFrame = Instance.new("Frame")
                TFrame.Size = UDim2.new(1, 0, 0, 30)
                TFrame.BackgroundColor3 = Theme.Element
                TFrame.BackgroundTransparency = 0.5
                TFrame.BorderSizePixel = 0
                TFrame.Parent = SectionFrame
                
                table.insert(GUIElements, {Type = "Element", Instance = TFrame})
                
                local TCorner = Instance.new("UICorner")
                TCorner.CornerRadius = UDim.new(0, 3)
                TCorner.Parent = TFrame
                
                local TLabel = Instance.new("TextLabel")
                TLabel.Size = UDim2.new(1, -35, 1, 0)
                TLabel.Position = UDim2.new(0, 8, 0, 0)
                TLabel.BackgroundTransparency = 1
                TLabel.Text = Name
                TLabel.TextColor3 = Theme.Text
                TLabel.TextSize = 11
                TLabel.Font = Enum.Font.Gotham
                TLabel.TextXAlignment = Enum.TextXAlignment.Left
                TLabel.Parent = TFrame
                
                local TButton = Instance.new("Frame")
                TButton.Size = UDim2.new(0, 14, 0, 14)
                TButton.Position = UDim2.new(1, -22, 0.5, -7)
                TButton.BackgroundColor3 = Theme.ToggleOff
                TButton.BorderSizePixel = 0
                TButton.Parent = TFrame
                
                local TCorner2 = Instance.new("UICorner")
                TCorner2.CornerRadius = UDim.new(0, 3)
                TCorner2.Parent = TButton
                
                local toggled = Default
                
                local ToggleObj = {
                    Value = toggled,
                    Set = function(self, value)
                        toggled = value
                        self.Value = value
                        Tween(TButton, {BackgroundColor3 = toggled and Theme.Toggle or Theme.ToggleOff}, 0.2)
                        Callback(toggled)
                    end
                }
                
                if Flag then ConfigSystem.Flags[Flag] = ToggleObj end
                
                local TClick = Instance.new("TextButton")
                TClick.Size = UDim2.new(1, 0, 1, 0)
                TClick.BackgroundTransparency = 1
                TClick.Text = ""
                TClick.Parent = TFrame
                
                TClick.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    if toggled then
                        Tween(TButton, {BackgroundColor3 = Theme.Toggle, Size = UDim2.new(0, 16, 0, 16)}, 0.2)
                        task.wait(0.1)
                        Tween(TButton, {Size = UDim2.new(0, 14, 0, 14)}, 0.1)
                    else
                        Tween(TButton, {BackgroundColor3 = Theme.ToggleOff}, 0.2)
                    end
                    ToggleObj.Value = toggled
                    Callback(toggled)
                end)
                
                if Default then Tween(TButton, {BackgroundColor3 = Theme.Toggle}, 0) end
                
                return ToggleObj
            end
            
            function Section:AddButton(config)
                config = config or {}
                local Name = config.Name or "Button"
                local Callback = config.Callback or function() end
                
                local BFrame = Instance.new("TextButton")
                BFrame.Size = UDim2.new(1, 0, 0, 35)
                BFrame.BackgroundColor3 = Theme.Primary
                BFrame.BackgroundTransparency = 0.3
                BFrame.BorderSizePixel = 0
                BFrame.Text = Name
                BFrame.TextColor3 = Theme.Text
                BFrame.TextSize = 12
                BFrame.Font = Enum.Font.GothamBold
                BFrame.Parent = SectionFrame
                
                table.insert(GUIElements, {Type = "Primary", Instance = BFrame})
                
                local BCorner = Instance.new("UICorner")
                BCorner.CornerRadius = UDim.new(0, 4)
                BCorner.Parent = BFrame
                
                BFrame.MouseButton1Click:Connect(function()
                    Tween(BFrame, {Size = UDim2.new(1, 0, 0, 32)}, 0.1)
                    task.wait(0.1)
                    Tween(BFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.1)
                    Callback()
                end)
                
                BFrame.MouseEnter:Connect(function() Tween(BFrame, {BackgroundTransparency = 0.1}, 0.2) end)
                BFrame.MouseLeave:Connect(function() Tween(BFrame, {BackgroundTransparency = 0.3}, 0.2) end)
                
                return BFrame
            end
            
            function Section:AddSlider(config)
                config = config or {}
                local Name = config.Name or "Slider"
                local Min = config.Min or 0
                local Max = config.Max or 100
                local Default = config.Default or 50
                local Flag = config.Flag
                local Callback = config.Callback or function() end
                
                local SFrame = Instance.new("Frame")
                SFrame.Size = UDim2.new(1, 0, 0, 45)
                SFrame.BackgroundColor3 = Theme.Element
                SFrame.BackgroundTransparency = 0.5
                SFrame.BorderSizePixel = 0
                SFrame.Parent = SectionFrame
                
                table.insert(GUIElements, {Type = "Element", Instance = SFrame})
                
                local SCorner = Instance.new("UICorner")
                SCorner.CornerRadius = UDim.new(0, 3)
                SCorner.Parent = SFrame
                
                local SLabel = Instance.new("TextLabel")
                SLabel.Size = UDim2.new(1, -60, 0, 18)
                SLabel.Position = UDim2.new(0, 8, 0, 5)
                SLabel.BackgroundTransparency = 1
                SLabel.Text = Name
                SLabel.TextColor3 = Theme.Text
                SLabel.TextSize = 11
                SLabel.Font = Enum.Font.Gotham
                SLabel.TextXAlignment = Enum.TextXAlignment.Left
                SLabel.Parent = SFrame
                
                local SValue = Instance.new("TextLabel")
                SValue.Size = UDim2.new(0, 50, 0, 18)
                SValue.Position = UDim2.new(1, -55, 0, 5)
                SValue.BackgroundTransparency = 1
                SValue.Text = tostring(Default)
                SValue.TextColor3 = Theme.Text
                SValue.TextSize = 11
                SValue.Font = Enum.Font.Gotham
                SValue.TextXAlignment = Enum.TextXAlignment.Right
                SValue.Parent = SFrame
                
                local SBar = Instance.new("Frame")
                SBar.Size = UDim2.new(1, -16, 0, 5)
                SBar.Position = UDim2.new(0, 8, 1, -12)
                SBar.BackgroundColor3 = Theme.SliderBg
                SBar.BorderSizePixel = 0
                SBar.Parent = SFrame
                
                local SBarCorner = Instance.new("UICorner")
                SBarCorner.CornerRadius = UDim.new(1, 0)
                SBarCorner.Parent = SBar
                
                local SFill = Instance.new("Frame")
                SFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
                SFill.BackgroundColor3 = Theme.Slider
                SFill.BorderSizePixel = 0
                SFill.Parent = SBar
                
                table.insert(GUIElements, {Type = "Primary", Instance = SFill})
                
                local SFillCorner = Instance.new("UICorner")
                SFillCorner.CornerRadius = UDim.new(1, 0)
                SFillCorner.Parent = SFill
                
                local dragging = false
                local value = Default
                
                local SliderObj = {
                    Value = value,
                    Set = function(self, val)
                        value = math.clamp(val, Min, Max)
                        self.Value = value
                        SValue.Text = tostring(value)
                        local pos = (value - Min) / (Max - Min)
                        SFill.Size = UDim2.new(pos, 0, 1, 0)
                        Callback(value)
                    end
                }
                
                if Flag then ConfigSystem.Flags[Flag] = SliderObj end
                
                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SBar.AbsolutePosition.X) / SBar.AbsoluteSize.X, 0, 1)
                    value = math.floor(Min + (Max - Min) * pos)
                    SValue.Text = tostring(value)
                    Tween(SFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                    SliderObj.Value = value
                    Callback(value)
                end
                
                SBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)
                
                SBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(input) end
                end)
                
                return SliderObj
            end
            
            function Section:AddDropdown(config)
                config = config or {}
                local Name = config.Name or "Dropdown"
                local Options = config.Options or {"Option 1", "Option 2"}
                local Default = config.Default or Options[1]
                local Flag = config.Flag
                local Callback = config.Callback or function() end
                
                local DFrame = Instance.new("Frame")
                DFrame.Size = UDim2.new(1, 0, 0, 30)
                DFrame.BackgroundColor3 = Theme.Element
                DFrame.BackgroundTransparency = 0.5
                DFrame.BorderSizePixel = 0
                DFrame.ClipsDescendants = true
                DFrame.Parent = SectionFrame
                
                table.insert(GUIElements, {Type = "Element", Instance = DFrame})
                
                local DCorner = Instance.new("UICorner")
                DCorner.CornerRadius = UDim.new(0, 3)
                DCorner.Parent = DFrame
                
                local DLabel = Instance.new("TextLabel")
                DLabel.Size = UDim2.new(1, -80, 0, 30)
                DLabel.Position = UDim2.new(0, 8, 0, 0)
                DLabel.BackgroundTransparency = 1
                DLabel.Text = Name
                DLabel.TextColor3 = Theme.Text
                DLabel.TextSize = 11
                DLabel.Font = Enum.Font.Gotham
                DLabel.TextXAlignment = Enum.TextXAlignment.Left
                DLabel.Parent = DFrame
                
                local DButton = Instance.new("TextButton")
                DButton.Size = UDim2.new(0, 100, 0, 22)
                DButton.Position = UDim2.new(1, -105, 0, 4)
                DButton.BackgroundColor3 = Theme.SliderBg
                DButton.BorderSizePixel = 0
                DButton.Text = Default
                DButton.TextColor3 = Theme.Text
                DButton.TextSize = 10
                DButton.Font = Enum.Font.Gotham
                DButton.Parent = DFrame
                
                local DButtonCorner = Instance.new("UICorner")
                DButtonCorner.CornerRadius = UDim.new(0, 3)
                DButtonCorner.Parent = DButton
                
                local DArrow = Instance.new("TextLabel")
                DArrow.Size = UDim2.new(0, 15, 1, 0)
                DArrow.Position = UDim2.new(1, -15, 0, 0)
                DArrow.BackgroundTransparency = 1
                DArrow.Text = "▼"
                DArrow.TextColor3 = Theme.TextDark
                DArrow.TextSize = 8
                DArrow.Font = Enum.Font.Gotham
                DArrow.Parent = DButton
                
                local DList = Instance.new("Frame")
                DList.Size = UDim2.new(1, -16, 0, 0)
                DList.Position = UDim2.new(0, 8, 0, 35)
                DList.BackgroundTransparency = 1
                DList.BorderSizePixel = 0
                DList.Parent = DFrame
                
                local DListLayout = Instance.new("UIListLayout")
                DListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DListLayout.Padding = UDim.new(0, 2)
                DListLayout.Parent = DList
                
                local opened = false
                local selected = Default
                
                local DropdownObj = {
                    Value = selected,
                    Set = function(self, value)
                        selected = value
                        self.Value = value
                        DButton.Text = value
                        Callback(value)
                    end
                }
                
                if Flag then ConfigSystem.Flags[Flag] = DropdownObj end
                
                for i, option in ipairs(Options) do
                    local OButton = Instance.new("TextButton")
                    OButton.Size = UDim2.new(1, 0, 0, 24)
                    OButton.BackgroundColor3 = Theme.SliderBg
                    OButton.BorderSizePixel = 0
                    OButton.Text = option
                    OButton.TextColor3 = Theme.Text
                    OButton.TextSize = 10
                    OButton.Font = Enum.Font.Gotham
                    OButton.Parent = DList
                    
                    local OCorner = Instance.new("UICorner")
                    OCorner.CornerRadius = UDim.new(0, 3)
                    OCorner.Parent = OButton
                    
                    OButton.MouseButton1Click:Connect(function()
                        selected = option
                        DButton.Text = option
                        opened = false
                        Tween(DFrame, {Size = UDim2.new(1, 0, 0, 30)}, 0.2, Enum.EasingStyle.Quart)
                        Tween(DArrow, {Rotation = 0}, 0.2)
                        DropdownObj.Value = selected
                        Callback(option)
                    end)
                    
                    OButton.MouseEnter:Connect(function() Tween(OButton, {BackgroundColor3 = Theme.Primary}, 0.15) end)
                    OButton.MouseLeave:Connect(function() Tween(OButton, {BackgroundColor3 = Theme.SliderBg}, 0.15) end)
                end
                
                DButton.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        local height = 35 + (#Options * 26)
                        Tween(DFrame, {Size = UDim2.new(1, 0, 0, height)}, 0.2, Enum.EasingStyle.Quart)
                        Tween(DArrow, {Rotation = 180}, 0.2)
                    else
                        Tween(DFrame, {Size = UDim2.new(1, 0, 0, 30)}, 0.2, Enum.EasingStyle.Quart)
                        Tween(DArrow, {Rotation = 0}, 0.2)
                    end
                end)
                
                return DropdownObj
            end
            
            function Section:AddInput(config)
                config = config or {}
                local Name = config.Name or "Input"
                local Placeholder = config.PlaceholderText or "Enter text..."
                local Default = config.Default or ""
                local Flag = config.Flag
                local Callback = config.Callback or function() end
                
                local IFrame = Instance.new("Frame")
                IFrame.Size = UDim2.new(1, 0, 0, 35)
                IFrame.BackgroundColor3 = Theme.Element
                IFrame.BackgroundTransparency = 0.5
                IFrame.BorderSizePixel = 0
                IFrame.Parent = SectionFrame
                
                table.insert(GUIElements, {Type = "Element", Instance = IFrame})
                
                local ICorner = Instance.new("UICorner")
                ICorner.CornerRadius = UDim.new(0, 3)
                ICorner.Parent = IFrame
                
                local ILabel = Instance.new("TextLabel")
                ILabel.Size = UDim2.new(0, 100, 1, 0)
                ILabel.Position = UDim2.new(0, 8, 0, 0)
                ILabel.BackgroundTransparency = 1
                ILabel.Text = Name
                ILabel.TextColor3 = Theme.Text
                ILabel.TextSize = 11
                ILabel.Font = Enum.Font.Gotham
                ILabel.TextXAlignment = Enum.TextXAlignment.Left
                ILabel.Parent = IFrame
                
                local IInput = Instance.new("TextBox")
                IInput.Size = UDim2.new(1, -115, 0, 25)
                IInput.Position = UDim2.new(0, 105, 0, 5)
                IInput.BackgroundColor3 = Theme.SliderBg
                IInput.BorderSizePixel = 0
                IInput.PlaceholderText = Placeholder
                IInput.PlaceholderColor3 = Theme.TextDark
                IInput.Text = Default
                IInput.TextColor3 = Theme.Text
                IInput.TextSize = 10
                IInput.Font = Enum.Font.Gotham
                IInput.TextXAlignment = Enum.TextXAlignment.Left
                IInput.ClearTextOnFocus = false
                IInput.Parent = IFrame
                
                local IInputCorner = Instance.new("UICorner")
                IInputCorner.CornerRadius = UDim.new(0, 3)
                IInputCorner.Parent = IInput
                
                local IPadding = Instance.new("UIPadding")
                IPadding.PaddingLeft = UDim.new(0, 8)
                IPadding.PaddingRight = UDim.new(0, 8)
                IPadding.Parent = IInput
                
                local InputObj = {
                    Value = Default,
                    Set = function(self, text)
                        IInput.Text = text
                        self.Value = text
                        Callback(text, false)
                    end
                }
                
                if Flag then ConfigSystem.Flags[Flag] = InputObj end
                
                IInput.FocusLost:Connect(function(enterPressed)
                    InputObj.Value = IInput.Text
                    Callback(IInput.Text, enterPressed)
                end)
                
                IInput.Focused:Connect(function() Tween(IInput, {BackgroundColor3 = Theme.Primary}, 0.2) end)
                IInput.FocusLost:Connect(function() Tween(IInput, {BackgroundColor3 = Theme.SliderBg}, 0.2) end)
                
                return InputObj
            end
            
            function Section:AddKeybind(config)
                config = config or {}
                local Name = config.Name or "Keybind"
                local Default = config.Default or Enum.KeyCode.E
                local Flag = config.Flag
                local Callback = config.Callback or function() end
                
                local KFrame = Instance.new("Frame")
                KFrame.Size = UDim2.new(1, 0, 0, 30)
                KFrame.BackgroundColor3 = Theme.Element
                KFrame.BackgroundTransparency = 0.5
                KFrame.BorderSizePixel = 0
                KFrame.Parent = SectionFrame
                
                table.insert(GUIElements, {Type = "Element", Instance = KFrame})
                
                local KCorner = Instance.new("UICorner")
                KCorner.CornerRadius = UDim.new(0, 3)
                KCorner.Parent = KFrame
                
                local KLabel = Instance.new("TextLabel")
                KLabel.Size = UDim2.new(1, -80, 1, 0)
                KLabel.Position = UDim2.new(0, 8, 0, 0)
                KLabel.BackgroundTransparency = 1
                KLabel.Text = Name
                KLabel.TextColor3 = Theme.Text
                KLabel.TextSize = 11
                KLabel.Font = Enum.Font.Gotham
                KLabel.TextXAlignment = Enum.TextXAlignment.Left
                KLabel.Parent = KFrame
                
                local KButton = Instance.new("TextButton")
                KButton.Size = UDim2.new(0, 65, 0, 22)
                KButton.Position = UDim2.new(1, -70, 0, 4)
                KButton.BackgroundColor3 = Theme.SliderBg
                KButton.BorderSizePixel = 0
                KButton.Text = Default.Name
                KButton.TextColor3 = Theme.Text
                KButton.TextSize = 10
                KButton.Font = Enum.Font.Gotham
                KButton.Parent = KFrame
                
                local KButtonCorner = Instance.new("UICorner")
                KButtonCorner.CornerRadius = UDim.new(0, 3)
                KButtonCorner.Parent = KButton
                
                local currentKey = Default
                local binding = false
                
                local KeybindObj = {
                    Value = currentKey,
                    Set = function(self, key)
                        currentKey = key
                        self.Value = key
                        KButton.Text = key.Name
                        Callback(key)
                    end
                }
                
                if Flag then ConfigSystem.Flags[Flag] = KeybindObj end
                
                KButton.MouseButton1Click:Connect(function()
                    binding = true
                    KButton.Text = "..."
                    KButton.TextColor3 = Theme.Primary
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        binding = false
                        currentKey = input.KeyCode
                        KButton.Text = currentKey.Name
                        KButton.TextColor3 = Theme.Text
                        KeybindObj.Value = currentKey
                        Callback(currentKey)
                    elseif not gameProcessed and input.KeyCode == currentKey and not binding then
                        Callback(currentKey)
                    end
                end)
                
                return KeybindObj
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

return NebulaUI
