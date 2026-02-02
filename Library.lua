-- Eclipse Hub UI Library v2.0 - Ultra Stylish Edition
-- Inspired by Orion UI with modern effects
-- Created by Eclipse Team

local Library = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configuration des couleurs
local Colors = {
    MainBackground = Color3.fromRGB(15, 15, 20),
    SecondaryBackground = Color3.fromRGB(20, 20, 28),
    TertiaryBackground = Color3.fromRGB(25, 25, 35),
    
    Accent = Color3.fromRGB(120, 80, 255), -- Violet principal
    AccentHover = Color3.fromRGB(140, 100, 255),
    AccentDark = Color3.fromRGB(100, 60, 235),
    
    Success = Color3.fromRGB(80, 250, 120),
    Warning = Color3.fromRGB(255, 180, 60),
    Danger = Color3.fromRGB(255, 80, 100),
    
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 200),
    TextTertiary = Color3.fromRGB(130, 130, 150),
    
    Border = Color3.fromRGB(45, 45, 60),
    BorderLight = Color3.fromRGB(60, 60, 80),
}

-- Utilitaires
local function Tween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colors or ColorSequence.new{
        ColorSequenceKeypoint.new(0, Colors.Accent),
        ColorSequenceKeypoint.new(1, Colors.AccentDark)
    }
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

local function AddStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Colors.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.5
    stroke.Parent = parent
    return stroke
end

local function AddShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = parent
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(99, 99, 99, 99)
    return shadow
end

local function CreateRipple(parent, position)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Parent = parent
    ripple.BackgroundColor3 = Colors.TextPrimary
    ripple.BackgroundTransparency = 0.5
    ripple.BorderSizePixel = 0
    ripple.Position = UDim2.new(0, position.X, 0, position.Y)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = parent.ZIndex + 1
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    Tween(ripple, {
        Size = UDim2.new(0, 100, 0, 100),
        BackgroundTransparency = 1
    }, 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    game:GetService("Debris"):AddItem(ripple, 0.6)
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragInput, mousePos, framePos

    handle = handle or frame
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    end)
end

local function AddPulseEffect(instance)
    spawn(function()
        while instance and instance.Parent do
            Tween(instance, {BackgroundTransparency = 0.2}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(1)
            Tween(instance, {BackgroundTransparency = 0.4}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(1)
        end
    end)
end

-- Fonction principale pour créer la fenêtre
function Library:CreateWindow(config)
    config = config or {}
    
    -- Configuration complète
    local windowConfig = {
        Name = config.Name or "Eclipse Hub",
        Icon = config.Icon or 0,
        LoadingTitle = config.LoadingTitle or "Eclipse Hub",
        LoadingSubtitle = config.LoadingSubtitle or "by Eclipse Team",
        ShowText = config.ShowText or "Eclipse",
        Theme = config.Theme or "Default",
        ToggleUIKeybind = config.ToggleUIKeybind or Enum.KeyCode.RightControl,
        DisablePrompts = config.DisablePrompts or false,
        ConfigurationSaving = config.ConfigurationSaving or {
            Enabled = false,
            FolderName = nil,
            FileName = "EclipseConfig"
        },
        Discord = config.Discord or {
            Enabled = false,
            Invite = "",
            RememberJoins = true
        },
        KeySystem = config.KeySystem or false,
        KeySettings = config.KeySettings or {
            Title = "Key System",
            Subtitle = "Eclipse Hub",
            Note = "Enter your key",
            FileName = "EclipseKey",
            SaveKey = true,
            Key = {""}
        }
    }
    
    local WindowTable = {}
    
    -- Gestion du thème
    local Themes = {
        Default = {
            Accent = Color3.fromRGB(120, 80, 255),
            AccentDark = Color3.fromRGB(100, 60, 235),
        },
        Amethyst = {
            Accent = Color3.fromRGB(140, 82, 255),
            AccentDark = Color3.fromRGB(120, 62, 235),
        },
        Ocean = {
            Accent = Color3.fromRGB(0, 150, 255),
            AccentDark = Color3.fromRGB(0, 120, 220),
        },
        Rose = {
            Accent = Color3.fromRGB(255, 70, 130),
            AccentDark = Color3.fromRGB(235, 50, 110),
        },
        Green = {
            Accent = Color3.fromRGB(70, 255, 170),
            AccentDark = Color3.fromRGB(50, 235, 150),
        }
    }
    
    -- Appliquer le thème
    local selectedTheme = Themes[windowConfig.Theme] or Themes.Default
    Colors.Accent = selectedTheme.Accent
    Colors.AccentDark = selectedTheme.AccentDark
    
    -- Création du ScreenGui
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "EclipseHubV2"
    MainUI.Parent = game.CoreGui
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainUI.ResetOnSpawn = false
    
    -- Conteneur principal - Affichage direct
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = MainUI
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 620, 0, 460)
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Fenêtre principale
    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.Parent = Container
    Window.BackgroundColor3 = Colors.MainBackground
    Window.BorderSizePixel = 0
    Window.Size = UDim2.new(1, 0, 1, 0)
    Window.ClipsDescendants = true
    
    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = UDim.new(0, 12)
    WindowCorner.Parent = Window
    
    AddStroke(Window, Colors.BorderLight, 1.5)
    AddShadow(Window)
    
    -- Barre de titre avec gradient
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = Window
    TitleBar.BackgroundColor3 = Colors.SecondaryBackground
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    CreateGradient(TitleBar, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Colors.Accent),
        ColorSequenceKeypoint.new(0.5, Colors.AccentDark),
        ColorSequenceKeypoint.new(1, Colors.Accent)
    }, 90)
    
    -- Icon
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Parent = TitleBar
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0, 15, 0.5, 0)
    Icon.Size = UDim2.new(0, 28, 0, 28)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.Image = type(windowConfig.Icon) == "number" and (windowConfig.Icon ~= 0 and "rbxassetid://" .. windowConfig.Icon or "") or (windowConfig.Icon or "")
    Icon.ImageColor3 = Colors.TextPrimary
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 8)
    IconCorner.Parent = Icon
    
    -- Titre
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 50, 0, 8)
    Title.Size = UDim2.new(0.6, -50, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = windowConfig.Name
    Title.TextColor3 = Colors.TextPrimary
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Sous-titre (version)
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Parent = TitleBar
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 50, 0, 26)
    Subtitle.Size = UDim2.new(0.6, -50, 0, 16)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "v2.0 Premium"
    Subtitle.TextColor3 = Colors.TextSecondary
    Subtitle.TextSize = 12
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.TextTransparency = 0.4
    
    -- Boutons de contrôle
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundColor3 = Colors.TertiaryBackground
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -80, 0.5, 0)
    MinimizeButton.Size = UDim2.new(0, 32, 0, 32)
    MinimizeButton.AnchorPoint = Vector2.new(0, 0.5)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Colors.TextPrimary
    MinimizeButton.TextSize = 20
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeButton
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundColor3 = Colors.Danger
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -40, 0.5, 0)
    CloseButton.Size = UDim2.new(0, 32, 0, 32)
    CloseButton.AnchorPoint = Vector2.new(0, 0.5)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Colors.TextPrimary
    CloseButton.TextSize = 24
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    -- Effets hover sur les boutons
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Colors.BorderLight}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Colors.TertiaryBackground}, 0.2)
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 120)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Colors.Danger}, 0.2)
    end)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(Container, {Size = UDim2.new(0, 620, 0, 50)}, 0.3, Enum.EasingStyle.Quad)
            MinimizeButton.Text = "+"
        else
            Tween(Container, {Size = UDim2.new(0, 620, 0, 460)}, 0.3, Enum.EasingStyle.Quad)
            MinimizeButton.Text = "−"
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(Container, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.3)
        MainUI:Destroy()
    end)
    
    -- Frame principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Window
    MainFrame.BackgroundColor3 = Colors.MainBackground
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0, 0, 0, 50)
    MainFrame.Size = UDim2.new(1, 0, 1, -50)
    
    -- Sidebar pour les tabs
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Colors.SecondaryBackground
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar
    
    AddStroke(Sidebar, Colors.Border, 1)
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Parent = Sidebar
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 8)
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingTop = UDim.new(0, 12)
    SidebarPadding.PaddingBottom = UDim.new(0, 12)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)
    
    -- Conteneur de contenu
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 170, 0, 0)
    ContentContainer.Size = UDim2.new(1, -180, 1, -10)
    
    MakeDraggable(Window, TitleBar)
    
    -- Keybind pour toggle l'UI
    if windowConfig.ToggleUIKeybind then
        local keybind = windowConfig.ToggleUIKeybind
        if type(keybind) == "string" then
            keybind = Enum.KeyCode[keybind]
        end
        
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == keybind then
                MainUI.Enabled = not MainUI.Enabled
            end
        end)
    end
    
    WindowTable.CurrentTab = nil
    WindowTable.Tabs = {}
    WindowTable.MainUI = MainUI
    WindowTable.Config = windowConfig
    
    -- Fonction pour créer un nouvel onglet
    function WindowTable:CreateTab(config)
        config = config or {}
        local tabName = config.Name or config.Title or "Tab"
        local tabIcon = config.Icon or "rbxassetid://10723407389"
        
        local TabTable = {}
        
        -- Bouton de l'onglet
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Parent = Sidebar
        TabButton.BackgroundColor3 = Colors.TertiaryBackground
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 42)
        TabButton.AutoButtonColor = false
        TabButton.Text = ""
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        AddStroke(TabButton, Colors.Border, 1)
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 10, 0.5, 0)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.AnchorPoint = Vector2.new(0, 0.5)
        TabIcon.Image = tabIcon
        TabIcon.ImageColor3 = Colors.TextSecondary
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Parent = TabButton
        TabLabel.BackgroundTransparency = 1
        TabLabel.Position = UDim2.new(0, 38, 0, 0)
        TabLabel.Size = UDim2.new(1, -45, 1, 0)
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Colors.TextSecondary
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Indicateur actif
        local ActiveIndicator = Instance.new("Frame")
        ActiveIndicator.Name = "Indicator"
        ActiveIndicator.Parent = TabButton
        ActiveIndicator.BackgroundColor3 = Colors.Accent
        ActiveIndicator.BorderSizePixel = 0
        ActiveIndicator.Position = UDim2.new(0, 0, 0.5, 0)
        ActiveIndicator.Size = UDim2.new(0, 3, 0, 0)
        ActiveIndicator.AnchorPoint = Vector2.new(0, 0.5)
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = ActiveIndicator
        
        CreateGradient(ActiveIndicator, ColorSequence.new{
            ColorSequenceKeypoint.new(0, Colors.Accent),
            ColorSequenceKeypoint.new(1, Colors.Success)
        }, 90)
        
        -- ScrollingFrame pour le contenu
        local Content = Instance.new("ScrollingFrame")
        Content.Name = tabName .. "Content"
        Content.Parent = ContentContainer
        Content.BackgroundTransparency = 1
        Content.BorderSizePixel = 0
        Content.Size = UDim2.new(1, 0, 1, 0)
        Content.Visible = false
        Content.ScrollBarThickness = 6
        Content.ScrollBarImageColor3 = Colors.Accent
        Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        Content.ScrollingDirection = Enum.ScrollingDirection.Y
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Parent = Content
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 10)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = Content
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Content.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Gestion des clics
        TabButton.MouseEnter:Connect(function()
            if WindowTable.CurrentTab ~= TabTable then
                Tween(TabButton, {BackgroundColor3 = Colors.BorderLight}, 0.2)
                Tween(TabIcon, {ImageColor3 = Colors.TextPrimary}, 0.2)
                Tween(TabLabel, {TextColor3 = Colors.TextPrimary}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if WindowTable.CurrentTab ~= TabTable then
                Tween(TabButton, {BackgroundColor3 = Colors.TertiaryBackground}, 0.2)
                Tween(TabIcon, {ImageColor3 = Colors.TextSecondary}, 0.2)
                Tween(TabLabel, {TextColor3 = Colors.TextSecondary}, 0.2)
            end
        end)
        
        TabButton.MouseButton1Click:Connect(function(input)
            CreateRipple(TabButton, Vector2.new(
                TabButton.AbsolutePosition.X + TabButton.AbsoluteSize.X / 2,
                TabButton.AbsolutePosition.Y + TabButton.AbsoluteSize.Y / 2
            ))
            
            for _, tab in pairs(WindowTable.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = Colors.TertiaryBackground}, 0.2)
                Tween(tab.Icon, {ImageColor3 = Colors.TextSecondary}, 0.2)
                Tween(tab.Label, {TextColor3 = Colors.TextSecondary}, 0.2)
                Tween(tab.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
            end
            
            Content.Visible = true
            Tween(TabButton, {BackgroundColor3 = Colors.BorderLight}, 0.2)
            Tween(TabIcon, {ImageColor3 = Colors.Accent}, 0.2)
            Tween(TabLabel, {TextColor3 = Colors.TextPrimary}, 0.2)
            Tween(ActiveIndicator, {Size = UDim2.new(0, 3, 0.6, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            WindowTable.CurrentTab = TabTable
        end)
        
        TabTable.Button = TabButton
        TabTable.Icon = TabIcon
        TabTable.Label = TabLabel
        TabTable.Indicator = ActiveIndicator
        TabTable.Content = Content
        
        if #WindowTable.Tabs == 0 then
            Content.Visible = true
            TabButton.BackgroundColor3 = Colors.BorderLight
            TabIcon.ImageColor3 = Colors.Accent
            TabLabel.TextColor3 = Colors.TextPrimary
            ActiveIndicator.Size = UDim2.new(0, 3, 0.6, 0)
            WindowTable.CurrentTab = TabTable
        end
        
        table.insert(WindowTable.Tabs, TabTable)
        
        -- COMPOSANTS STYLÉS
        
        -- Section (séparateur avec titre)
        function TabTable:CreateSection(text)
            local Section = Instance.new("Frame")
            Section.Name = "Section"
            Section.Parent = Content
            Section.BackgroundTransparency = 1
            Section.Size = UDim2.new(1, 0, 0, 30)
            
            local SectionLine = Instance.new("Frame")
            SectionLine.Name = "Line"
            SectionLine.Parent = Section
            SectionLine.BackgroundColor3 = Colors.Border
            SectionLine.BorderSizePixel = 0
            SectionLine.Position = UDim2.new(0, 0, 0.5, 0)
            SectionLine.Size = UDim2.new(1, 0, 0, 1)
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Name = "Label"
            SectionLabel.Parent = Section
            SectionLabel.BackgroundColor3 = Colors.MainBackground
            SectionLabel.BorderSizePixel = 0
            SectionLabel.Position = UDim2.new(0, 10, 0, 5)
            SectionLabel.Size = UDim2.new(0, 0, 0, 20)
            SectionLabel.AutomaticSize = Enum.AutomaticSize.X
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.Text = "  " .. text .. "  "
            SectionLabel.TextColor3 = Colors.Accent
            SectionLabel.TextSize = 13
            
            return Section
        end
        
        -- Label
        function TabTable:CreateLabel(text)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label"
            LabelFrame.Parent = Content
            LabelFrame.BackgroundColor3 = Colors.SecondaryBackground
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Size = UDim2.new(1, 0, 0, 38)
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 8)
            LabelCorner.Parent = LabelFrame
            
            AddStroke(LabelFrame, Colors.Border, 1)
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Text"
            Label.Parent = LabelFrame
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -20, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Colors.TextPrimary
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            
            local LabelTable = {}
            function LabelTable:UpdateText(newText)
                Label.Text = newText
            end
            
            return LabelTable
        end
        
        -- Paragraph (texte multi-ligne)
        function TabTable:CreateParagraph(title, content)
            local ParaFrame = Instance.new("Frame")
            ParaFrame.Name = "Paragraph"
            ParaFrame.Parent = Content
            ParaFrame.BackgroundColor3 = Colors.SecondaryBackground
            ParaFrame.BorderSizePixel = 0
            ParaFrame.Size = UDim2.new(1, 0, 0, 80)
            ParaFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            local ParaCorner = Instance.new("UICorner")
            ParaCorner.CornerRadius = UDim.new(0, 8)
            ParaCorner.Parent = ParaFrame
            
            AddStroke(ParaFrame, Colors.Border, 1)
            
            local ParaPadding = Instance.new("UIPadding")
            ParaPadding.Parent = ParaFrame
            ParaPadding.PaddingTop = UDim.new(0, 12)
            ParaPadding.PaddingBottom = UDim.new(0, 12)
            ParaPadding.PaddingLeft = UDim.new(0, 12)
            ParaPadding.PaddingRight = UDim.new(0, 12)
            
            local ParaTitle = Instance.new("TextLabel")
            ParaTitle.Name = "Title"
            ParaTitle.Parent = ParaFrame
            ParaTitle.BackgroundTransparency = 1
            ParaTitle.Size = UDim2.new(1, 0, 0, 18)
            ParaTitle.Font = Enum.Font.GothamBold
            ParaTitle.Text = title
            ParaTitle.TextColor3 = Colors.Accent
            ParaTitle.TextSize = 14
            ParaTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local ParaContent = Instance.new("TextLabel")
            ParaContent.Name = "Content"
            ParaContent.Parent = ParaFrame
            ParaContent.BackgroundTransparency = 1
            ParaContent.Position = UDim2.new(0, 0, 0, 22)
            ParaContent.Size = UDim2.new(1, 0, 0, 0)
            ParaContent.AutomaticSize = Enum.AutomaticSize.Y
            ParaContent.Font = Enum.Font.Gotham
            ParaContent.Text = content
            ParaContent.TextColor3 = Colors.TextSecondary
            ParaContent.TextSize = 13
            ParaContent.TextXAlignment = Enum.TextXAlignment.Left
            ParaContent.TextYAlignment = Enum.TextYAlignment.Top
            ParaContent.TextWrapped = true
            
            local ParaTable = {}
            function ParaTable:Update(newTitle, newContent)
                ParaTitle.Text = newTitle
                ParaContent.Text = newContent
            end
            
            return ParaTable
        end
        
        -- Button
        function TabTable:CreateButton(config)
            config = config or {}
            local buttonText = config.Name or config.Text or "Button"
            local buttonCallback = config.Callback or function() end
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "ButtonFrame"
            ButtonFrame.Parent = Content
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = ButtonFrame
            Button.BackgroundColor3 = Colors.Accent
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.GothamBold
            Button.Text = buttonText
            Button.TextColor3 = Colors.TextPrimary
            Button.TextSize = 14
            Button.ClipsDescendants = true
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = Button
            
            CreateGradient(Button, ColorSequence.new{
                ColorSequenceKeypoint.new(0, Colors.Accent),
                ColorSequenceKeypoint.new(1, Colors.AccentDark)
            }, 45)
            
            AddStroke(Button, Colors.Accent, 1.5)
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {Size = UDim2.new(1, 0, 1, 2)}, 0.2, Enum.EasingStyle.Quad)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {Size = UDim2.new(1, 0, 1, 0)}, 0.2, Enum.EasingStyle.Quad)
            end)
            
            Button.MouseButton1Click:Connect(function()
                local pos = UserInputService:GetMouseLocation()
                CreateRipple(Button, Vector2.new(
                    pos.X - Button.AbsolutePosition.X,
                    pos.Y - Button.AbsolutePosition.Y - 36
                ))
                
                Tween(Button, {Size = UDim2.new(0.98, 0, 0.95, 0)}, 0.1)
                wait(0.1)
                Tween(Button, {Size = UDim2.new(1, 0, 1, 0)}, 0.1)
                
                pcall(buttonCallback)
            end)
            
            return Button
        end
        
        -- Toggle (suite dans le prochain message...)
        function TabTable:CreateToggle(config)
            config = config or {}
            local toggleText = config.Name or config.Text or "Toggle"
            local toggleDefault = config.Default or false
            local toggleCallback = config.Callback or function() end
            
            local toggled = toggleDefault
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Parent = Content
            ToggleFrame.BackgroundColor3 = Colors.SecondaryBackground
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            AddStroke(ToggleFrame, Colors.Border, 1)
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "Label"
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.Size = UDim2.new(0.7, -15, 1, 0)
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = Colors.TextPrimary
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = toggled and Colors.Success or Colors.TertiaryBackground
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(1, -65, 0.5, 0)
            ToggleButton.Size = UDim2.new(0, 50, 0, 24)
            ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
            ToggleButton.AutoButtonColor = false
            ToggleButton.Text = ""
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            AddStroke(ToggleButton, toggled and Colors.Success or Colors.Border, 1.5)
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.Parent = ToggleButton
            ToggleIndicator.BackgroundColor3 = Colors.TextPrimary
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Position = toggled and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 4, 0.5, 0)
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            ToggleIndicator.AnchorPoint = Vector2.new(0, 0.5)
            
            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator
            
            AddShadow(ToggleIndicator)
            
            local ToggleIcon = Instance.new("TextLabel")
            ToggleIcon.Name = "Icon"
            ToggleIcon.Parent = ToggleButton
            ToggleIcon.BackgroundTransparency = 1
            ToggleIcon.Size = UDim2.new(1, 0, 1, 0)
            ToggleIcon.Font = Enum.Font.GothamBold
            ToggleIcon.Text = toggled and "✓" or "✕"
            ToggleIcon.TextColor3 = toggled and Colors.Success or Colors.TextTertiary
            ToggleIcon.TextSize = 14
            
            local function UpdateToggle(noCallback)
                Tween(ToggleButton, {
                    BackgroundColor3 = toggled and Colors.Success or Colors.TertiaryBackground
                }, 0.3)
                
                Tween(ToggleIndicator, {
                    Position = toggled and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 4, 0.5, 0)
                }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                
                ToggleIcon.Text = toggled and "✓" or "✕"
                Tween(ToggleIcon, {
                    TextColor3 = toggled and Colors.Success or Colors.TextTertiary
                }, 0.3)
                
                local stroke = ToggleButton:FindFirstChildOfClass("UIStroke")
                if stroke then
                    Tween(stroke, {
                        Color = toggled and Colors.Success or Colors.Border
                    }, 0.3)
                end
                
                if not noCallback then
                    pcall(toggleCallback, toggled)
                end
            end
            
            ToggleButton.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Colors.TertiaryBackground}, 0.2)
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Colors.SecondaryBackground}, 0.2)
            end)
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
            end)
            
            local ToggleTable = {}
            function ToggleTable:SetValue(value)
                toggled = value
                UpdateToggle(true)
            end
            
            return ToggleTable
        end
        
        -- Slider
        function TabTable:CreateSlider(config)
            config = config or {}
            local sliderText = config.Name or config.Text or "Slider"
            local sliderMin = config.Min or 0
            local sliderMax = config.Max or 100
            local sliderDefault = config.Default or sliderMin
            local sliderCallback = config.Callback or function() end
            local sliderIncrement = config.Increment or 1
            
            local value = sliderDefault
            local dragging = false
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Parent = Content
            SliderFrame.BackgroundColor3 = Colors.SecondaryBackground
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            AddStroke(SliderFrame, Colors.Border, 1)
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "Label"
            SliderLabel.Parent = SliderFrame
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 15, 0, 8)
            SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.Text = sliderText
            SliderLabel.TextColor3 = Colors.TextPrimary
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Name = "Value"
            SliderValue.Parent = SliderFrame
            SliderValue.BackgroundColor3 = Colors.TertiaryBackground
            SliderValue.BorderSizePixel = 0
            SliderValue.Position = UDim2.new(1, -60, 0, 6)
            SliderValue.Size = UDim2.new(0, 45, 0, 24)
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.Text = tostring(value)
            SliderValue.TextColor3 = Colors.Accent
            SliderValue.TextSize = 13
            
            local ValueCorner = Instance.new("UICorner")
            ValueCorner.CornerRadius = UDim.new(0, 6)
            ValueCorner.Parent = SliderValue
            
            AddStroke(SliderValue, Colors.Border, 1)
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Name = "Bar"
            SliderBar.Parent = SliderFrame
            SliderBar.BackgroundColor3 = Colors.TertiaryBackground
            SliderBar.BorderSizePixel = 0
            SliderBar.Position = UDim2.new(0, 15, 1, -20)
            SliderBar.Size = UDim2.new(1, -30, 0, 6)
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            AddStroke(SliderBar, Colors.Border, 1)
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.Parent = SliderBar
            SliderFill.BackgroundColor3 = Colors.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((value - sliderMin) / (sliderMax - sliderMin), 0, 1, 0)
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            CreateGradient(SliderFill, ColorSequence.new{
                ColorSequenceKeypoint.new(0, Colors.Accent),
                ColorSequenceKeypoint.new(1, Colors.AccentDark)
            }, 45)
            
            local SliderDot = Instance.new("Frame")
            SliderDot.Name = "Dot"
            SliderDot.Parent = SliderBar
            SliderDot.BackgroundColor3 = Colors.TextPrimary
            SliderDot.BorderSizePixel = 0
            SliderDot.Position = UDim2.new((value - sliderMin) / (sliderMax - sliderMin), 0, 0.5, 0)
            SliderDot.Size = UDim2.new(0, 14, 0, 14)
            SliderDot.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderDot.ZIndex = 2
            
            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = SliderDot
            
            AddStroke(SliderDot, Colors.Accent, 2)
            AddShadow(SliderDot)
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Parent = SliderBar
            SliderButton.BackgroundTransparency = 1
            SliderButton.Size = UDim2.new(1, 0, 1, 10)
            SliderButton.Position = UDim2.new(0, 0, 0, -5)
            SliderButton.Text = ""
            SliderButton.ZIndex = 3
            
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor((sliderMin + (sliderMax - sliderMin) * pos) / sliderIncrement + 0.5) * sliderIncrement
                value = math.clamp(value, sliderMin, sliderMax)
                
                SliderValue.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                Tween(SliderDot, {Position = UDim2.new(pos, 0, 0.5, 0)}, 0.1)
                
                pcall(sliderCallback, value)
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(input)
                    Tween(SliderDot, {Size = UDim2.new(0, 18, 0, 18)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                end
            end)
            
            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    Tween(SliderDot, {Size = UDim2.new(0, 14, 0, 14)}, 0.2)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            SliderButton.MouseEnter:Connect(function()
                Tween(SliderFrame, {BackgroundColor3 = Colors.TertiaryBackground}, 0.2)
            end)
            
            SliderButton.MouseLeave:Connect(function()
                if not dragging then
                    Tween(SliderFrame, {BackgroundColor3 = Colors.SecondaryBackground}, 0.2)
                end
            end)
            
            local SliderTable = {}
            function SliderTable:SetValue(newValue)
                value = math.clamp(newValue, sliderMin, sliderMax)
                local pos = (value - sliderMin) / (sliderMax - sliderMin)
                SliderValue.Text = tostring(value)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                SliderDot.Position = UDim2.new(pos, 0, 0.5, 0)
            end
            
            return SliderTable
        end
        
        -- Dropdown
        function TabTable:CreateDropdown(config)
            config = config or {}
            local dropdownText = config.Name or config.Text or "Dropdown"
            local dropdownOptions = config.Options or {"Option 1", "Option 2"}
            local dropdownDefault = config.Default or dropdownOptions[1]
            local dropdownCallback = config.Callback or function() end
            
            local selected = dropdownDefault
            local expanded = false
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown"
            DropdownFrame.Parent = Content
            DropdownFrame.BackgroundColor3 = Colors.SecondaryBackground
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Size = UDim2.new(1, 0, 0, 45)
            DropdownFrame.ClipsDescendants = true
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            AddStroke(DropdownFrame, Colors.Border, 1)
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Name = "Label"
            DropdownLabel.Parent = DropdownFrame
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
            DropdownLabel.Size = UDim2.new(0.5, -15, 0, 45)
            DropdownLabel.Font = Enum.Font.GothamSemibold
            DropdownLabel.Text = dropdownText
            DropdownLabel.TextColor3 = Colors.TextPrimary
            DropdownLabel.TextSize = 14
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "Button"
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundColor3 = Colors.TertiaryBackground
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Position = UDim2.new(0.5, 5, 0, 8)
            DropdownButton.Size = UDim2.new(0.5, -20, 0, 29)
            DropdownButton.AutoButtonColor = false
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.Text = "  " .. selected
            DropdownButton.TextColor3 = Colors.TextPrimary
            DropdownButton.TextSize = 13
            DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = DropdownButton
            
            AddStroke(DropdownButton, Colors.Border, 1)
            
            local DropdownIcon = Instance.new("TextLabel")
            DropdownIcon.Name = "Icon"
            DropdownIcon.Parent = DropdownButton
            DropdownIcon.BackgroundTransparency = 1
            DropdownIcon.Position = UDim2.new(1, -25, 0, 0)
            DropdownIcon.Size = UDim2.new(0, 25, 1, 0)
            DropdownIcon.Font = Enum.Font.GothamBold
            DropdownIcon.Text = "▼"
            DropdownIcon.TextColor3 = Colors.Accent
            DropdownIcon.TextSize = 12
            
            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Name = "List"
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundColor3 = Colors.TertiaryBackground
            DropdownList.BorderSizePixel = 0
            DropdownList.Position = UDim2.new(0, 10, 0, 50)
            DropdownList.Size = UDim2.new(1, -20, 0, 0)
            DropdownList.Visible = false
            DropdownList.ScrollBarThickness = 4
            DropdownList.ScrollBarImageColor3 = Colors.Accent
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
            
            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 6)
            ListCorner.Parent = DropdownList
            
            AddStroke(DropdownList, Colors.Border, 1)
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = DropdownList
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 2)
            
            local ListPadding = Instance.new("UIPadding")
            ListPadding.Parent = DropdownList
            ListPadding.PaddingTop = UDim.new(0, 5)
            ListPadding.PaddingBottom = UDim.new(0, 5)
            ListPadding.PaddingLeft = UDim.new(0, 5)
            ListPadding.PaddingRight = UDim.new(0, 5)
            
            for _, option in ipairs(dropdownOptions) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Parent = DropdownList
                OptionButton.BackgroundColor3 = option == selected and Colors.Accent or Colors.SecondaryBackground
                OptionButton.BorderSizePixel = 0
                OptionButton.Size = UDim2.new(1, 0, 0, 32)
                OptionButton.AutoButtonColor = false
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = option
                OptionButton.TextColor3 = Colors.TextPrimary
                OptionButton.TextSize = 13
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionButton
                
                if option == selected then
                    CreateGradient(OptionButton, ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Colors.Accent),
                        ColorSequenceKeypoint.new(1, Colors.AccentDark)
                    }, 45)
                end
                
                OptionButton.MouseEnter:Connect(function()
                    if option ~= selected then
                        Tween(OptionButton, {BackgroundColor3 = Colors.BorderLight}, 0.2)
                    end
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    if option ~= selected then
                        Tween(OptionButton, {BackgroundColor3 = Colors.SecondaryBackground}, 0.2)
                    end
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    DropdownButton.Text = "  " .. option
                    
                    for _, child in ipairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            if child.Name == option then
                                Tween(child, {BackgroundColor3 = Colors.Accent}, 0.2)
                                if not child:FindFirstChildOfClass("UIGradient") then
                                    CreateGradient(child, ColorSequence.new{
                                        ColorSequenceKeypoint.new(0, Colors.Accent),
                                        ColorSequenceKeypoint.new(1, Colors.AccentDark)
                                    }, 45)
                                end
                            else
                                Tween(child, {BackgroundColor3 = Colors.SecondaryBackground}, 0.2)
                                local grad = child:FindFirstChildOfClass("UIGradient")
                                if grad then grad:Destroy() end
                            end
                        end
                    end
                    
                    expanded = false
                    DropdownList.Visible = false
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 0}, 0.2)
                    
                    pcall(dropdownCallback, option)
                end)
            end
            
            ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
            end)
            
            DropdownButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                
                if expanded then
                    local listHeight = math.min(ListLayout.AbsoluteContentSize.Y + 10, 150)
                    DropdownList.Visible = true
                    DropdownList.Size = UDim2.new(1, -20, 0, listHeight)
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 60 + listHeight)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 180}, 0.2)
                else
                    DropdownList.Visible = false
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 0}, 0.2)
                end
            end)
            
            DropdownButton.MouseEnter:Connect(function()
                Tween(DropdownButton, {BackgroundColor3 = Colors.BorderLight}, 0.2)
            end)
            
            DropdownButton.MouseLeave:Connect(function()
                Tween(DropdownButton, {BackgroundColor3 = Colors.TertiaryBackground}, 0.2)
            end)
            
            local DropdownTable = {}
            function DropdownTable:SetValue(value)
                selected = value
                DropdownButton.Text = "  " .. value
                
                for _, child in ipairs(DropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        if child.Name == value then
                            child.BackgroundColor3 = Colors.Accent
                            if not child:FindFirstChildOfClass("UIGradient") then
                                CreateGradient(child, ColorSequence.new{
                                    ColorSequenceKeypoint.new(0, Colors.Accent),
                                    ColorSequenceKeypoint.new(1, Colors.AccentDark)
                                }, 45)
                            end
                        else
                            child.BackgroundColor3 = Colors.SecondaryBackground
                            local grad = child:FindFirstChildOfClass("UIGradient")
                            if grad then grad:Destroy() end
                        end
                    end
                end
            end
            
            function DropdownTable:Refresh(newOptions)
                for _, child in ipairs(DropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                for _, option in ipairs(newOptions) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option
                    OptionButton.Parent = DropdownList
                    OptionButton.BackgroundColor3 = option == selected and Colors.Accent or Colors.SecondaryBackground
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Size = UDim2.new(1, 0, 0, 32)
                    OptionButton.AutoButtonColor = false
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Colors.TextPrimary
                    OptionButton.TextSize = 13
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 6)
                    OptionCorner.Parent = OptionButton
                    
                    if option == selected then
                        CreateGradient(OptionButton, ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Colors.Accent),
                            ColorSequenceKeypoint.new(1, Colors.AccentDark)
                        }, 45)
                    end
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selected = option
                        DropdownButton.Text = "  " .. option
                        DropdownTable:SetValue(option)
                        
                        expanded = false
                        DropdownList.Visible = false
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.2)
                        
                        pcall(dropdownCallback, option)
                    end)
                end
            end
            
            return DropdownTable
        end
        
        -- Checkbox
        function TabTable:CreateCheckbox(config)
            config = config or {}
            local checkboxText = config.Name or config.Text or "Checkbox"
            local checkboxDefault = config.Default or false
            local checkboxCallback = config.Callback or function() end
            
            local checked = checkboxDefault
            
            local CheckboxFrame = Instance.new("Frame")
            CheckboxFrame.Name = "Checkbox"
            CheckboxFrame.Parent = Content
            CheckboxFrame.BackgroundColor3 = Colors.SecondaryBackground
            CheckboxFrame.BorderSizePixel = 0
            CheckboxFrame.Size = UDim2.new(1, 0, 0, 45)
            
            local CheckboxCorner = Instance.new("UICorner")
            CheckboxCorner.CornerRadius = UDim.new(0, 8)
            CheckboxCorner.Parent = CheckboxFrame
            
            AddStroke(CheckboxFrame, Colors.Border, 1)
            
            local CheckboxLabel = Instance.new("TextLabel")
            CheckboxLabel.Name = "Label"
            CheckboxLabel.Parent = CheckboxFrame
            CheckboxLabel.BackgroundTransparency = 1
            CheckboxLabel.Position = UDim2.new(0, 15, 0, 0)
            CheckboxLabel.Size = UDim2.new(0.8, -15, 1, 0)
            CheckboxLabel.Font = Enum.Font.GothamSemibold
            CheckboxLabel.Text = checkboxText
            CheckboxLabel.TextColor3 = Colors.TextPrimary
            CheckboxLabel.TextSize = 14
            CheckboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local CheckboxButton = Instance.new("TextButton")
            CheckboxButton.Name = "CheckboxButton"
            CheckboxButton.Parent = CheckboxFrame
            CheckboxButton.BackgroundColor3 = checked and Colors.Success or Colors.TertiaryBackground
            CheckboxButton.BorderSizePixel = 0
            CheckboxButton.Position = UDim2.new(1, -50, 0.5, 0)
            CheckboxButton.Size = UDim2.new(0, 28, 0, 28)
            CheckboxButton.AnchorPoint = Vector2.new(0, 0.5)
            CheckboxButton.AutoButtonColor = false
            CheckboxButton.Text = ""
            
            local CheckboxButtonCorner = Instance.new("UICorner")
            CheckboxButtonCorner.CornerRadius = UDim.new(0, 6)
            CheckboxButtonCorner.Parent = CheckboxButton
            
            AddStroke(CheckboxButton, checked and Colors.Success or Colors.Border, 1.5)
            
            local CheckIcon = Instance.new("TextLabel")
            CheckIcon.Name = "Icon"
            CheckIcon.Parent = CheckboxButton
            CheckIcon.BackgroundTransparency = 1
            CheckIcon.Size = UDim2.new(1, 0, 1, 0)
            CheckIcon.Font = Enum.Font.GothamBold
            CheckIcon.Text = "✓"
            CheckIcon.TextColor3 = Colors.TextPrimary
            CheckIcon.TextSize = 18
            CheckIcon.Visible = checked
            
            if checked then
                CreateGradient(CheckboxButton, ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Colors.Success),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 230, 100))
                }, 45)
            end
            
            CheckboxButton.MouseEnter:Connect(function()
                Tween(CheckboxFrame, {BackgroundColor3 = Colors.TertiaryBackground}, 0.2)
                Tween(CheckboxButton, {Size = UDim2.new(0, 30, 0, 30)}, 0.2)
            end)
            
            CheckboxButton.MouseLeave:Connect(function()
                Tween(CheckboxFrame, {BackgroundColor3 = Colors.SecondaryBackground}, 0.2)
                Tween(CheckboxButton, {Size = UDim2.new(0, 28, 0, 28)}, 0.2)
            end)
            
            CheckboxButton.MouseButton1Click:Connect(function()
                checked = not checked
                CheckIcon.Visible = checked
                
                if checked then
                    Tween(CheckboxButton, {BackgroundColor3 = Colors.Success}, 0.3)
                    if not CheckboxButton:FindFirstChildOfClass("UIGradient") then
                        CreateGradient(CheckboxButton, ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Colors.Success),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 230, 100))
                        }, 45)
                    end
                else
                    Tween(CheckboxButton, {BackgroundColor3 = Colors.TertiaryBackground}, 0.3)
                    local grad = CheckboxButton:FindFirstChildOfClass("UIGradient")
                    if grad then grad:Destroy() end
                end
                
                local stroke = CheckboxButton:FindFirstChildOfClass("UIStroke")
                if stroke then
                    Tween(stroke, {Color = checked and Colors.Success or Colors.Border}, 0.3)
                end
                
                Tween(CheckIcon, {Rotation = checked and 360 or 0}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                
                pcall(checkboxCallback, checked)
            end)
            
            local CheckboxTable = {}
            function CheckboxTable:SetValue(value)
                checked = value
                CheckIcon.Visible = checked
                
                if checked then
                    CheckboxButton.BackgroundColor3 = Colors.Success
                    if not CheckboxButton:FindFirstChildOfClass("UIGradient") then
                        CreateGradient(CheckboxButton, ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Colors.Success),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 230, 100))
                        }, 45)
                    end
                else
                    CheckboxButton.BackgroundColor3 = Colors.TertiaryBackground
                    local grad = CheckboxButton:FindFirstChildOfClass("UIGradient")
                    if grad then grad:Destroy() end
                end
                
                local stroke = CheckboxButton:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = checked and Colors.Success or Colors.Border
                end
            end
            
            return CheckboxTable
        end
        
        -- Input (TextBox)
        function TabTable:CreateInput(config)
            config = config or {}
            local inputText = config.Name or config.Text or "Input"
            local inputDefault = config.Default or ""
            local inputPlaceholder = config.Placeholder or "Enter text..."
            local inputCallback = config.Callback or function() end
            
            local InputFrame = Instance.new("Frame")
            InputFrame.Name = "Input"
            InputFrame.Parent = Content
            InputFrame.BackgroundColor3 = Colors.SecondaryBackground
            InputFrame.BorderSizePixel = 0
            InputFrame.Size = UDim2.new(1, 0, 0, 45)
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 8)
            InputCorner.Parent = InputFrame
            
            AddStroke(InputFrame, Colors.Border, 1)
            
            local InputLabel = Instance.new("TextLabel")
            InputLabel.Name = "Label"
            InputLabel.Parent = InputFrame
            InputLabel.BackgroundTransparency = 1
            InputLabel.Position = UDim2.new(0, 15, 0, 0)
            InputLabel.Size = UDim2.new(0.4, -15, 1, 0)
            InputLabel.Font = Enum.Font.GothamSemibold
            InputLabel.Text = inputText
            InputLabel.TextColor3 = Colors.TextPrimary
            InputLabel.TextSize = 14
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local InputBox = Instance.new("TextBox")
            InputBox.Name = "InputBox"
            InputBox.Parent = InputFrame
            InputBox.BackgroundColor3 = Colors.TertiaryBackground
            InputBox.BorderSizePixel = 0
            InputBox.Position = UDim2.new(0.4, 5, 0, 8)
            InputBox.Size = UDim2.new(0.6, -20, 0, 29)
            InputBox.Font = Enum.Font.Gotham
            InputBox.PlaceholderText = inputPlaceholder
            InputBox.PlaceholderColor3 = Colors.TextTertiary
            InputBox.Text = inputDefault
            InputBox.TextColor3 = Colors.TextPrimary
            InputBox.TextSize = 13
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.ClearTextOnFocus = false
            
            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 6)
            InputBoxCorner.Parent = InputBox
            
            local InputBoxPadding = Instance.new("UIPadding")
            InputBoxPadding.Parent = InputBox
            InputBoxPadding.PaddingLeft = UDim.new(0, 10)
            InputBoxPadding.PaddingRight = UDim.new(0, 10)
            
            AddStroke(InputBox, Colors.Border, 1)
            
            InputBox.Focused:Connect(function()
                Tween(InputFrame, {BackgroundColor3 = Colors.TertiaryBackground}, 0.2)
                local stroke = InputBox:FindFirstChildOfClass("UIStroke")
                if stroke then
                    Tween(stroke, {Color = Colors.Accent, Thickness = 1.5}, 0.2)
                end
            end)
            
            InputBox.FocusLost:Connect(function()
                Tween(InputFrame, {BackgroundColor3 = Colors.SecondaryBackground}, 0.2)
                local stroke = InputBox:FindFirstChildOfClass("UIStroke")
                if stroke then
                    Tween(stroke, {Color = Colors.Border, Thickness = 1}, 0.2)
                end
                pcall(inputCallback, InputBox.Text)
            end)
            
            local InputTable = {}
            function InputTable:SetValue(value)
                InputBox.Text = value
            end
            
            return InputTable
        end
        
        return TabTable
    end
    
    -- Fonction pour notifier
    function WindowTable:Notify(config)
        config = config or {}
        local title = config.Title or "Notification"
        local content = config.Content or "Contenu de la notification"
        local duration = config.Duration or 3
        local icon = config.Icon or "rbxassetid://10723407389"
        
        local NotifContainer = Instance.new("Frame")
        NotifContainer.Name = "Notification"
        NotifContainer.Parent = MainUI
        NotifContainer.BackgroundColor3 = Colors.SecondaryBackground
        NotifContainer.BorderSizePixel = 0
        NotifContainer.Position = UDim2.new(1, -320, 1, 10)
        NotifContainer.Size = UDim2.new(0, 300, 0, 80)
        NotifContainer.ClipsDescendants = true
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 10)
        NotifCorner.Parent = NotifContainer
        
        AddStroke(NotifContainer, Colors.BorderLight, 1.5)
        AddShadow(NotifContainer)
        
        local NotifAccent = Instance.new("Frame")
        NotifAccent.Name = "Accent"
        NotifAccent.Parent = NotifContainer
        NotifAccent.BackgroundColor3 = Colors.Accent
        NotifAccent.BorderSizePixel = 0
        NotifAccent.Size = UDim2.new(0, 4, 1, 0)
        
        CreateGradient(NotifAccent, ColorSequence.new{
            ColorSequenceKeypoint.new(0, Colors.Accent),
            ColorSequenceKeypoint.new(1, Colors.AccentDark)
        }, 90)
        
        local NotifIcon = Instance.new("ImageLabel")
        NotifIcon.Name = "Icon"
        NotifIcon.Parent = NotifContainer
        NotifIcon.BackgroundTransparency = 1
        NotifIcon.Position = UDim2.new(0, 15, 0, 12)
        NotifIcon.Size = UDim2.new(0, 24, 0, 24)
        NotifIcon.Image = icon
        NotifIcon.ImageColor3 = Colors.Accent
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Name = "Title"
        NotifTitle.Parent = NotifContainer
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Position = UDim2.new(0, 48, 0, 10)
        NotifTitle.Size = UDim2.new(1, -55, 0, 20)
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Colors.TextPrimary
        NotifTitle.TextSize = 14
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local NotifContent = Instance.new("TextLabel")
        NotifContent.Name = "Content"
        NotifContent.Parent = NotifContainer
        NotifContent.BackgroundTransparency = 1
        NotifContent.Position = UDim2.new(0, 48, 0, 32)
        NotifContent.Size = UDim2.new(1, -55, 0, 40)
        NotifContent.Font = Enum.Font.Gotham
        NotifContent.Text = content
        NotifContent.TextColor3 = Colors.TextSecondary
        NotifContent.TextSize = 12
        NotifContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifContent.TextYAlignment = Enum.TextYAlignment.Top
        NotifContent.TextWrapped = true
        
        Tween(NotifContainer, {Position = UDim2.new(1, -320, 1, -100)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        wait(duration)
        
        Tween(NotifContainer, {Position = UDim2.new(1, -320, 1, 10)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        wait(0.3)
        NotifContainer:Destroy()
    end
    
    return WindowTable
end

return Library
