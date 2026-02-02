-- Eclipse Hub UI Library
-- Version: 1.0
-- By: Eclipse Team

local Library = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Utilitaires
local function Tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame)
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
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

    frame.InputChanged:Connect(function(input)
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
            }, 0.1)
        end
    end)
end

-- Fonction principale pour créer la fenêtre
function Library:CreateWindow(title)
    local WindowTable = {}
    
    -- Création du ScreenGui
    local MainUI = Instance.new("ScreenGui")
    local Window = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")
    local UICorner_2 = Instance.new("UICorner")
    local FrameUi = Instance.new("Frame")
    local UICorner_3 = Instance.new("UICorner")
    local Tab = Instance.new("Frame")
    local UICorner_4 = Instance.new("UICorner")
    local UIListLayout = Instance.new("UIListLayout")
    
    -- Configuration du ScreenGui
    MainUI.Name = "EclipseHub"
    MainUI.Parent = game.CoreGui
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Configuration de la fenêtre
    Window.Name = "Window"
    Window.Parent = MainUI
    Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Window.BorderSizePixel = 0
    Window.Position = UDim2.new(0.3, 0, 0.28, 0)
    Window.Size = UDim2.new(0, 576, 0, 338)
    Window.Active = true
    
    UICorner_2.CornerRadius = UDim.new(0, 8)
    UICorner_2.Parent = Window
    
    -- Configuration du titre
    Title.Name = "Title"
    Title.Parent = Window
    Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 31)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = title or "Eclipse Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Title
    
    -- Configuration du Frame principal
    FrameUi.Name = "FrameUi"
    FrameUi.Parent = Window
    FrameUi.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    FrameUi.BorderSizePixel = 0
    FrameUi.Position = UDim2.new(0, 0, 0.095, 0)
    FrameUi.Size = UDim2.new(1, 0, 0.905, 0)
    
    UICorner_3.CornerRadius = UDim.new(0, 8)
    UICorner_3.Parent = FrameUi
    
    -- Configuration des Tabs
    Tab.Name = "Tab"
    Tab.Parent = FrameUi
    Tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Tab.BorderSizePixel = 0
    Tab.Size = UDim2.new(0, 130, 1, 0)
    
    UICorner_4.CornerRadius = UDim.new(0, 8)
    UICorner_4.Parent = Tab
    
    UIListLayout.Parent = Tab
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    
    -- Rendre la fenêtre draggable
    MakeDraggable(Window)
    
    WindowTable.CurrentTab = nil
    WindowTable.Tabs = {}
    
    -- Fonction pour créer un nouvel onglet
    function WindowTable:CreateTab(tabName)
        local TabTable = {}
        
        -- Création du bouton de l'onglet
        local TabButton = Instance.new("TextButton")
        local UICorner_5 = Instance.new("UICorner")
        local Content = Instance.new("ScrollingFrame")
        local UICorner_6 = Instance.new("UICorner")
        local UIListLayout_2 = Instance.new("UIListLayout")
        
        TabButton.Name = tabName
        TabButton.Parent = Tab
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 50)
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 18
        
        UICorner_5.CornerRadius = UDim.new(0, 6)
        UICorner_5.Parent = TabButton
        
        -- Création du contenu de l'onglet
        Content.Name = tabName .. "Content"
        Content.Parent = FrameUi
        Content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Content.BorderSizePixel = 0
        Content.Position = UDim2.new(0.226, 0, 0, 0)
        Content.Size = UDim2.new(0.774, 0, 1, 0)
        Content.Visible = false
        Content.ScrollBarThickness = 4
        Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        UICorner_6.CornerRadius = UDim.new(0, 8)
        UICorner_6.Parent = Content
        
        UIListLayout_2.Parent = Content
        UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_2.Padding = UDim.new(0, 5)
        
        -- Mise à jour automatique de la taille du canvas
        UIListLayout_2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Content.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 10)
        end)
        
        -- Gestion du clic sur l'onglet
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(WindowTable.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
            end
            
            Content.Visible = true
            Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
            WindowTable.CurrentTab = TabTable
        end)
        
        TabTable.Button = TabButton
        TabTable.Content = Content
        
        -- Si c'est le premier onglet, l'afficher par défaut
        if #WindowTable.Tabs == 0 then
            Content.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            WindowTable.CurrentTab = TabTable
        end
        
        table.insert(WindowTable.Tabs, TabTable)
        
        -- FONCTION: Créer un bouton
        function TabTable:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            local UICorner_7 = Instance.new("UICorner")
            
            Button.Name = "Button"
            Button.Parent = Content
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(0.95, 0, 0, 38)
            Button.Font = Enum.Font.SourceSansBold
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 16
            
            UICorner_7.CornerRadius = UDim.new(0, 6)
            UICorner_7.Parent = Button
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
            end)
            
            Button.MouseButton1Click:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.1)
                wait(0.1)
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.1)
                if callback then
                    pcall(callback)
                end
            end)
            
            return Button
        end
        
        -- FONCTION: Créer un label
        function TabTable:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            local UICorner_8 = Instance.new("UICorner")
            
            Label.Name = "Label"
            Label.Parent = Content
            Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Label.BorderSizePixel = 0
            Label.Size = UDim2.new(0.95, 0, 0, 38)
            Label.Font = Enum.Font.SourceSans
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 16
            
            UICorner_8.CornerRadius = UDim.new(0, 6)
            UICorner_8.Parent = Label
            
            local LabelTable = {}
            
            function LabelTable:UpdateText(newText)
                Label.Text = newText
            end
            
            return LabelTable
        end
        
        -- FONCTION: Créer un toggle
        function TabTable:CreateToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            local UICorner_9 = Instance.new("UICorner")
            local ToggleLabel = Instance.new("TextLabel")
            local ToggleButton = Instance.new("TextButton")
            local ToggleIndicator = Instance.new("Frame")
            local UICorner_10 = Instance.new("UICorner")
            
            local toggled = default or false
            
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Parent = Content
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(0.95, 0, 0, 38)
            
            UICorner_9.CornerRadius = UDim.new(0, 6)
            UICorner_9.Parent = ToggleFrame
            
            ToggleLabel.Name = "Label"
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.Font = Enum.Font.SourceSans
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleLabel.TextSize = 16
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(0.85, 0, 0.2, 0)
            ToggleButton.Size = UDim2.new(0, 50, 0.6, 0)
            ToggleButton.Text = ""
            
            UICorner_10.CornerRadius = UDim.new(1, 0)
            UICorner_10.Parent = ToggleButton
            
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.Parent = ToggleButton
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Position = UDim2.new(0.1, 0, 0.15, 0)
            ToggleIndicator.Size = UDim2.new(0.35, 0, 0.7, 0)
            
            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator
            
            local function UpdateToggle()
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(0, 170, 0)})
                    Tween(ToggleIndicator, {
                        Position = UDim2.new(0.55, 0, 0.15, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    })
                else
                    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                    Tween(ToggleIndicator, {
                        Position = UDim2.new(0.1, 0, 0.15, 0),
                        BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                    })
                end
            end
            
            UpdateToggle()
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
                if callback then
                    pcall(callback, toggled)
                end
            end)
            
            local ToggleTable = {}
            
            function ToggleTable:SetValue(value)
                toggled = value
                UpdateToggle()
            end
            
            return ToggleTable
        end
        
        -- FONCTION: Créer un slider
        function TabTable:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            local UICorner_11 = Instance.new("UICorner")
            local SliderLabel = Instance.new("TextLabel")
            local SliderValue = Instance.new("TextLabel")
            local SliderBar = Instance.new("Frame")
            local UICorner_12 = Instance.new("UICorner")
            local SliderFill = Instance.new("Frame")
            local UICorner_13 = Instance.new("UICorner")
            local SliderButton = Instance.new("TextButton")
            
            local value = default or min
            local dragging = false
            
            SliderFrame.Name = "Slider"
            SliderFrame.Parent = Content
            SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(0.95, 0, 0, 55)
            
            UICorner_11.CornerRadius = UDim.new(0, 6)
            UICorner_11.Parent = SliderFrame
            
            SliderLabel.Name = "Label"
            SliderLabel.Parent = SliderFrame
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
            SliderLabel.Font = Enum.Font.SourceSans
            SliderLabel.Text = text
            SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderLabel.TextSize = 16
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            SliderValue.Name = "Value"
            SliderValue.Parent = SliderFrame
            SliderValue.BackgroundTransparency = 1
            SliderValue.Position = UDim2.new(0.7, 0, 0, 5)
            SliderValue.Size = UDim2.new(0.25, 0, 0, 20)
            SliderValue.Font = Enum.Font.SourceSansBold
            SliderValue.Text = tostring(value)
            SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.TextSize = 16
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            
            SliderBar.Name = "Bar"
            SliderBar.Parent = SliderFrame
            SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SliderBar.BorderSizePixel = 0
            SliderBar.Position = UDim2.new(0, 10, 0.6, 0)
            SliderBar.Size = UDim2.new(0.95, -10, 0, 8)
            
            UICorner_12.CornerRadius = UDim.new(1, 0)
            UICorner_12.Parent = SliderBar
            
            SliderFill.Name = "Fill"
            SliderFill.Parent = SliderBar
            SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            
            UICorner_13.CornerRadius = UDim.new(1, 0)
            UICorner_13.Parent = SliderFill
            
            SliderButton.Name = "SliderButton"
            SliderButton.Parent = SliderBar
            SliderButton.BackgroundTransparency = 1
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.Text = ""
            
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos)
                
                SliderValue.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                
                if callback then
                    pcall(callback, value)
                end
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            local SliderTable = {}
            
            function SliderTable:SetValue(newValue)
                value = math.clamp(newValue, min, max)
                SliderValue.Text = tostring(value)
                local pos = (value - min) / (max - min)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            end
            
            return SliderTable
        end
        
        -- FONCTION: Créer un dropdown
        function TabTable:CreateDropdown(text, options, callback)
            local DropdownFrame = Instance.new("Frame")
            local UICorner_14 = Instance.new("UICorner")
            local DropdownLabel = Instance.new("TextLabel")
            local DropdownButton = Instance.new("TextButton")
            local UICorner_15 = Instance.new("UICorner")
            local DropdownIcon = Instance.new("TextLabel")
            local DropdownList = Instance.new("ScrollingFrame")
            local UICorner_16 = Instance.new("UICorner")
            local UIListLayout_3 = Instance.new("UIListLayout")
            
            local expanded = false
            local selected = options[1] or "None"
            
            DropdownFrame.Name = "Dropdown"
            DropdownFrame.Parent = Content
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Size = UDim2.new(0.95, 0, 0, 38)
            DropdownFrame.ClipsDescendants = true
            
            UICorner_14.CornerRadius = UDim.new(0, 6)
            UICorner_14.Parent = DropdownFrame
            
            DropdownLabel.Name = "Label"
            DropdownLabel.Parent = DropdownFrame
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.Size = UDim2.new(0.5, 0, 0, 38)
            DropdownLabel.Font = Enum.Font.SourceSans
            DropdownLabel.Text = text
            DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownLabel.TextSize = 16
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            DropdownButton.Name = "Button"
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Position = UDim2.new(0.5, 5, 0, 5)
            DropdownButton.Size = UDim2.new(0.45, -10, 0, 28)
            DropdownButton.Font = Enum.Font.SourceSans
            DropdownButton.Text = selected
            DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownButton.TextSize = 14
            
            UICorner_15.CornerRadius = UDim.new(0, 4)
            UICorner_15.Parent = DropdownButton
            
            DropdownIcon.Name = "Icon"
            DropdownIcon.Parent = DropdownButton
            DropdownIcon.BackgroundTransparency = 1
            DropdownIcon.Position = UDim2.new(0.9, 0, 0, 0)
            DropdownIcon.Size = UDim2.new(0.1, 0, 1, 0)
            DropdownIcon.Font = Enum.Font.SourceSansBold
            DropdownIcon.Text = "▼"
            DropdownIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownIcon.TextSize = 12
            
            DropdownList.Name = "List"
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            DropdownList.BorderSizePixel = 0
            DropdownList.Position = UDim2.new(0, 5, 0, 43)
            DropdownList.Size = UDim2.new(1, -10, 0, 0)
            DropdownList.Visible = false
            DropdownList.ScrollBarThickness = 4
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
            
            UICorner_16.CornerRadius = UDim.new(0, 4)
            UICorner_16.Parent = DropdownList
            
            UIListLayout_3.Parent = DropdownList
            UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout_3.Padding = UDim.new(0, 2)
            
            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                local UICorner_17 = Instance.new("UICorner")
                
                OptionButton.Name = option
                OptionButton.Parent = DropdownList
                OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                OptionButton.BorderSizePixel = 0
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.Font = Enum.Font.SourceSans
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                OptionButton.TextSize = 14
                
                UICorner_17.CornerRadius = UDim.new(0, 4)
                UICorner_17.Parent = OptionButton
                
                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    DropdownButton.Text = option
                    
                    expanded = false
                    DropdownList.Visible = false
                    Tween(DropdownFrame, {Size = UDim2.new(0.95, 0, 0, 38)})
                    Tween(DropdownIcon, {Rotation = 0})
                    
                    if callback then
                        pcall(callback, option)
                    end
                end)
            end
            
            UIListLayout_3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_3.AbsoluteContentSize.Y + 5)
            end)
            
            DropdownButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                
                if expanded then
                    local listHeight = math.min(UIListLayout_3.AbsoluteContentSize.Y + 5, 120)
                    DropdownList.Visible = true
                    DropdownList.Size = UDim2.new(1, -10, 0, listHeight)
                    Tween(DropdownFrame, {Size = UDim2.new(0.95, 0, 0, 48 + listHeight)})
                    Tween(DropdownIcon, {Rotation = 180})
                else
                    DropdownList.Visible = false
                    Tween(DropdownFrame, {Size = UDim2.new(0.95, 0, 0, 38)})
                    Tween(DropdownIcon, {Rotation = 0})
                end
            end)
            
            local DropdownTable = {}
            
            function DropdownTable:SetValue(value)
                selected = value
                DropdownButton.Text = value
            end
            
            function DropdownTable:Refresh(newOptions)
                for _, child in ipairs(DropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                for _, option in ipairs(newOptions) do
                    local OptionButton = Instance.new("TextButton")
                    local UICorner_17 = Instance.new("UICorner")
                    
                    OptionButton.Name = option
                    OptionButton.Parent = DropdownList
                    OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Size = UDim2.new(1, 0, 0, 30)
                    OptionButton.Font = Enum.Font.SourceSans
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptionButton.TextSize = 14
                    
                    UICorner_17.CornerRadius = UDim.new(0, 4)
                    UICorner_17.Parent = OptionButton
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selected = option
                        DropdownButton.Text = option
                        
                        expanded = false
                        DropdownList.Visible = false
                        Tween(DropdownFrame, {Size = UDim2.new(0.95, 0, 0, 38)})
                        
                        if callback then
                            pcall(callback, option)
                        end
                    end)
                end
            end
            
            return DropdownTable
        end
        
        -- FONCTION: Créer une checkbox
        function TabTable:CreateCheckbox(text, default, callback)
            local CheckboxFrame = Instance.new("Frame")
            local UICorner_18 = Instance.new("UICorner")
            local CheckboxLabel = Instance.new("TextLabel")
            local CheckboxButton = Instance.new("TextButton")
            local UICorner_19 = Instance.new("UICorner")
            local CheckIcon = Instance.new("TextLabel")
            
            local checked = default or false
            
            CheckboxFrame.Name = "Checkbox"
            CheckboxFrame.Parent = Content
            CheckboxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            CheckboxFrame.BorderSizePixel = 0
            CheckboxFrame.Size = UDim2.new(0.95, 0, 0, 38)
            
            UICorner_18.CornerRadius = UDim.new(0, 6)
            UICorner_18.Parent = CheckboxFrame
            
            CheckboxLabel.Name = "Label"
            CheckboxLabel.Parent = CheckboxFrame
            CheckboxLabel.BackgroundTransparency = 1
            CheckboxLabel.Position = UDim2.new(0, 10, 0, 0)
            CheckboxLabel.Size = UDim2.new(0.8, 0, 1, 0)
            CheckboxLabel.Font = Enum.Font.SourceSans
            CheckboxLabel.Text = text
            CheckboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            CheckboxLabel.TextSize = 16
            CheckboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            CheckboxButton.Name = "CheckboxButton"
            CheckboxButton.Parent = CheckboxFrame
            CheckboxButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            CheckboxButton.BorderSizePixel = 0
            CheckboxButton.Position = UDim2.new(0.88, 0, 0.2, 0)
            CheckboxButton.Size = UDim2.new(0, 24, 0.6, 0)
            CheckboxButton.Text = ""
            
            UICorner_19.CornerRadius = UDim.new(0, 4)
            UICorner_19.Parent = CheckboxButton
            
            CheckIcon.Name = "Icon"
            CheckIcon.Parent = CheckboxButton
            CheckIcon.BackgroundTransparency = 1
            CheckIcon.Size = UDim2.new(1, 0, 1, 0)
            CheckIcon.Font = Enum.Font.SourceSansBold
            CheckIcon.Text = "✓"
            CheckIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
            CheckIcon.TextSize = 18
            CheckIcon.Visible = checked
            
            if checked then
                CheckboxButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            end
            
            CheckboxButton.MouseButton1Click:Connect(function()
                checked = not checked
                CheckIcon.Visible = checked
                
                if checked then
                    Tween(CheckboxButton, {BackgroundColor3 = Color3.fromRGB(0, 170, 0)})
                else
                    Tween(CheckboxButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                end
                
                if callback then
                    pcall(callback, checked)
                end
            end)
            
            local CheckboxTable = {}
            
            function CheckboxTable:SetValue(value)
                checked = value
                CheckIcon.Visible = checked
                
                if checked then
                    CheckboxButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                else
                    CheckboxButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                end
            end
            
            return CheckboxTable
        end
        
        return TabTable
    end
    
    return WindowTable
end

return Library
