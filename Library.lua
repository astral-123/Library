local Library = {}
Library.__index = Library

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- CREATE WINDOW
function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "CustomUILib"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.fromScale(0.4, 0.5)
    Main.Position = UDim2.fromScale(0.3, 0.25)
    Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Main.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.fromScale(1, 0.1)
    Title.Text = title
    Title.TextColor3 = Color3.new(1,1,1)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18

    local TabsFrame = Instance.new("Frame", Main)
    TabsFrame.Position = UDim2.fromScale(0, 0.1)
    TabsFrame.Size = UDim2.fromScale(1, 0.9)
    TabsFrame.BackgroundTransparency = 1

    local Window = {}
    Window.TabsFrame = TabsFrame

    function Window:CreateTab(name)
        local Tab = Instance.new("Frame", TabsFrame)
        Tab.Size = UDim2.fromScale(1,1)
        Tab.Visible = true
        Tab.BackgroundTransparency = 1

        local UIList = Instance.new("UIListLayout", Tab)
        UIList.Padding = UDim.new(0,6)

        local TabFunctions = {}

        -- BUTTON
        function TabFunctions:AddButton(text, callback)
            local Btn = Instance.new("TextButton", Tab)
            Btn.Size = UDim2.fromScale(1, 0.1)
            Btn.Text = text
            Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14

            Btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        -- TOGGLE
        function TabFunctions:AddToggle(text, default, callback)
            local Toggle = Instance.new("TextButton", Tab)
            Toggle.Size = UDim2.fromScale(1, 0.1)
            Toggle.Text = text .. " : OFF"
            Toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
            Toggle.TextColor3 = Color3.new(1,1,1)

            local State = default or false
            Toggle.Text = text .. (State and " : ON" or " : OFF")

            Toggle.MouseButton1Click:Connect(function()
                State = not State
                Toggle.Text = text .. (State and " : ON" or " : OFF")
                pcall(callback, State)
            end)
        end

        -- LABEL
        function TabFunctions:AddLabel(text)
            local Label = Instance.new("TextLabel", Tab)
            Label.Size = UDim2.fromScale(1, 0.08)
            Label.Text = text
            Label.TextColor3 = Color3.new(1,1,1)
            Label.BackgroundTransparency = 1
            Label.TextSize = 14
        end

        return TabFunctions
    end

    return Window
end

return setmetatable({}, Library)
