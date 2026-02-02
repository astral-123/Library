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
    local title = config.Name or config.Title or "Eclipse Hub"
    local subtitle = config.Subtitle or "Premium UI Library"
    local icon = config.Icon or "rbxassetid://10723407389"
    
    local WindowTable = {}
    
    -- Création du ScreenGui avec effet de blur
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "EclipseHubV2"
    MainUI.Parent = game.CoreGui
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainUI.ResetOnSpawn = false
    
    -- Background blur
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Parent = game.Lighting
    Tween(Blur, {Size = 8}, 0.5)
    
    -- Conteneur principal avec animation d'apparition
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = MainUI
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 0, 0, 0)
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
    
    -- Animation d'ouverture
    Tween(Container, {Size = UDim2.new(0, 620, 0, 460)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
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
    Icon.Image = icon
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
    Title.Text = title
    Title.TextColor3 = Colors.TextPrimary
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Sous-titre
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Parent = TitleBar
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 50, 0, 26)
    Subtitle.Size = UDim2.new(0.6, -50, 0, 16)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = subtitle
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
        Tween(Blur, {Size = 0}, 0.3)
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
    
    WindowTable.CurrentTab = nil
    WindowTable.Tabs = {}
    WindowTable.MainUI = MainUI
    
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
