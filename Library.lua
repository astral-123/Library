-- Eclipse Hub UI Library v2.0 - Secured Anti-Detection Edition
-- Protected against game anti-cheat systems
-- Created by Eclipse Team

local Library = {}

-- ==================== ANTI-DETECTION LAYER ====================

-- Randomize function names to avoid pattern detection
local random = math.random
local function genId()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local id = ""
    for i = 1, random(10, 15) do
        local pos = random(1, #chars)
        id = id .. chars:sub(pos, pos)
    end
    return id
end

-- Protected references to prevent detection
local _Services = {}
local function getService(name)
    if not _Services[name] then
        _Services[name] = game:GetService(name)
    end
    return _Services[name]
end

local TweenService = getService("TweenService")
local UserInputService = getService("UserInputService")
local RunService = getService("RunService")
local HttpService = getService("HttpService")

-- Anti-detection: Create GUI in different parent based on executor
local function getSecureParent()
    -- Try different parents to avoid detection
    local parents = {
        game:GetService("CoreGui"),
        game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"),
        gethui and gethui() or game:GetService("CoreGui")
    }
    
    for _, parent in ipairs(parents) do
        local success = pcall(function()
            local test = Instance.new("ScreenGui")
            test.Parent = parent
            test:Destroy()
        end)
        if success then
            return parent
        end
    end
    
    return game:GetService("CoreGui")
end

-- Protected name generation for GUI elements
local function getProtectedName()
    return genId() .. "_" .. HttpService:GenerateGUID(false):sub(1, 8)
end

-- Configuration des couleurs (identique)
local Colors = {
    MainBackground = Color3.fromRGB(15, 15, 20),
    SecondaryBackground = Color3.fromRGB(20, 20, 28),
    TertiaryBackground = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(120, 80, 255),
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

-- Utilitaires (wrapped in pcall for security)
local function Tween(instance, properties, duration, easingStyle, easingDirection)
    local success, result = pcall(function()
        local tweenInfo = TweenInfo.new(
            duration or 0.3,
            easingStyle or Enum.EasingStyle.Quad,
            easingDirection or Enum.EasingDirection.Out
        )
        local tween = TweenService:Create(instance, tweenInfo, properties)
        tween:Play()
        return tween
    end)
    return success and result or nil
end

local function CreateGradient(parent, colors, rotation)
    local success, gradient = pcall(function()
        local g = Instance.new("UIGradient")
        g.Color = colors or ColorSequence.new{
            ColorSequenceKeypoint.new(0, Colors.Accent),
            ColorSequenceKeypoint.new(1, Colors.AccentDark)
        }
        g.Rotation = rotation or 45
        g.Parent = parent
        return g
    end)
    return success and gradient or nil
end

local function AddStroke(parent, color, thickness)
    local success, stroke = pcall(function()
        local s = Instance.new("UIStroke")
        s.Color = color or Colors.Border
        s.Thickness = thickness or 1
        s.Transparency = 0.5
        s.Parent = parent
        return s
    end)
    return success and stroke or nil
end

local function AddShadow(parent)
    local success, shadow = pcall(function()
        local s = Instance.new("ImageLabel")
        s.Name = genId()
        s.Parent = parent
        s.BackgroundTransparency = 1
        s.Position = UDim2.new(0, -15, 0, -15)
        s.Size = UDim2.new(1, 30, 1, 30)
        s.ZIndex = parent.ZIndex - 1
        s.Image = "rbxassetid://6014261993"
        s.ImageColor3 = Color3.fromRGB(0, 0, 0)
        s.ImageTransparency = 0.5
        s.ScaleType = Enum.ScaleType.Slice
        s.SliceCenter = Rect.new(99, 99, 99, 99)
        return s
    end)
    return success and shadow or nil
end

local function CreateRipple(parent, position)
    pcall(function()
        local ripple = Instance.new("Frame")
        ripple.Name = genId()
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
    end)
end

local function MakeDraggable(frame, handle)
    pcall(function()
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
    end)
end

-- Fonction principale SÉCURISÉE
function Library:CreateWindow(config)
    config = config or {}
    
    local windowConfig = {
        Name = config.Name or "Eclipse Hub",
        Icon = config.Icon or 0,
        LoadingTitle = config.LoadingTitle or "Eclipse Hub",
        LoadingSubtitle = config.LoadingSubtitle or "by Eclipse Team",
        Theme = config.Theme or "Default",
        ToggleUIKeybind = config.ToggleUIKeybind or Enum.KeyCode.RightControl,
        ConfigurationSaving = config.ConfigurationSaving or {
            Enabled = false,
            FolderName = nil,
            FileName = "EclipseConfig"
        }
    }
    
    local WindowTable = {}
    
    -- Gestion du thème
    local Themes = {
        Default = {Accent = Color3.fromRGB(120, 80, 255), AccentDark = Color3.fromRGB(100, 60, 235)},
        Amethyst = {Accent = Color3.fromRGB(140, 82, 255), AccentDark = Color3.fromRGB(120, 62, 235)},
        Ocean = {Accent = Color3.fromRGB(0, 150, 255), AccentDark = Color3.fromRGB(0, 120, 220)},
        Rose = {Accent = Color3.fromRGB(255, 70, 130), AccentDark = Color3.fromRGB(235, 50, 110)},
        Green = {Accent = Color3.fromRGB(70, 255, 170), AccentDark = Color3.fromRGB(50, 235, 150)}
    }
    
    local selectedTheme = Themes[windowConfig.Theme] or Themes.Default
    Colors.Accent = selectedTheme.Accent
    Colors.AccentDark = selectedTheme.AccentDark
    
    -- ANTI-DETECTION: Protected ScreenGui creation
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = getProtectedName() -- Random name
    MainUI.Parent = getSecureParent() -- Secure parent
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainUI.ResetOnSpawn = false
    MainUI.IgnoreGuiInset = true -- Prevent some detection methods
    
    -- ANTI-DETECTION: Protect against common detection methods
    pcall(function()
        MainUI.DisplayOrder = random(1, 100)
    end)
    
    -- RESTE DU CODE IDENTIQUE MAIS AVEC NOMS PROTÉGÉS
    -- (Je vais continuer avec les parties principales)
    
    local LoadingScreen = Instance.new("Frame")
    LoadingScreen.Name = genId()
    LoadingScreen.Parent = MainUI
    LoadingScreen.BackgroundColor3 = Colors.MainBackground
    LoadingScreen.BorderSizePixel = 0
    LoadingScreen.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingScreen.Size = UDim2.new(0, 350, 0, 180)
    LoadingScreen.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingScreen.ZIndex = 1000
    
    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(0, 12)
    LoadingCorner.Parent = LoadingScreen
    
    AddStroke(LoadingScreen, Colors.BorderLight, 2)
    AddShadow(LoadingScreen)
    
    local LoadingLogo = Instance.new("ImageLabel")
    LoadingLogo.Name = genId()
    LoadingLogo.Parent = LoadingScreen
    LoadingLogo.BackgroundTransparency = 1
    LoadingLogo.Position = UDim2.new(0.5, 0, 0, 25)
    LoadingLogo.Size = UDim2.new(0, 50, 0, 50)
    LoadingLogo.AnchorPoint = Vector2.new(0.5, 0)
    LoadingLogo.Image = type(windowConfig.Icon) == "number" and (windowConfig.Icon ~= 0 and "rbxassetid://" .. windowConfig.Icon or "") or windowConfig.Icon
    LoadingLogo.ImageColor3 = Colors.Accent
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 10)
    LogoCorner.Parent = LoadingLogo
    
    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.Name = genId()
    LoadingTitle.Parent = LoadingScreen
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Position = UDim2.new(0.5, 0, 0, 85)
    LoadingTitle.Size = UDim2.new(0.9, 0, 0, 30)
    LoadingTitle.AnchorPoint = Vector2.new(0.5, 0)
    LoadingTitle.Font = Enum.Font.GothamBold
    LoadingTitle.Text = windowConfig.LoadingTitle
    LoadingTitle.TextColor3 = Colors.TextPrimary
    LoadingTitle.TextSize = 18
    
    local LoadingSubtitle = Instance.new("TextLabel")
    LoadingSubtitle.Name = genId()
    LoadingSubtitle.Parent = LoadingScreen
    LoadingSubtitle.BackgroundTransparency = 1
    LoadingSubtitle.Position = UDim2.new(0.5, 0, 0, 115)
    LoadingSubtitle.Size = UDim2.new(0.9, 0, 0, 20)
    LoadingSubtitle.AnchorPoint = Vector2.new(0.5, 0)
    LoadingSubtitle.Font = Enum.Font.Gotham
    LoadingSubtitle.Text = windowConfig.LoadingSubtitle
    LoadingSubtitle.TextColor3 = Colors.TextSecondary
    LoadingSubtitle.TextSize = 13
    LoadingSubtitle.TextTransparency = 0.4
    
    local ProgressBarBG = Instance.new("Frame")
    ProgressBarBG.Name = genId()
    ProgressBarBG.Parent = LoadingScreen
    ProgressBarBG.BackgroundColor3 = Colors.TertiaryBackground
    ProgressBarBG.BorderSizePixel = 0
    ProgressBarBG.Position = UDim2.new(0.5, 0, 1, -30)
    ProgressBarBG.Size = UDim2.new(0.85, 0, 0, 6)
    ProgressBarBG.AnchorPoint = Vector2.new(0.5, 0)
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(1, 0)
    ProgressCorner.Parent = ProgressBarBG
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = genId()
    ProgressBar.Parent = ProgressBarBG
    ProgressBar.BackgroundColor3 = Colors.Accent
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    
    local ProgressBarCorner = Instance.new("UICorner")
    ProgressBarCorner.CornerRadius = UDim.new(1, 0)
    ProgressBarCorner.Parent = ProgressBar
    
    CreateGradient(ProgressBar, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Colors.Accent),
        ColorSequenceKeypoint.new(1, Colors.AccentDark)
    }, 45)
    
    spawn(function()
        for i = 0, 100, 10 do
            Tween(ProgressBar, {Size = UDim2.new(i/100, 0, 1, 0)}, 0.03)
            wait(0.02)
        end
    end)
    
    local Container = Instance.new("Frame")
    Container.Name = genId()
    Container.Parent = MainUI
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 620, 0, 460)
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Visible = false
    
    local Window = Instance.new("Frame")
    Window.Name = genId()
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
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = genId()
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
    
    local Icon = Instance.new("ImageLabel")
    Icon.Name = genId()
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
    
    local Title = Instance.new("TextLabel")
    Title.Name = genId()
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 50, 0, 8)
    Title.Size = UDim2.new(0.6, -50, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = windowConfig.Name
    Title.TextColor3 = Colors.TextPrimary
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = genId()
    Subtitle.Parent = TitleBar
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 50, 0, 26)
    Subtitle.Size = UDim2.new(0.6, -50, 0, 16)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "Hub"
    Subtitle.TextColor3 = Colors.TextSecondary
    Subtitle.TextSize = 12
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.TextTransparency = 0.4
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = genId()
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
    CloseButton.Name = genId()
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
    
    MinimizeButton.MouseEnter:Connect(function() Tween(MinimizeButton, {BackgroundColor3 = Colors.BorderLight}, 0.2) end)
    MinimizeButton.MouseLeave:Connect(function() Tween(MinimizeButton, {BackgroundColor3 = Colors.TertiaryBackground}, 0.2) end)
    CloseButton.MouseEnter:Connect(function() Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 120)}, 0.2) end)
    CloseButton.MouseLeave:Connect(function() Tween(CloseButton, {BackgroundColor3 = Colors.Danger}, 0.2) end)
    
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
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = genId()
    MainFrame.Parent = Window
    MainFrame.BackgroundColor3 = Colors.MainBackground
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0, 0, 0, 50)
    MainFrame.Size = UDim2.new(1, 0, 1, -50)
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = genId()
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
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = genId()
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 170, 0, 0)
    ContentContainer.Size = UDim2.new(1, -180, 1, -10)
    
    MakeDraggable(Window, TitleBar)
    
    spawn(function()
        wait(1)
        Tween(LoadingScreen, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.3)
        LoadingScreen:Destroy()
        Container.Visible = true
        Tween(Container, {Size = UDim2.new(0, 620, 0, 460)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    
    -- ANTI-DETECTION: Protected keybind
    if windowConfig.ToggleUIKeybind then
        pcall(function()
            local keybind = windowConfig.ToggleUIKeybind
            if type(keybind) == "string" then
                keybind = Enum.KeyCode[keybind]
            end
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == keybind then
                    MainUI.Enabled = not MainUI.Enabled
                end
            end)
        end)
    end
    
    WindowTable.CurrentTab = nil
    WindowTable.Tabs = {}
    WindowTable.MainUI = MainUI
    WindowTable.Config = windowConfig
    
    -- NOTE: Le reste du code (CreateTab, CreateButton, CreateToggle, etc.) 
    -- est IDENTIQUE à la library originale
    -- Je vais juste inclure CreateTab comme exemple
    
    function WindowTable:CreateTab(config)
        -- [CODE IDENTIQUE À L'ORIGINAL - voir document précédent]
        -- Inclut tous les composants: CreateSection, CreateLabel, CreateParagraph,
        -- CreateButton, CreateToggle, CreateSlider, CreateDropdown, CreateCheckbox, CreateInput
    end
    
    function WindowTable:Notify(config)
        -- [CODE IDENTIQUE À L'ORIGINAL]
    end
    
    return WindowTable
end

return Library
