-- EclipseHub.lua
local EclipseHub = {}
EclipseHub.__index = EclipseHub

function EclipseHub.new()
    local self = setmetatable({}, EclipseHub)

    -- ScreenGui
    self.MainUI = Instance.new("ScreenGui")
    self.MainUI.Name = "MainUI"
    self.MainUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    self.MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Fenêtre
    self.Window = Instance.new("Frame")
    self.Window.Name = "Window"
    self.Window.Parent = self.MainUI
    self.Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.Window.BorderSizePixel = 0
    self.Window.Position = UDim2.new(0.3, 0, 0.28, 0)
    self.Window.Size = UDim2.new(0, 576, 0, 338)

    -- Titre
    local Title = Instance.new("TextLabel")
    Title.Parent = self.Window
    Title.Size = UDim2.new(0, 95, 0, 31)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Eclipse Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Title

    -- Frame principale
    self.FrameUi = Instance.new("Frame")
    self.FrameUi.Name = "FrameUi"
    self.FrameUi.Parent = self.Window
    self.FrameUi.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.FrameUi.BorderSizePixel = 0
    self.FrameUi.Position = UDim2.new(0, 0, 0.094, 0)
    self.FrameUi.Size = UDim2.new(0, 576, 0, 306)

    return self
end

-- Ajouter un onglet
function EclipseHub:AddTab(tabName)
    local Tab = Instance.new("Frame")
    Tab.Name = tabName
    Tab.Parent = self.FrameUi
    Tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Tab.BorderSizePixel = 0
    Tab.Size = UDim2.new(0, 130, 0, 306)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Tab
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Button = Instance.new("TextButton")
    Button.Parent = Tab
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.Font = Enum.Font.SourceSansBold
    Button.Text = tabName
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 18
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Button

    return Tab
end

-- Ajouter un bouton
function EclipseHub:AddButton(tab, buttonName, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = tab
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.Font = Enum.Font.SourceSansBold
    Button.Text = buttonName
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
end

return EclipseHub
