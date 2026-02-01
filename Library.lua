-- Eclipse Hub with System Key
local keyEnabled = true -- true = key required, false = no key
local systemKeyTitle = "System Key"
local defaultKey = "Hello" -- default key

local library = (function()
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    local Colors = {
        White = Color3.fromRGB(255,255,255),
        Black = Color3.fromRGB(20,20,20),
        Gray = Color3.fromRGB(60,60,60),
        Dark = Color3.fromRGB(30,30,30),
        Cyan = Color3.fromRGB(0,255,255)
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

    function library:CreateWindow(title, color)
        title = title or "Eclipse Hub"
        color = color or Colors.Black

        local window = {}
        local screen = CreateInstance("ScreenGui", game.CoreGui, {Name="EclipseHub"})
        
        -- Main Frame
        local mainFrame = CreateInstance("Frame", screen, {
            Size=UDim2.new(0,600,0,400),
            Position=UDim2.new(0.3,0,0.2,0),
            BackgroundColor3 = color,
            BorderColor3 = Colors.White,
            BorderSizePixel = 2
        })
        CreateInstance("UICorner", mainFrame,{CornerRadius=UDim.new(0,8)})

        -- Title
        CreateInstance("TextLabel", mainFrame, {
            Text = title,
            TextColor3 = Colors.White,
            Font = Font,
            TextSize = 20,
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,0,40),
        })

        -- Tabs frame
        local tabFrame = CreateInstance("Frame", mainFrame, {
            Size = UDim2.new(0,150,1,0),
            BackgroundColor3 = Colors.Gray,
            BorderColor3 = Colors.White,
            BorderSizePixel = 1
        })
        CreateInstance("UICorner", tabFrame,{CornerRadius=UDim.new(0,5)})

        local tabLayout = CreateInstance("UIListLayout", tabFrame,{SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,5)})

        -- Content frame
        local contentFrame = CreateInstance("Frame", mainFrame, {
            Position=UDim2.new(0,150,0,0),
            Size=UDim2.new(1,-150,1,0),
            BackgroundColor3 = Colors.Dark,
            BorderColor3 = Colors.White,
            BorderSizePixel = 1
        })

        local tabs = {}
        local currentTab = nil

        local function switchTab(tabName)
            for name, frame in pairs(tabs) do
                frame.Visible = (name==tabName)
            end
        end

        function window:CreateTab(name)
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
                if callback then b.MouseButton1Click:Connect(callback) end
                return b
            end

            function tab:CreateToggle(text,default,callback)
                default = default or false
                local togg = default

                local frame = CreateInstance("Frame", tabContent, {
                    Size=UDim2.new(1,0,0,35),
                    BackgroundColor3 = Colors.Gray,
                    BorderColor3 = Colors.White,
                    BorderSizePixel=1
                })
                CreateInstance("UICorner", frame,{CornerRadius=UDim.new(0,4)})

                local label = CreateInstance("TextLabel", frame,{
                    Text=" "..text,
                    Size=UDim2.new(0.8,0,1,0),
                    TextColor3=Colors.White,
                    BackgroundTransparency=1,
                    Font=Font,
                    TextSize=14,
                    TextXAlignment=Enum.TextXAlignment.Left
                })

                local button = CreateInstance("TextButton", frame,{
                    Text= togg and "ON" or "OFF",
                    Size=UDim2.new(0.2,0,1,0),
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

            function tab:CreateSlider(text,min,max,default,callback)
                local default = default or min
                local sliderFrame = CreateInstance("Frame", tabContent,{
                    Size=UDim2.new(1,0,0,35),
                    BackgroundColor3=Colors.Gray,
                    BorderColor3=Colors.White,
                    BorderSizePixel=1
                })
                CreateInstance("UICorner", sliderFrame,{CornerRadius=UDim.new(0,4)})

                local label = CreateInstance("TextLabel", sliderFrame,{
                    Text = text.." : "..tostring(default),
                    Size=UDim2.new(1,0,1,0),
                    BackgroundTransparency=1,
                    TextColor3=Colors.White,
                    Font=Font,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    TextSize=14
                })

                local bar = CreateInstance("Frame", sliderFrame,{
                    Size=UDim2.new(0,(default-min)/(max-min)*sliderFrame.AbsoluteSize.X,0,5),
                    Position=UDim2.new(0,0,0.8,0),
                    BackgroundColor3=Colors.Cyan
                })
                CreateInstance("UICorner", bar,{CornerRadius=UDim.new(0,2)})

                sliderFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mouse = game.Players.LocalPlayer:GetMouse()
                        local function updateSlider()
                            local x = math.clamp(mouse.X - sliderFrame.AbsolutePosition.X,0,sliderFrame.AbsoluteSize.X)
                            bar.Size = UDim2.new(0,x,0,5)
                            local val = math.floor(min + (x/sliderFrame.AbsoluteSize.X)*(max-min))
                            label.Text = text.." : "..val
                            if callback then callback(val) end
                        end
                        updateSlider()
                        local conn
                        conn = mouse.Move:Connect(function()
                            updateSlider()
                        end)
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                conn:Disconnect()
                            end
                        end)
                    end
                end)

                return sliderFrame
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

            function tab:CreateSystemKey()
                local frame = CreateInstance("Frame", tabContent,{
                    Size=UDim2.new(1,0,0,100),
                    BackgroundColor3=Colors.Gray,
                    BorderColor3=Colors.White,
                    BorderSizePixel=1
                })
                CreateInstance("UICorner", frame,{CornerRadius=UDim.new(0,4)})

                CreateInstance("TextLabel", frame,{
                    Text=systemKeyTitle,
                    Size=UDim2.new(1,0,0,25),
                    BackgroundTransparency=1,
                    TextColor3=Colors.White,
                    Font=Font,
                    TextSize=16,
                    TextXAlignment=Enum.TextXAlignment.Left
                })

                local keyBox = CreateInstance("TextBox", frame,{
                    PlaceholderText = "Enter Key",
                    Size=UDim2.new(0.6,0,0,25),
                    Position=UDim2.new(0,0,0,30),
                    BackgroundColor3=Colors.Dark,
                    TextColor3=Colors.White,
                    Font=Font,
                    TextSize=14
                })

                local enterBtn = CreateInstance("TextButton", frame,{
                    Text="Enter",
                    Size=UDim2.new(0.18,0,0,25),
                    Position=UDim2.new(0.62,0,0,30),
                    BackgroundColor3=Colors.Cyan,
                    TextColor3=Colors.White,
                    Font=Font,
                    TextSize=14
                })

                local getBtn = CreateInstance("TextButton", frame,{
                    Text="Get Key",
                    Size=UDim2.new(0.18,0,0,25),
                    Position=UDim2.new(0.82,0,0,30),
                    BackgroundColor3=Colors.Cyan,
                    TextColor3=Colors.White,
                    Font=Font,
                    TextSize=14
                })

                enterBtn.MouseButton1Click:Connect(function()
                    defaultKey = keyBox.Text
                    print("New Key set: "..defaultKey)
                end)

                getBtn.MouseButton1Click:Connect(function()
                    keyBox.Text = defaultKey
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
