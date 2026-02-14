-- By Astral

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local NebulaUI = {}
NebulaUI.Flags = {}

-- Configuration
local ConfigFolder = "NebulaConfigs"
local ConfigExtension = ".json"

-- Create folder if it doesn't exist
if not isfolder(ConfigFolder) then
    makefolder(ConfigFolder)
end

-- Theme Colors
local Theme = {
    Primary = Color3.fromRGB(130, 70, 200),
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(10, 10, 15),
    Element = Color3.fromRGB(22, 22, 27),
    TextColor = Color3.fromRGB(240, 240, 240),
    ElementStroke = Color3.fromRGB(50, 50, 50)
}

-- Settings
local Settings = {
    ToggleKey = "V",
    ConfigName = "",
    Configs = {}
}

-- Load existing configs
local function LoadConfigsList()
    Settings.Configs = {}
    if isfolder(ConfigFolder) then
        for _, file in ipairs(listfiles(ConfigFolder)) do
            if file:sub(-#ConfigExtension) == ConfigExtension then
                local configName = file:match("([^/\\]+)" .. ConfigExtension .. "$"):sub(1, -#ConfigExtension - 1)
                table.insert(Settings.Configs, configName)
            end
        end
    end
    return Settings.Configs
end

-- Save Configuration
local function SaveConfiguration(configName)
    if configName == "" then return end
    
    local data = {}
    for flag, element in pairs(NebulaUI.Flags) do
        if element.CurrentValue ~= nil then
            data[flag] = element.CurrentValue
        elseif element.CurrentKeybind ~= nil then
            data[flag] = element.CurrentKeybind
        elseif element.CurrentOption ~= nil then
            data[flag] = element.CurrentOption
        end
    end
    
    -- Add theme settings
    data["__THEME__"] = {
        Primary = {Theme.Primary.R * 255, Theme.Primary.G * 255, Theme.Primary.B * 255},
        TextColor = {Theme.TextColor.R * 255, Theme.TextColor.G * 255, Theme.TextColor.B * 255},
        ToggleKey = Settings.ToggleKey
    }
    
    writefile(ConfigFolder .. "/" .. configName .. ConfigExtension, HttpService:JSONEncode(data))
    
    -- Refresh configs list
    LoadConfigsList()
end

-- Load Configuration
local function LoadConfiguration(configName)
    local filePath = ConfigFolder .. "/" .. configName .. ConfigExtension
    if not isfile(filePath) then return false end
    
    local data = HttpService:JSONDecode(readfile(filePath))
    
    -- Load theme first
    if data["__THEME__"] then
        local themeData = data["__THEME__"]
        if themeData.Primary then
            Theme.Primary = Color3.fromRGB(themeData.Primary[1], themeData.Primary[2], themeData.Primary[3])
        end
        if themeData.TextColor then
            Theme.TextColor = Color3.fromRGB(themeData.TextColor[1], themeData.TextColor[2], themeData.TextColor[3])
        end
        if themeData.ToggleKey then
            Settings.ToggleKey = themeData.ToggleKey
        end
    end
    
    -- Load flags
    for flag, value in pairs(data) do
        if flag ~= "__THEME__" and NebulaUI.Flags[flag] then
            NebulaUI.Flags[flag]:Set(value)
        end
    end
    
    return true
end

-- Delete Configuration
local function DeleteConfiguration(configName)
    local filePath = ConfigFolder .. "/" .. configName .. ConfigExtension
    if isfile(filePath) then
        delfile(filePath)
        LoadConfigsList()
        return true
    end
    return false
end

function NebulaUI:CreateWindow(WindowSettings)
    local Window = {}
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NebulaUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -250, 0.5, -237)
    Main.Size = UDim2.new(0, 500, 0, 475)
    Main.Active = true
    Main.Draggable = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main
    
    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = Main
    Topbar.BackgroundColor3 = Theme.Sidebar
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 8)
    TopbarCorner.Parent = Topbar
    
    local TopbarTitle = Instance.new("TextLabel")
    TopbarTitle.Name = "Title"
    TopbarTitle.Parent = Topbar
    TopbarTitle.BackgroundTransparency = 1
    TopbarTitle.Position = UDim2.new(0, 15, 0, 0)
    TopbarTitle.Size = UDim2.new(1, -80, 1, 0)
    TopbarTitle.Font = Enum.Font.GothamBold
    TopbarTitle.Text = WindowSettings.Name or "NebulaUI"
    TopbarTitle.TextColor3 = Theme.TextColor
    TopbarTitle.TextSize = 16
    TopbarTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Parent = Topbar
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -30, 0.5, -10)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.TextSize = 12
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        Main.Visible = false
    end)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Parent = Topbar
    MinimizeButton.BackgroundColor3 = Theme.Primary
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -55, 0.5, -10)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
    MinimizeButton.TextSize = 14
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 4)
    MinimizeCorner.Parent = MinimizeButton
    
    local isMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 500, 0, 40)}):Play()
            MinimizeButton.Text = "+"
        else
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 500, 0, 475)}):Play()
            MinimizeButton.Text = "-"
        end
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Parent = Sidebar
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 5)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "Content"
    ContentContainer.Parent = Main
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 150, 0, 40)
    ContentContainer.Size = UDim2.new(1, -150, 1, -40)
    ContentContainer.ClipsDescendants = true
    
    -- Toggle UI Keybind
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode[Settings.ToggleKey] then
            Main.Visible = not Main.Visible
        end
    end)
    
    local tabs = {}
    local currentTab = nil
    
    function Window:CreateTab(TabName, Icon)
        local Tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabName
        TabButton.Parent = Sidebar
        TabButton.BackgroundColor3 = Theme.Element
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = TabName
        TabButton.TextColor3 = Theme.TextColor
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.TextTruncate = Enum.TextTruncate.AtEnd
        
        local TabButtonPadding = Instance.new("UIPadding")
        TabButtonPadding.PaddingLeft = UDim.new(0, 10)
        TabButtonPadding.Parent = TabButton
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        local TabButtonStroke = Instance.new("UIStroke")
        TabButtonStroke.Color = Theme.ElementStroke
        TabButtonStroke.Thickness = 1
        TabButtonStroke.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = TabName .. "_Content"
        TabContent.Parent = ContentContainer
        TabContent.Active = true
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Theme.Primary
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local TabContentList = Instance.new("UIListLayout")
        TabContentList.Parent = TabContent
        TabContentList.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentList.Padding = UDim.new(0, 8)
        
        local TabContentPadding = Instance.new("UIPadding")
        TabContentPadding.PaddingLeft = UDim.new(0, 10)
        TabContentPadding.PaddingRight = UDim.new(0, 10)
        TabContentPadding.PaddingTop = UDim.new(0, 10)
        TabContentPadding.PaddingBottom = UDim.new(0, 10)
        TabContentPadding.Parent = TabContent
        
        TabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Left Column
        local LeftColumn = Instance.new("Frame")
        LeftColumn.Name = "LeftColumn"
        LeftColumn.Parent = TabContent
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Size = UDim2.new(0.48, 0, 0, 0)
        LeftColumn.LayoutOrder = 1
        
        local LeftList = Instance.new("UIListLayout")
        LeftList.Parent = LeftColumn
        LeftList.SortOrder = Enum.SortOrder.LayoutOrder
        LeftList.Padding = UDim.new(0, 8)
        
        LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            LeftColumn.Size = UDim2.new(0.48, 0, 0, LeftList.AbsoluteContentSize.Y)
        end)
        
        -- Right Column
        local RightColumn = Instance.new("Frame")
        RightColumn.Name = "RightColumn"
        RightColumn.Parent = TabContent
        RightColumn.BackgroundTransparency = 1
        RightColumn.Size = UDim2.new(0.48, 0, 0, 0)
        RightColumn.LayoutOrder = 2
        
        local RightList = Instance.new("UIListLayout")
        RightList.Parent = RightColumn
        RightList.SortOrder = Enum.SortOrder.LayoutOrder
        RightList.Padding = UDim.new(0, 8)
        
        RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            RightColumn.Size = UDim2.new(0.48, 0, 0, RightList.AbsoluteContentSize.Y)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Theme.Element
            end
            
            -- Show selected tab
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Theme.Primary
            currentTab = Tab
        end)
        
        -- Auto-select first tab
        if currentTab == nil then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Theme.Primary
            currentTab = Tab
        end
        
        Tab.Content = TabContent
        Tab.Button = TabButton
        Tab.LeftColumn = LeftColumn
        Tab.RightColumn = RightColumn
        
        table.insert(tabs, Tab)
        
        -- Section function
        function Tab:AddSection(SectionName, Column)
            local column = Column == "right" and RightColumn or LeftColumn
            
            local Section = Instance.new("TextLabel")
            Section.Name = "Section_" .. SectionName
            Section.Parent = column
            Section.BackgroundTransparency = 1
            Section.Size = UDim2.new(1, 0, 0, 20)
            Section.Font = Enum.Font.GothamBold
            Section.Text = SectionName
            Section.TextColor3 = Theme.Primary
            Section.TextSize = 14
            Section.TextXAlignment = Enum.TextXAlignment.Left
            
            return {
                AddToggle = function(self, ToggleSettings)
                    return Tab:AddToggle(ToggleSettings, Column)
                end,
                AddButton = function(self, ButtonSettings)
                    return Tab:AddButton(ButtonSettings, Column)
                end,
                AddSlider = function(self, SliderSettings)
                    return Tab:AddSlider(SliderSettings, Column)
                end,
                AddDropdown = function(self, DropdownSettings)
                    return Tab:AddDropdown(DropdownSettings, Column)
                end,
                AddTextBox = function(self, TextBoxSettings)
                    return Tab:AddTextBox(TextBoxSettings, Column)
                end,
                AddKeybind = function(self, KeybindSettings)
                    return Tab:AddKeybind(KeybindSettings, Column)
                end,
                AddColorPicker = function(self, ColorSettings)
                    return Tab:AddColorPicker(ColorSettings, Column)
                end
            }
        end
        
        -- Toggle
        function Tab:AddToggle(ToggleSettings, Column)
            local column = Column == "right" and RightColumn or LeftColumn
            local ToggleValue = ToggleSettings.Default or false
            
            local Toggle = Instance.new("Frame")
            Toggle.Name = ToggleSettings.Name
            Toggle.Parent = column
            Toggle.BackgroundColor3 = Theme.Element
            Toggle.BorderSizePixel = 0
            Toggle.Size = UDim2.new(1, 0, 0, 35)
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = Toggle
            
            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Color = Theme.ElementStroke
            ToggleStroke.Thickness = 1
            ToggleStroke.Parent = Toggle
            
            local ToggleTitle = Instance.new("TextLabel")
            ToggleTitle.Parent = Toggle
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
            ToggleTitle.Size = UDim2.new(1, -50, 1, 0)
            ToggleTitle.Font = Enum.Font.Gotham
            ToggleTitle.Text = ToggleSettings.Name
            ToggleTitle.TextColor3 = Theme.TextColor
            ToggleTitle.TextSize = 12
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Parent = Toggle
            ToggleButton.BackgroundColor3 = ToggleValue and Theme.Primary or Color3.fromRGB(50, 50, 50)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(1, -35, 0.5, -10)
            ToggleButton.Size = UDim2.new(0, 30, 0, 16)
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Parent = ToggleButton
            ToggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Position = ToggleValue and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            ToggleCircle.Size = UDim2.new(0, 12, 0, 12)
            
            local ToggleCircleCorner = Instance.new("UICorner")
            ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCircleCorner.Parent = ToggleCircle
            
            local ToggleClick = Instance.new("TextButton")
            ToggleClick.Parent = Toggle
            ToggleClick.BackgroundTransparency = 1
            ToggleClick.Size = UDim2.new(1, 0, 1, 0)
            ToggleClick.Text = ""
            
            ToggleClick.MouseButton1Click:Connect(function()
                ToggleValue = not ToggleValue
                
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = ToggleValue and Theme.Primary or Color3.fromRGB(50, 50, 50)
                }):Play()
                
                TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                    Position = ToggleValue and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                }):Play()
                
                ToggleSettings.Callback(ToggleValue)
            end)
            
            local ToggleObject = {}
            ToggleObject.CurrentValue = ToggleValue
            
            function ToggleObject:Set(Value)
                ToggleValue = Value
                ToggleObject.CurrentValue = Value
                
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = ToggleValue and Theme.Primary or Color3.fromRGB(50, 50, 50)
                }):Play()
                
                TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                    Position = ToggleValue and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                }):Play()
                
                ToggleSettings.Callback(ToggleValue)
            end
            
            if ToggleSettings.Flag then
                NebulaUI.Flags[ToggleSettings.Flag] = ToggleObject
            end
            
            return ToggleObject
        end
        
        -- Button
        function Tab:AddButton(ButtonSettings, Column)
            local column = Column == "right" and RightColumn or LeftColumn
            
            local Button = Instance.new("TextButton")
            Button.Name = ButtonSettings.Name
            Button.Parent = column
            Button.BackgroundColor3 = Theme.Primary
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.Font = Enum.Font.GothamBold
            Button.Text = ButtonSettings.Name
            Button.TextColor3 = Color3.new(1, 1, 1)
            Button.TextSize = 12
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                ButtonSettings.Callback()
            end)
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 90, 220)}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Primary}):Play()
            end)
        end
        
        -- Slider
        function Tab:AddSlider(SliderSettings, Column)
            local column = Column == "right" and RightColumn or LeftColumn
            local SliderValue = SliderSettings.Default or SliderSettings.Min
            
            local Slider = Instance.new("Frame")
            Slider.Name = SliderSettings.Name
            Slider.Parent = column
            Slider.BackgroundColor3 = Theme.Element
            Slider.BorderSizePixel = 0
            Slider.Size = UDim2.new(1, 0, 0, 50)
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = Slider
            
            local SliderStroke = Instance.new("UIStroke")
            SliderStroke.Color = Theme.ElementStroke
            SliderStroke.Thickness = 1
            SliderStroke.Parent = Slider
            
            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Parent = Slider
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 10, 0, 5)
            SliderTitle.Size = UDim2.new(1, -20, 0, 15)
            SliderTitle.Font = Enum.Font.Gotham
            SliderTitle.Text = SliderSettings.Name
            SliderTitle.TextColor3 = Theme.TextColor
            SliderTitle.TextSize = 12
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local SliderValue_Text = Instance.new("TextLabel")
            SliderValue_Text.Parent = Slider
            SliderValue_Text.BackgroundTransparency = 1
            SliderValue_Text.Position = UDim2.new(1, -50, 0, 5)
            SliderValue_Text.Size = UDim2.new(0, 40, 0, 15)
            SliderValue_Text.Font = Enum.Font.GothamBold
            SliderValue_Text.Text = tostring(SliderValue)
            SliderValue_Text.TextColor3 = Theme.Primary
            SliderValue_Text.TextSize = 12
            SliderValue_Text.TextXAlignment = Enum.TextXAlignment.Right
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Parent = Slider
            SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderBar.BorderSizePixel = 0
            SliderBar.Position = UDim2.new(0, 10, 0, 30)
            SliderBar.Size = UDim2.new(1, -20, 0, 6)
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderBar
            SliderFill.BackgroundColor3 = Theme.Primary
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((SliderValue - SliderSettings.Min) / (SliderSettings.Max - SliderSettings.Min), 0, 1, 0)
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local barPos = SliderBar.AbsolutePosition.X
                    local barSize = SliderBar.AbsoluteSize.X
                    local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
                    
                    SliderValue = math.floor(SliderSettings.Min + (percentage * (SliderSettings.Max - SliderSettings.Min)))
                    SliderValue_Text.Text = tostring(SliderValue)
                    
                    TweenService:Create(SliderFill, TweenInfo.new(0.1), {
                        Size = UDim2.new(percentage, 0, 1, 0)
                    }):Play()
                    
                    SliderSettings.Callback(SliderValue)
                end
            end)
            
            local SliderObject = {}
            SliderObject.CurrentValue = SliderValue
            
            function SliderObject:Set(Value)
                SliderValue = math.clamp(Value, SliderSettings.Min, SliderSettings.Max)
                SliderObject.CurrentValue = SliderValue
                SliderValue_Text.Text = tostring(SliderValue)
                
                local percentage = (SliderValue - SliderSettings.Min) / (SliderSettings.Max - SliderSettings.Min)
                TweenService:Create(SliderFill, TweenInfo.new(0.2), {
                    Size = UDim2.new(percentage, 0, 1, 0)
                }):Play()
                
                SliderSettings.Callback(SliderValue)
            end
            
            if SliderSettings.Flag then
                NebulaUI.Flags[SliderSettings.Flag] = SliderObject
            end
            
            return SliderObject
        end
        
        -- Dropdown
        function Tab:AddDropdown(DropdownSettings, Column)
            local column = Column == "right" and RightColumn or LeftColumn
            local DropdownValue = DropdownSettings.Default or DropdownSettings.Options[1]
            local isOpen = false
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = DropdownSettings.Name
            Dropdown.Parent = column
            Dropdown.BackgroundColor3 = Theme.Element
            Dropdown.BorderSizePixel = 0
            Dropdown.Size = UDim2.new(1, 0, 0, 35)
            Dropdown.ClipsDescendants = true
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = Dropdown
            
            local DropdownStroke = Instance.new("UIStroke")
            DropdownStroke.Color = Theme.ElementStroke
            DropdownStroke.Thickness = 1
            DropdownStroke.Parent = Dropdown
            
            local DropdownTitle = Instance.new("TextLabel")
            DropdownTitle.Parent = Dropdown
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.Position = UDim2.new(0, 10, 0, 0)
            DropdownTitle.Size = UDim2.new(1, -30, 0, 35)
            DropdownTitle.Font = Enum.Font.Gotham
            DropdownTitle.Text = DropdownValue
            DropdownTitle.TextColor3 = Theme.TextColor
            DropdownTitle.TextSize = 12
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Parent = Dropdown
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
            DropdownArrow.Size = UDim2.new(0, 20, 0, 35)
            DropdownArrow.Font = Enum.Font.GothamBold
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Theme.Primary
            DropdownArrow.TextSize = 10
            
            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Parent = Dropdown
            DropdownList.BackgroundTransparency = 1
            DropdownList.BorderSizePixel = 0
            DropdownList.Position = UDim2.new(0, 0, 0, 35)
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
            DropdownList.ScrollBarThickness = 2
            DropdownList.ScrollBarImageColor3 = Theme.Primary
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, #DropdownSettings.Options * 30)
            
            local DropdownListLayout = Instance.new("UIListLayout")
            DropdownListLayout.Parent = DropdownList
            DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            for _, option in ipairs(DropdownSettings.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Parent = DropdownList
                OptionButton.BackgroundColor3 = option == DropdownValue and Theme.Primary or Color3.fromRGB(30, 30, 35)
                OptionButton.BorderSizePixel = 0
                OptionButton.Size = UDim2.new(1, 0, 0, 28)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.new(1, 1, 1)
                OptionButton.TextSize = 11
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownValue = option
                    DropdownTitle.Text = option
                    
                    for _, btn in ipairs(DropdownList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = btn.Text == option and Theme.Primary or Color3.fromRGB(30, 30, 35)
                        end
                    end
                    
                    isOpen = false
                    TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                    TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    
                    DropdownSettings.Callback(option)
                end)
            end
            
            local DropdownClick = Instance.new("TextButton")
            DropdownClick.Parent = Dropdown
            DropdownClick.BackgroundTransparency = 1
            DropdownClick.Position = UDim2.new(0, 0, 0, 0)
            DropdownClick.Size = UDim2.new(1, 0, 0, 35)
            DropdownClick.Text = ""
            DropdownClick.ZIndex = 2
            
            DropdownClick.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    local listHeight = math.min(#DropdownSettings.Options * 28, 120)
                    TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35 + listHeight)}):Play()
                    TweenService:Create(DropdownList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, listHeight)}):Play()
                    TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                else
                    TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                    TweenService:Create(DropdownList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                end
            end)
            
            local DropdownObject = {}
            DropdownObject.CurrentOption = DropdownValue
            
            function DropdownObject:Set(Value)
                DropdownValue = Value
                DropdownObject.CurrentOption = Value
                DropdownTitle.Text = Value
                
                for _, btn in ipairs(DropdownList:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundColor3 = btn.Text == Value and Theme.Primary or Color3.fromRGB(30, 30, 35)
                    end
                end
                
                DropdownSettings.Callback(Value)
            end
            
            function DropdownObject:Refresh(NewOptions)
                for _, child in ipairs(DropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                DropdownSettings.Options = NewOptions
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, #NewOptions * 30)
                
                for _, option in ipairs(NewOptions) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Parent = DropdownList
                    OptionButton.BackgroundColor3 = option == DropdownValue and Theme.Primary or Color3.fromRGB(30, 30, 35)
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Size = UDim2.new(1, 0, 0, 28)
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Color3.new(1, 1, 1)
                    OptionButton.TextSize = 11
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        DropdownValue = option
                        DropdownTitle.Text = option
                        
                        for _, btn in ipairs(DropdownList:GetChildren()) do
                            if btn:IsA("TextButton") then
                                btn.BackgroundColor3 = btn.Text == option and Theme.Primary or Color3.fromRGB(30, 30, 35)
                            end
                        end
                        
                        isOpen = false
                        TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                        TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                        
                        DropdownSettings.Callback(option)
                    end)
                end
            end
            
            if DropdownSettings.Flag then
                NebulaUI.Flags[DropdownSettings.Flag] = DropdownObject
            end
            
            return DropdownObject
        end
        
        -- TextBox
        function Tab:AddTextBox(TextBoxSettings, Column)
            local column = Column == "right" and RightColumn or LeftColumn
            
            local TextBox = Instance.new("Frame")
            TextBox.Name = TextBoxSettings.Name
            TextBox.Parent = column
            TextBox.BackgroundColor3 = Theme.Element
            TextBox.BorderSizePixel = 0
            TextBox.Size = UDim2.new(1, 0, 0, 60)
            
            local TextBoxCorner = Instance.new("UICorner")
            TextBoxCorner.CornerRadius = UDim.new(0, 6)
            TextBoxCorner.Parent = TextBox
            
            local TextBoxStroke = Instance.new("UIStroke")
            TextBoxStroke.Color = Theme.ElementStroke
            TextBoxStroke.Thickness = 1
            TextBoxStroke.Parent = TextBox
            
            local TextBoxTitle = Instance.new("TextLabel")
            TextBoxTitle.Parent = TextBox
            TextBoxTitle.BackgroundTransparency = 1
            TextBoxTitle.Position = UDim2.new(0, 10, 0, 5)
            TextBoxTitle.Size = UDim2.new(1, -20, 0, 15)
            TextBoxTitle.Font = Enum.Font.Gotham
            TextBoxTitle.Text = TextBoxSettings.Name
            TextBoxTitle.TextColor3 = Theme.TextColor
            TextBoxTitle.TextSize = 12
            TextBoxTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local TextBoxInput = Instance.new("TextBox")
            TextBoxInput.Parent = TextBox
            TextBoxInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            TextBoxInput.BorderSizePixel = 0
            TextBoxInput.Position = UDim2.new(0, 10, 0, 25)
            TextBoxInput.Size = UDim2.new(1, -20, 0, 25)
            TextBoxInput.Font = Enum.Font.Gotham
            TextBoxInput.PlaceholderText = TextBoxSettings.Placeholder or ""
            TextBoxInput.Text = TextBoxSettings.Default or ""
            TextBoxInput.TextColor3 = Theme.TextColor
            TextBoxInput.TextSize = 11
            TextBoxInput.ClearTextOnFocus = false
            
            local TextBoxInputCorner = Instance.new("UICorner")
            TextBoxInputCorner.CornerRadius = UDim.new(0, 4)
            TextBoxInputCorner.Parent = TextBoxInput
            
            TextBoxInput.FocusLost:Connect(function(enterPressed)
                TextBoxSettings.Callback(TextBoxInput.Text, enterPressed)
            end)
            
            local TextBoxObject = {}
            
            function TextBoxObject:Set(Value)
                TextBoxInput.Text = Value
                TextBoxSettings.Callback(Value, false)
            end
            
            if TextBoxSettings.Flag then
                NebulaUI.Flags[TextBoxSettings.Flag] = TextBoxObject
            end
            
            return TextBoxObject
        end
        
        -- Keybind
        function Tab:AddKeybind(KeybindSettings, Column)
            local column = Column == "right" and RightColumn or LeftColumn
            local KeybindValue = KeybindSettings.Default or "NONE"
            local waitingForKey = false
            
            local Keybind = Instance.new("Frame")
            Keybind.Name = KeybindSettings.Name
            Keybind.Parent = column
            Keybind.BackgroundColor3 = Theme.Element
            Keybind.BorderSizePixel = 0
            Keybind.Size = UDim2.new(1, 0, 0, 35)
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 6)
            KeybindCorner.Parent = Keybind
            
            local KeybindStroke = Instance.new("UIStroke")
            KeybindStroke.Color = Theme.ElementStroke
            KeybindStroke.Thickness = 1
            KeybindStroke.Parent = Keybind
            
            local KeybindTitle = Instance.new("TextLabel")
            KeybindTitle.Parent = Keybind
            KeybindTitle.BackgroundTransparency = 1
            KeybindTitle.Position = UDim2.new(0, 10, 0, 0)
            KeybindTitle.Size = UDim2.new(1, -70, 1, 0)
            KeybindTitle.Font = Enum.Font.Gotham
            KeybindTitle.Text = KeybindSettings.Name
            KeybindTitle.TextColor3 = Theme.TextColor
            KeybindTitle.TextSize = 12
            KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Parent = Keybind
            KeybindButton.BackgroundColor3 = Theme.Primary
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Position = UDim2.new(1, -55, 0.5, -12)
            KeybindButton.Size = UDim2.new(0, 45, 0, 24)
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.Text = KeybindValue
            KeybindButton.TextColor3 = Color3.new(1, 1, 1)
            KeybindButton.TextSize = 10
            
            local KeybindButtonCorner = Instance.new("UICorner")
            KeybindButtonCorner.CornerRadius = UDim.new(0, 4)
            KeybindButtonCorner.Parent = KeybindButton
            
            KeybindButton.MouseButton1Click:Connect(function()
                waitingForKey = true
                KeybindButton.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if waitingForKey and not gameProcessed then
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        KeybindValue = input.KeyCode.Name
                        KeybindButton.Text = KeybindValue
                        waitingForKey = false
                        KeybindSettings.Callback(KeybindValue)
                    end
                elseif KeybindValue ~= "NONE" and input.KeyCode.Name == KeybindValue and not gameProcessed then
                    KeybindSettings.Callback(KeybindValue)
                end
            end)
            
            local KeybindObject = {}
            KeybindObject.CurrentKeybind = KeybindValue
            
            function KeybindObject:Set(Value)
                KeybindValue = Value
                KeybindObject.CurrentKeybind = Value
                KeybindButton.Text = Value
                KeybindSettings.Callback(Value)
            end
            
            if KeybindSettings.Flag then
                NebulaUI.Flags[KeybindSettings.Flag] = KeybindObject
            end
            
            return KeybindObject
        end
        
        -- ColorPicker
        function Tab:AddColorPicker(ColorSettings, Column)
            local column = Column == "right" and RightColumn or LeftColumn
            local ColorValue = ColorSettings.Default or Color3.fromRGB(255, 255, 255)
            
            local ColorPicker = Instance.new("Frame")
            ColorPicker.Name = ColorSettings.Name
            ColorPicker.Parent = column
            ColorPicker.BackgroundColor3 = Theme.Element
            ColorPicker.BorderSizePixel = 0
            ColorPicker.Size = UDim2.new(1, 0, 0, 35)
            
            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 6)
            ColorCorner.Parent = ColorPicker
            
            local ColorStroke = Instance.new("UIStroke")
            ColorStroke.Color = Theme.ElementStroke
            ColorStroke.Thickness = 1
            ColorStroke.Parent = ColorPicker
            
            local ColorTitle = Instance.new("TextLabel")
            ColorTitle.Parent = ColorPicker
            ColorTitle.BackgroundTransparency = 1
            ColorTitle.Position = UDim2.new(0, 10, 0, 0)
            ColorTitle.Size = UDim2.new(1, -50, 1, 0)
            ColorTitle.Font = Enum.Font.Gotham
            ColorTitle.Text = ColorSettings.Name
            ColorTitle.TextColor3 = Theme.TextColor
            ColorTitle.TextSize = 12
            ColorTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Parent = ColorPicker
            ColorDisplay.BackgroundColor3 = ColorValue
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Position = UDim2.new(1, -35, 0.5, -12)
            ColorDisplay.Size = UDim2.new(0, 25, 0, 24)
            
            local ColorDisplayCorner = Instance.new("UICorner")
            ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
            ColorDisplayCorner.Parent = ColorDisplay
            
            local ColorObject = {}
            ColorObject.CurrentValue = ColorValue
            
            function ColorObject:Set(Value)
                ColorValue = Value
                ColorObject.CurrentValue = Value
                ColorDisplay.BackgroundColor3 = Value
                ColorSettings.Callback(Value)
            end
            
            -- Simple click to cycle through some preset colors
            local ColorButton = Instance.new("TextButton")
            ColorButton.Parent = ColorPicker
            ColorButton.BackgroundTransparency = 1
            ColorButton.Size = UDim2.new(1, 0, 1, 0)
            ColorButton.Text = ""
            
            local presetColors = {
                Color3.fromRGB(255, 0, 0),
                Color3.fromRGB(0, 255, 0),
                Color3.fromRGB(0, 0, 255),
                Color3.fromRGB(255, 255, 0),
                Color3.fromRGB(255, 0, 255),
                Color3.fromRGB(0, 255, 255),
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(130, 70, 200)
            }
            
            local currentColorIndex = 1
            ColorButton.MouseButton1Click:Connect(function()
                currentColorIndex = (currentColorIndex % #presetColors) + 1
                ColorObject:Set(presetColors[currentColorIndex])
            end)
            
            if ColorSettings.Flag then
                NebulaUI.Flags[ColorSettings.Flag] = ColorObject
            end
            
            return ColorObject
        end
        
        return Tab
    end
    
    -- Create Settings Tab
    local SettingsTab = Window:CreateTab("⚙️ Settings")
    local SettingsLeft = SettingsTab:AddSection("UI Settings", "left")
    local SettingsRight = SettingsTab:AddSection("Configuration", "right")
    
    -- Toggle UI Keybind
    SettingsLeft:AddKeybind({
        Name = "Toggle UI Key",
        Default = Settings.ToggleKey,
        Callback = function(Key)
            Settings.ToggleKey = Key
        end
    })
    
    -- Primary Color
    SettingsLeft:AddColorPicker({
        Name = "Primary Color",
        Default = Theme.Primary,
        Callback = function(Color)
            Theme.Primary = Color
            -- Update all primary colored elements
            for _, desc in ipairs(ScreenGui:GetDescendants()) do
                if desc:IsA("Frame") or desc:IsA("TextButton") then
                    if desc.BackgroundColor3 == Theme.Primary then
                        desc.BackgroundColor3 = Color
                    end
                end
            end
        end
    })
    
    -- Text Color
    SettingsLeft:AddColorPicker({
        Name = "Text Color",
        Default = Theme.TextColor,
        Callback = function(Color)
            Theme.TextColor = Color
            -- Update all text elements
            for _, desc in ipairs(ScreenGui:GetDescendants()) do
                if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                    if desc.TextColor3 == Theme.TextColor then
                        desc.TextColor3 = Color
                    end
                end
            end
        end
    })
    
    -- Config Name TextBox
    local ConfigNameBox = SettingsRight:AddTextBox({
        Name = "Configuration Name",
        Placeholder = "Enter config name...",
        Default = "",
        Callback = function(Text)
            Settings.ConfigName = Text
        end
    })
    
    -- Save Config Button
    SettingsRight:AddButton({
        Name = "💾 Save Configuration",
        Callback = function()
            if Settings.ConfigName ~= "" then
                SaveConfiguration(Settings.ConfigName)
                
                -- Refresh dropdown
                if ConfigDropdown then
                    ConfigDropdown:Refresh(LoadConfigsList())
                end
                
                print("Configuration saved: " .. Settings.ConfigName)
            else
                print("Please enter a configuration name!")
            end
        end
    })
    
    -- Config Dropdown
    ConfigDropdown = SettingsRight:AddDropdown({
        Name = "Select Configuration",
        Options = LoadConfigsList(),
        Default = LoadConfigsList()[1] or "No Configs",
        Callback = function(Option)
            -- Don't do anything on selection
        end
    })
    
    -- Load Config Button
    SettingsRight:AddButton({
        Name = "📂 Load Configuration",
        Callback = function()
            if ConfigDropdown.CurrentOption and ConfigDropdown.CurrentOption ~= "No Configs" then
                local success = LoadConfiguration(ConfigDropdown.CurrentOption)
                if success then
                    print("Configuration loaded: " .. ConfigDropdown.CurrentOption)
                else
                    print("Failed to load configuration!")
                end
            else
                print("Please select a configuration!")
            end
        end
    })
    
    -- Delete Config Button
    SettingsRight:AddButton({
        Name = "🗑️ Delete Configuration",
        Callback = function()
            if ConfigDropdown.CurrentOption and ConfigDropdown.CurrentOption ~= "No Configs" then
                local success = DeleteConfiguration(ConfigDropdown.CurrentOption)
                if success then
                    print("Configuration deleted: " .. ConfigDropdown.CurrentOption)
                    
                    -- Refresh dropdown
                    ConfigDropdown:Refresh(LoadConfigsList())
                else
                    print("Failed to delete configuration!")
                end
            else
                print("Please select a configuration!")
            end
        end
    })
    
    return Window
end

return NebulaUI
