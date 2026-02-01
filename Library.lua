-- EclipseHub.lua
-- Version GUI + fonctionnalités complètes

-- Instances de base
local MainUI = Instance.new("ScreenGui")
local Window = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local UICorner_2 = Instance.new("UICorner")
local FrameUi = Instance.new("Frame")
local UICorner_3 = Instance.new("UICorner")
local Tab = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")
local Tab1 = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local UIListLayout = Instance.new("UIListLayout")
local Content = Instance.new("Frame")
local UICorner_6 = Instance.new("UICorner")
local UIListLayout_2 = Instance.new("UIListLayout")

-- Properties GUI
MainUI.Name = "MainUI"
MainUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Window.Name = "Window"
Window.Parent = MainUI
Window.BackgroundColor3 = Color3.fromRGB(25,25,25)
Window.BorderSizePixel = 0
Window.Position = UDim2.new(0.308,0,0.28,0)
Window.Size = UDim2.new(0,576,0,338)

Title.Name = "Title"
Title.Parent = Window
Title.BackgroundColor3 = Color3.fromRGB(25,25,25)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(0,95,0,31)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Eclipse Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 18
UICorner.Parent = Title
UICorner_2.Parent = Window

FrameUi.Name = "FrameUi"
FrameUi.Parent = Window
FrameUi.BackgroundColor3 = Color3.fromRGB(30,30,30)
FrameUi.BorderSizePixel = 0
FrameUi.Position = UDim2.new(0,0,0.094,0)
FrameUi.Size = UDim2.new(0,576,0,306)
UICorner_3.Parent = FrameUi

Tab.Name = "Tab"
Tab.Parent = FrameUi
Tab.BackgroundColor3 = Color3.fromRGB(30,30,30)
Tab.BorderSizePixel = 0
Tab.Size = UDim2.new(0,130,0,306)
UICorner_4.Parent = Tab

Tab1.Name = "Tab1"
Tab1.Parent = Tab
Tab1.BackgroundColor3 = Color3.fromRGB(30,30,30)
Tab1.BorderSizePixel = 0
Tab1.Position = UDim2.new(0,0,0.055,0)
Tab1.Size = UDim2.new(0,130,0,50)
Tab1.Font = Enum.Font.SourceSansBold
Tab1.Text = "Tab1"
Tab1.TextColor3 = Color3.fromRGB(255,255,255)
Tab1.TextSize = 18
UICorner_5.Parent = Tab1

UIListLayout.Parent = Tab
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

Content.Name = "Content"
Content.Parent = FrameUi
Content.BackgroundColor3 = Color3.fromRGB(30,30,30)
Content.BorderSizePixel = 0
Content.Position = UDim2.new(0.225,0,0,0)
Content.Size = UDim2.new(0,446,0,306)
UICorner_6.Parent = Content

UIListLayout_2.Parent = Content
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

-- Fonctions utilitaires
local Elements = {}

function Elements:CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = Content
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0,446,0,38)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 16
    local uc = Instance.new("UICorner")
    uc.Parent = btn
    if callback then btn.MouseButton1Click:Connect(callback) end
    return btn
end

function Elements:CreateToggle(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,446,0,38)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.Parent = Content
    local uc = Instance.new("UICorner")
    uc.Parent = frame

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7,0,1,0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16

    local toggle = Instance.new("TextButton")
    toggle.Parent = frame
    toggle.Size = UDim2.new(0.3,0,1,0)
    toggle.Position = UDim2.new(0.7,0,0,0)
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255,255,255)
    toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
    local uc2 = Instance.new("UICorner")
    uc2.Parent = toggle

    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
end

function Elements:CreateSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,446,0,38)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.Parent = Content
    local uc = Instance.new("UICorner")
    uc.Parent = frame

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7,0,1,0)
    label.Text = name.." : "..default
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = frame
    sliderFrame.Size = UDim2.new(0.3,0,0.5,0)
    sliderFrame.Position = UDim2.new(0.7,0,0.25,0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    local uc2 = Instance.new("UICorner")
    uc2.Parent = sliderFrame

    local dragging = false
    local value = default

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X - sliderFrame.AbsolutePosition.X
            local perc = math.clamp(mouseX/sliderFrame.AbsoluteSize.X,0,1)
            value = min + (max-min)*perc
            label.Text = name.." : "..math.floor(value)
            if callback then callback(value) end
        end
    end)
end

function Elements:CreateLabel(name)
    local label = Instance.new("TextLabel")
    label.Parent = Content
    label.Size = UDim2.new(0,446,0,30)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
end

-- Exemple d'utilisation
Elements:CreateButton("Click Me", function() print("Button clicked") end)
Elements:CreateToggle("Toggle Me", true, function(state) print("Toggle:", state) end)
Elements:CreateSlider("Slider Me", 0,100,50, function(val) print("Slider:", val) end)
Elements:CreateLabel("Label Here")
