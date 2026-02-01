-- Simple UI Library (Executor Ready)

local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- =====================
-- CREATE WINDOW
-- =====================
function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Main.BorderSizePixel = 0

    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = title
    Title.TextColor3 = Color3.new(1,1,1)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18

    local Container = Instance.new("Frame")
    Container.Parent = Main
    Container.Position = UDim2.new(0, 0, 0, 40)
    Container.Size = UDim2.new(1, 0, 1, -40)
    Container.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 6)

    local Window = {}

    -- =====================
    -- CREATE TAB
    -- =====================
    function Window:CreateTab(name)
        local Tab = {}

        local Label = Instance.new("TextLabel")
        Label.Parent = Container
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(180,180,180)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.Size = UDim2.new(1,0,0,25)

        -- BUTTON
        function Tab:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = Container
            Button.Size = UDim2.new(1, -10, 0, 30)
            Button.Text = text
            Button.BackgroundColor3 = Color3.fromRGB(40,40,40)
            Button.TextColor3 = Color3.new(1,1,1)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14

            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        -- TOGGLE
        function Tab:AddToggle(text, default, callback)
            local State = default or false

            local Toggle = Instance.new("TextButton")
            Toggle.Parent = Container
            Toggle.Size = UDim2.new(1, -10, 0, 30)
            Toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
            Toggle.TextColor3 = Color3.new(1,1,1)
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = 14

            local function Refresh()
                Toggle.Text = text .. " : " .. (State and "ON" or "OFF")
            end

            Refresh()

            Toggle.MouseButton1Click:Connect(function()
                State = not State
                Refresh()
                pcall(callback, State)
            end)
        end

        return Tab
    end

    return Window
end

return setmetatable({}, Library)
