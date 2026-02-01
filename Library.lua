--[[ 
    Eclipse Hub
    Interface : Trix#2794
    Script : Toi
--]]

local library = (function()
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    local Colors = {
        White = Color3.fromRGB(255, 255, 255),
        Gray = Color3.fromRGB(40,40,40),
        Cyan = Color3.fromRGB(0, 255, 255),
        Dark = Color3.fromRGB(30,30,30),
        Red = Color3.fromRGB(255, 0, 0),
    }

    local Font = Enum.Font.GothamBold

    local function CreateInstance(class,parent,props)
        local inst = Instance.new(class,parent)
        if props then
            for i,v in pairs(props) do inst[i]=v end
        end
        return inst
    end

    local library = {}

    function library:CreateWindow(title)
        title = title or "Eclipse Hub"
        local window = {}

        -- ScreenGui
        local screen = CreateInstance("ScreenGui", game.CoreGui, {Name="EclipseHub"})
        
        -- Main Frame
        local mainFrame = CreateInstance("Frame", screen, {
            Size=UDim2.new(0,600,0,400),
            Position=UDim2.new(0.3,0,0.2,0),
            BackgroundColor3 = Colors.Dark,
        })
        CreateInstance("UICorner", mainFrame,{CornerRadius=UDim.new(0,8)})

        -- Title
        local titleLabel = CreateInstance("TextLabel", mainFrame, {
            Text = title,
            TextColor3 = Colors.White,
            Font = Font,
            TextSize = 20,
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,0,40),
        })

        -- Minimize & Close Buttons
        local minimizeBtn = CreateInstance("TextButton", mainFrame, {
            Text="-",
            Size=UDim2.new(0,30,0,30),
            Position=UDim2.new(1,-60,0,5),
            BackgroundColor3 = Colors.Gray,
            TextColor3 = Colors.White,
            Font=Font,
            TextSize=18,
            AutoButtonColor=false
        })
        local closeBtn = CreateInstance("TextButton", mainFrame, {
            Text="X",
            Size=UDim2.new(0,30,0,30),
            Position=UDim2.new(1,-30,0,5),
            BackgroundColor3 = Colors.Red,
            TextColor3 = Colors.White,
            Font=Font,
            TextSize=18,
            AutoButtonColor=false
        })

        CreateInstance("UICorner", minimizeBtn,{CornerRadius=UDim.new(0,4)})
        CreateInstance("UICorner", closeBtn,{CornerRadius=UDim.new(0,4)})

        local isVisible = true

        local function toggleVisibility()
            isVisible = not isVisible
            mainFrame.Visible = isVisible
        end

        minimizeBtn.MouseButton1Click:Connect(function()
            toggleVisibility()
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Eclipse Hub",
                Text = "Press LeftAlt to toggle GUI",
                Duration = 3
            })
        end)

        closeBtn.MouseButton1Click:Connect(function()
            screen:Destroy()
        end)

        UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == Enum.KeyCode.LeftAlt then
                toggleVisibility()
            end
        end)

        -- Tabs frame
        local tabFrame = CreateInstance("Frame", mainFrame, {
            Size = UDim2.new(0,150,1,0),
            BackgroundColor3 = Colors.Gray,
        })
        CreateInstance("UICorner", tabFrame,{CornerRadius=UDim.new(0,5)})

        local tabLayout = CreateInstance("UIListLayout", tabFrame,{SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,5)})

        -- Content frame
        local contentFrame = CreateInstance("Frame", mainFrame, {
            Position=UDim2.new(0,150,0,0),
            Size=UDim2.new(1,-150,1,0),
            BackgroundColor3 = Colors.Dark,
        })
        CreateInstance("UIListLayout", contentFrame,{SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,5)})

        local tabs = {}
        local currentTab = nil

        local function switchTab(tabName)
            for name, frame in pairs(tabs) do
                frame.Visible = (name==tabName)
            end
        end

        function window:CreateTab(name)
            -- Tab Button
            local btn = CreateInstance("TextButton", tabFrame, {
                Text=name,
                Size=UDim2.new(1,0,0,40),
                TextColor3 = Colors.White,
                Font = Font,
                TextSize=16,
                BackgroundColor3=Colors.Gray,
                AutoButtonColor=false
            })
            CreateInstance("UICorner", btn,{CornerRadius=UDim.new(0,5)})

            -- Content Frame
            local tabContent = CreateInstance("Frame", contentFrame, {
                Size=UDim2.new(1,0,1,0),
                BackgroundTransparency=1,
                Visible=false
            })
            tabs[name] = tabContent

            btn.MouseButton1Click:Connect(function() 
                switchTab(name)
            end)

            if not currentTab then
                currentTab = name
                switchTab(name)
            end

            local tab = {}

            function tab:CreateButton(text,callback)
                local b = CreateInstance("TextButton", tabContent, {
                    Text=text,
                    Size=UDim2.new(1,0,0,35),
                    BackgroundColor3 = Colors.Gray,
                    Font=Font,
                    TextColor3=Colors.White,
                    TextSize=14,
                    AutoButtonColor=false
                })
                CreateInstance("UICorner", b,{CornerRadius=UDim.new(0,4)})
                if callback then
                    b.MouseButton1Click:Connect(callback)
                end
                return b
            end

            function tab:CreateToggle(text,default,callback)
                default = default or false
                local togg = default

                local frame = CreateInstance("Frame", tabContent, {
                    Size=UDim2.new(1,0,0,35),
                    BackgroundColor3 = Colors.Gray,
                })
                CreateInstance("UICorner", frame,{CornerRadius=UDim.new(0,4)})

                local label = CreateInstance("TextLabel", frame,{
                    Text=" "..text,
                    Size=UDim2.new(0.7,0,1,0),
                    TextColor3=Colors.White,
                    BackgroundTransparency=1,
                    Font=Font,
                    TextSize=14,
                    TextXAlignment=Enum.TextXAlignment.Left
                })

                local button = CreateInstance("TextButton", frame,{
                    Text= togg and "ON" or "OFF",
                    Size=UDim2.new(0.3,0,1,0),
                    BackgroundColor3 = Colors.Cyan,
                    TextColor3 = Colors.White,
                    Font=Font,
                    TextSize=14,
                    AutoButtonColor=false
                })

                button.MouseButton1Click:Connect(function()
                    togg = not togg
                    button.Text = togg and "ON" or "OFF"
                    if callback then callback(togg) end
                end)

                return frame
            end

            function tab:CreateLabel(text)
                return CreateInstance("TextLabel", tabContent,{
                    Text=text,
                    Size=UDim2.new(1,0,0,35),
                    BackgroundTransparency=1,
                    TextColor3=Colors.White,
                    Font=Font,
                    TextSize=14,
                    TextXAlignment=Enum.TextXAlignment.Left
                })
            end

            function tab:CreateSlider(text,min,max,default,callback)
                local value = default or min

                local frame = CreateInstance("Frame", tabContent,{
                    Size=UDim2.new(1,0,0,35),
                    BackgroundColor3=Colors.Gray,
                })
                CreateInstance("UICorner", frame,{CornerRadius=UDim.new(0,4)})

                local label = CreateInstance("TextLabel", frame,{
                    Text=text.." : "..tostring(value),
                    Size=UDim2.new(0.8,0,1,0),
                    TextColor3=Colors.White,
                    BackgroundTransparency=1,
                    Font=Font,
                    TextSize=14,
                    TextXAlignment=Enum.TextXAlignment.Left
                })

                local slider = CreateInstance("Frame", frame,{
                    Size=UDim2.new(0.8,0,0,4),
                    Position=UDim2.new(0,10,0.5,-2),
                    BackgroundColor3=Colors.Cyan
                })

                local dragging = false
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mouse = UserInputService:GetMouseLocation()
                        local relative = math.clamp((mouse.X - frame.AbsolutePosition.X)/frame.AbsoluteSize.X,0,1)
                        value = math.floor(min + (max-min)*relative)
                        label.Text = text.." : "..value
                        if callback then callback(value) end
                    end
                end)

                return frame
            end

            return tab
        end

        return window
    end

    return library
end)()

return library
