local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- =====================
-- CREATE WINDOW
-- =====================
function Library:CreateWindow(titleText)
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "MainUI"
    MainUI.Parent = PlayerGui
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.Parent = MainUI
    Window.Size = UDim2.new(0, 550, 0, 307)
    Window.Position = UDim2.new(0.3088, 0, 0.3174, 0)
    Window.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Window.BorderSizePixel = 0

    local Title = Instance.new("TextLabel")
    Title.Parent = Window
    Title.Size = UDim2.new(0, 146, 0, 41)
    Title.Text = titleText or "Window"
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(0,0,0)
    Title.Font = Enum.Font.SourceSans
    Title.TextSize = 14

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Window
    TabContainer.Position = UDim2.new(0, 0, 0.1335, 0)
    TabContainer.Size = UDim2.new(1, 0, 0.8665, 0)
    TabContainer.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = TabContainer
    Layout.Padding = UDim.new(0, 6)

    local WindowObject = {}

    -- =====================
    -- ADD BUTTON
    -- =====================
    function WindowObject:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = TabContainer
        Button.Size = UDim2.new(0, 200, 0, 50)
        Button.Text = text
        Button.BackgroundColor3 = Color3.fromRGB(255,255,255)
        Button.TextColor3 = Color3.fromRGB(0,0,0)
        Button.BorderSizePixel = 0
        Button.Font = Enum.Font.SourceSans
        Button.TextSize = 14

        Button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)
    end

    return WindowObject
end

return setmetatable({}, Library)
