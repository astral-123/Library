By Astrall
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ═══════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui           = game:GetService("CoreGui")
local Workspace         = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local camera      = Workspace.CurrentCamera
local mouse       = localPlayer:GetMouse()

-- ═══════════════════════════════════════════
-- VARIABLES
-- ═══════════════════════════════════════════
local toggles = {
    aimAssist          = false,
    aimAssistWallCheck = false,
    aimAssistDeadCheck = false,
    triggerBot         = false,
    silentAim          = false,
    espBox             = false,
    espLine            = false,
    espName            = false,
    espDistance        = false,
    espHealth          = false,
    espSkeleton        = false,
    teamCheckAim       = false,
    teamCheckESP       = false,
}

local settings = {
    aimAssistFOV        = 100,
    aimAssistSmoothing  = 5,
    aimPart             = "Head",
    aimAssistPrediction = 0,
    triggerBotDelay     = 0.1,
}

local espObjects         = {}
local triggerBotCooldown = false

-- ═══════════════════════════════════════════
-- SKELETON
-- ═══════════════════════════════════════════
local skeletonConnections = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}
}
local r6SkeletonConnections = {
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
    {"Torso","Left Leg"},{"Torso","Right Leg"}
}
local randomParts = {
    "Head","UpperTorso","LowerTorso",
    "LeftUpperArm","RightUpperArm","LeftUpperLeg","RightUpperLeg"
}

-- ═══════════════════════════════════════════
-- FOV CIRCLE
-- ═══════════════════════════════════════════
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness    = 2
FOVCircle.NumSides     = 50
FOVCircle.Radius       = settings.aimAssistFOV
FOVCircle.Filled       = false
FOVCircle.Color        = Color3.fromRGB(180, 80, 255)
FOVCircle.Visible      = false
FOVCircle.Transparency = 1

-- ═══════════════════════════════════════════
-- HELPERS
-- ═══════════════════════════════════════════
local function isVisible(targetPart)
    if not targetPart then return false end
    local origin    = camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local ray       = Ray.new(origin, direction)
    local hit       = Workspace:FindPartOnRayWithIgnoreList(ray, {localPlayer.Character, camera})
    if hit then return hit:IsDescendantOf(targetPart.Parent) end
    return false
end

local function isSameTeam(player)
    if not localPlayer.Team or not player.Team then return false end
    return localPlayer.Team == player.Team
end

local function isDead(player)
    if not player.Character then return true end
    local hum = player.Character:FindFirstChild("Humanoid")
    if not hum then return true end
    return hum.Health <= 0
end

local function getRandomPart(character)
    local available = {}
    for _, partName in pairs(randomParts) do
        local part = character:FindFirstChild(partName)
        if part then table.insert(available, part) end
    end
    if #available == 0 then return nil end
    return available[math.random(1, #available)]
end

local function getTargetPart(character)
    if settings.aimPart == "Random" then return getRandomPart(character) end
    return character:FindFirstChild(settings.aimPart)
end

local function isPlayerInFOV(player)
    if not player.Character then return false end
    local targetPart = player.Character:FindFirstChild("Head")
    if not targetPart then return false end
    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then return false end
    local mousePos = UserInputService:GetMouseLocation()
    return (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude <= settings.aimAssistFOV
end

-- ═══════════════════════════════════════════
-- ESP
-- ═══════════════════════════════════════════
local function createESP(player)
    if espObjects[player] then return end
    local esp = {
        box         = Drawing.new("Square"),
        line        = Drawing.new("Line"),
        nameTag     = Drawing.new("Text"),
        distanceTag = Drawing.new("Text"),
        healthBar   = Drawing.new("Line"),
        skeleton    = {}
    }
    esp.box.Thickness = 2; esp.box.Filled = false
    esp.box.Color = Color3.fromRGB(180,80,255); esp.box.Visible = false; esp.box.Transparency = 1
    esp.line.Thickness = 2; esp.line.Color = Color3.fromRGB(180,80,255)
    esp.line.Visible = false; esp.line.Transparency = 1
    esp.nameTag.Size = 15; esp.nameTag.Center = true; esp.nameTag.Outline = true
    esp.nameTag.Color = Color3.fromRGB(255,255,255); esp.nameTag.Visible = false; esp.nameTag.Transparency = 1
    esp.distanceTag.Size = 13; esp.distanceTag.Center = true; esp.distanceTag.Outline = true
    esp.distanceTag.Color = Color3.fromRGB(200,150,255); esp.distanceTag.Visible = false; esp.distanceTag.Transparency = 1
    esp.healthBar.Thickness = 3; esp.healthBar.Color = Color3.fromRGB(0,255,0)
    esp.healthBar.Visible = false; esp.healthBar.Transparency = 1
    for i = 1, 14 do
        esp.skeleton[i] = Drawing.new("Line")
        esp.skeleton[i].Thickness = 1.5
        esp.skeleton[i].Color = Color3.fromRGB(180,80,255)
        esp.skeleton[i].Visible = false
        esp.skeleton[i].Transparency = 1
    end
    espObjects[player] = esp
end

local function removeESP(player)
    if not espObjects[player] then return end
    local esp = espObjects[player]
    esp.box:Remove(); esp.line:Remove()
    esp.nameTag:Remove(); esp.distanceTag:Remove(); esp.healthBar:Remove()
    for _, line in pairs(esp.skeleton) do line:Remove() end
    espObjects[player] = nil
end

local function hideESP(esp)
    esp.box.Visible = false; esp.line.Visible = false
    esp.nameTag.Visible = false; esp.distanceTag.Visible = false; esp.healthBar.Visible = false
    for _, line in pairs(esp.skeleton) do line.Visible = false end
end

local function updateESP()
    for player, esp in pairs(espObjects) do
        if not player or not player.Parent then removeESP(player); continue end
        if toggles.teamCheckESP and isSameTeam(player) then hideESP(esp); continue end
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then hideESP(esp); continue end
        local hum      = char.Humanoid
        local rootPart = char.HumanoidRootPart
        if hum.Health <= 0 then hideESP(esp); continue end
        local vector, onScreen = camera:WorldToViewportPoint(rootPart.Position)
        if not onScreen then hideESP(esp); continue end

        local distance  = (camera.CFrame.Position - rootPart.Position).Magnitude
        local headPos   = camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0,0.5,0))
        local legPos    = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0,3,0))
        local boxHeight = math.abs(headPos.Y - legPos.Y)
        local boxWidth  = boxHeight / 2

        if toggles.espBox then
            esp.box.Size     = Vector2.new(boxWidth, boxHeight)
            esp.box.Position = Vector2.new(vector.X - boxWidth/2, vector.Y - boxHeight/2)
            esp.box.Visible  = true
        else esp.box.Visible = false end

        if toggles.espLine then
            esp.line.From    = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
            esp.line.To      = Vector2.new(vector.X, vector.Y)
            esp.line.Visible = true
        else esp.line.Visible = false end

        if toggles.espName then
            esp.nameTag.Text     = player.Name
            esp.nameTag.Position = Vector2.new(vector.X, headPos.Y - 15)
            esp.nameTag.Visible  = true
        else esp.nameTag.Visible = false end

        if toggles.espDistance then
            esp.distanceTag.Text     = math.floor(distance) .. "m"
            esp.distanceTag.Position = Vector2.new(vector.X, legPos.Y + 5)
            esp.distanceTag.Visible  = true
        else esp.distanceTag.Visible = false end

        if toggles.espHealth then
            local hp = hum.Health / hum.MaxHealth
            esp.healthBar.From    = Vector2.new(vector.X - boxWidth/2 - 6, headPos.Y)
            esp.healthBar.To      = Vector2.new(vector.X - boxWidth/2 - 6, headPos.Y + boxHeight * hp)
            esp.healthBar.Color   = Color3.fromRGB(255*(1-hp), 255*hp, 0)
            esp.healthBar.Visible = true
        else esp.healthBar.Visible = false end

        if toggles.espSkeleton then
            local conns = char:FindFirstChild("UpperTorso") and skeletonConnections or r6SkeletonConnections
            for i, c in ipairs(conns) do
                local p1 = char:FindFirstChild(c[1])
                local p2 = char:FindFirstChild(c[2])
                if p1 and p2 and esp.skeleton[i] then
                    local s1, v1 = camera:WorldToViewportPoint(p1.Position)
                    local s2, v2 = camera:WorldToViewportPoint(p2.Position)
                    if v1 and v2 then
                        esp.skeleton[i].From    = Vector2.new(s1.X, s1.Y)
                        esp.skeleton[i].To      = Vector2.new(s2.X, s2.Y)
                        esp.skeleton[i].Visible = true
                    else esp.skeleton[i].Visible = false end
                elseif esp.skeleton[i] then esp.skeleton[i].Visible = false end
            end
        else for _, line in pairs(esp.skeleton) do line.Visible = false end end
    end
end

-- ═══════════════════════════════════════════
-- AIMBOT
-- ═══════════════════════════════════════════
local function getClosestPlayerToCursor()
    local closestPlayer, shortestDistance = nil, settings.aimAssistFOV
    for _, player in pairs(Players:GetPlayers()) do
        if player == localPlayer then continue end
        if toggles.teamCheckAim and isSameTeam(player) then continue end
        if toggles.aimAssistDeadCheck and isDead(player) then continue end
        if not player.Character then continue end
        local tp  = getTargetPart(player.Character)
        local hum = player.Character:FindFirstChild("Humanoid")
        if not tp or not hum or hum.Health <= 0 then continue end
        if toggles.aimAssistWallCheck and not isVisible(tp) then continue end
        local screenPos, onScreen = camera:WorldToViewportPoint(tp.Position)
        if not onScreen then continue end
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
        if dist < shortestDistance then closestPlayer = player; shortestDistance = dist end
    end
    return closestPlayer
end

local function aimAtWithMouse(player)
    if not player or player == localPlayer or not player.Character then return end
    if toggles.aimAssistDeadCheck and isDead(player) then return end
    if toggles.teamCheckAim and isSameTeam(player) then return end
    local tp = getTargetPart(player.Character)
    if not tp then return end
    local targetPos = tp.Position
    if settings.aimAssistPrediction > 0 and player.Character:FindFirstChild("HumanoidRootPart") then
        local vel = player.Character.HumanoidRootPart.AssemblyLinearVelocity
        targetPos = targetPos + (vel * (settings.aimAssistPrediction / 10))
    end
    local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
    if not onScreen then return end
    local mp = UserInputService:GetMouseLocation()
    if mousemoverel then
        mousemoverel(
            (screenPos.X - mp.X) / settings.aimAssistSmoothing,
            (screenPos.Y - mp.Y) / settings.aimAssistSmoothing
        )
    end
end

-- ═══════════════════════════════════════════
-- TRIGGERBOT
-- ═══════════════════════════════════════════
local function runTriggerBot()
    if triggerBotCooldown then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player == localPlayer then continue end
        if toggles.teamCheckAim and isSameTeam(player) then continue end
        if toggles.aimAssistDeadCheck and isDead(player) then continue end
        if isPlayerInFOV(player) then
            triggerBotCooldown = true
            if mouse1press then
                mouse1press()
                task.wait(settings.triggerBotDelay)
                mouse1release()
            end
            task.wait(settings.triggerBotDelay)
            triggerBotCooldown = false
            break
        end
    end
end

-- ═══════════════════════════════════════════
-- SILENT AIM
-- ═══════════════════════════════════════════
task.spawn(function()
    local ok, err = pcall(function()
        local Modules = ReplicatedStorage:WaitForChild("Modules", 10)
        local utility = require(Modules:WaitForChild("Utility", 10))
        if not utility or not utility.Raycast then return end
        local oldRaycast = utility.Raycast
        utility.Raycast = function(...)
            local arguments = {...}
            if toggles.silentAim and #arguments > 0 and arguments[4] == 999 then
                local closest, closestDist = nil, math.huge
                for _, player in pairs(Players:GetPlayers()) do
                    if player == localPlayer then continue end
                    if toggles.teamCheckAim and isSameTeam(player) then continue end
                    if not player.Character then continue end
                    local head = player.Character:FindFirstChild("Head")
                    if not head then continue end
                    local pos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if not onScreen then continue end
                    local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                    local dist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < closestDist then closest = player; closestDist = dist end
                end
                if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                    arguments[3] = closest.Character.Head.Position
                end
            end
            return oldRaycast(unpack(arguments))
        end
        print("[SilentAim] OK!")
    end)
    if not ok then warn("[SilentAim] " .. tostring(err)) end
end)

-- ═══════════════════════════════════════════
-- RAYFIELD WINDOW
-- ═══════════════════════════════════════════
local Window = Rayfield:CreateWindow({
    Name            = "Astral Hub - Rivals",
    LoadingTitle    = "Astral Hub",
    LoadingSubtitle = "by Astral",
    Theme           = "Amethyst",
    ConfigurationSaving = {
        Enabled    = true,
        FolderName = "AstralHub",
        FileName   = "rivals_config"
    },
    KeySystem = false,
})

Rayfield:Notify({
    Title    = "Astral Hub",
    Content  = "Chargé avec succès!",
    Duration = 3,
    Image    = "check",
})

-- ═══════════════════════════════════════════
-- UI CUSTOMIZATION (image fond + resize)
-- ═══════════════════════════════════════════
task.spawn(function()
    task.wait(3)
    pcall(function()
        local gui = (gethui and gethui():FindFirstChild("Rayfield"))
            or CoreGui:FindFirstChild("Rayfield")
            or (CoreGui:FindFirstChild("RobloxGui") and CoreGui.RobloxGui:FindFirstChild("Rayfield"))
        if not gui then return end

        local Main = gui:FindFirstChild("Main")
        if not Main then return end

        -- IMAGE DE FOND ASTRAL
        if Main:FindFirstChild("AstralBG") then Main.AstralBG:Destroy() end

        local bg = Instance.new("ImageLabel")
        bg.Name                   = "AstralBG"
        bg.Size                   = UDim2.new(1, 0, 1, 0)
        bg.Position               = UDim2.new(0, 0, 0, 0)
        bg.BackgroundTransparency = 1
        bg.Image                  = "rbxassetid://74436025564204"
        bg.ImageTransparency      = 0.2
        bg.ScaleType              = Enum.ScaleType.Crop
        bg.ZIndex                 = 0
        bg.Parent                 = Main

        Main.BackgroundTransparency = 0.15

        -- BOUTON RESIZE (coin bas-droit)
        if Main:FindFirstChild("AstralResize") then Main.AstralResize:Destroy() end

        local resizeBtn = Instance.new("TextButton")
        resizeBtn.Name                   = "AstralResize"
        resizeBtn.Size                   = UDim2.new(0, 24, 0, 24)
        resizeBtn.Position               = UDim2.new(1, -28, 1, -28)
        resizeBtn.AnchorPoint            = Vector2.new(0, 0)
        resizeBtn.BackgroundColor3       = Color3.fromRGB(100, 40, 180)
        resizeBtn.BackgroundTransparency = 0.2
        resizeBtn.Text                   = "⤡"
        resizeBtn.TextColor3             = Color3.fromRGB(255, 255, 255)
        resizeBtn.TextSize               = 14
        resizeBtn.Font                   = Enum.Font.GothamBold
        resizeBtn.ZIndex                 = 999
        resizeBtn.AutoButtonColor        = false
        resizeBtn.Parent                 = Main

        Instance.new("UICorner", resizeBtn).CornerRadius = UDim.new(0, 5)

        local rStroke = Instance.new("UIStroke", resizeBtn)
        rStroke.Color        = Color3.fromRGB(160, 70, 255)
        rStroke.Transparency = 0.2
        rStroke.Thickness    = 1.5

        resizeBtn.MouseEnter:Connect(function()
            TweenService:Create(resizeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
        end)
        resizeBtn.MouseLeave:Connect(function()
            TweenService:Create(resizeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
        end)

        local resizing   = false
        local resizeFrom = nil
        local sizeFrom   = nil

        resizeBtn.MouseButton1Down:Connect(function()
            resizing   = true
            resizeFrom = UserInputService:GetMouseLocation()
            sizeFrom   = Main.AbsoluteSize
        end)

        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)

        RunService.RenderStepped:Connect(function()
            if resizing then
                local cur   = UserInputService:GetMouseLocation()
                local delta = cur - resizeFrom
                local newW  = math.clamp(sizeFrom.X + delta.X, 420, 950)
                local newH  = math.clamp(sizeFrom.Y + delta.Y, 280, 700)
                Main.Size   = UDim2.new(0, newW, 0, newH)
            end
        end)
    end)
end)

-- ═══════════════════════════════════════════
-- TAB AIMBOT
-- ═══════════════════════════════════════════
local TabAim = Window:CreateTab("Aimbot", "crosshair")

TabAim:CreateSection("Aim Settings")

TabAim:CreateToggle({
    Name = "Aim Assist", CurrentValue = false, Flag = "AimAssist",
    Callback = function(v)
        toggles.aimAssist = v
        FOVCircle.Visible = v
    end
})

TabAim:CreateToggle({
    Name = "Wall Check", CurrentValue = false, Flag = "WallCheck",
    Callback = function(v) toggles.aimAssistWallCheck = v end
})

TabAim:CreateToggle({
    Name = "Dead Check", CurrentValue = false, Flag = "DeadCheck",
    Callback = function(v) toggles.aimAssistDeadCheck = v end
})

TabAim:CreateToggle({
    Name = "Triggerbot", CurrentValue = false, Flag = "Triggerbot",
    Callback = function(v) toggles.triggerBot = v end
})

TabAim:CreateToggle({
    Name = "Silent Aim", CurrentValue = false, Flag = "SilentAim",
    Callback = function(v) toggles.silentAim = v end
})

TabAim:CreateSection("Configuration")

TabAim:CreateSlider({
    Name = "FOV Size", Range = {50, 400}, Increment = 1,
    CurrentValue = 100, Flag = "FOVSize",
    Callback = function(v)
        settings.aimAssistFOV = v
        FOVCircle.Radius = v
    end
})

TabAim:CreateSlider({
    Name = "Smoothing", Range = {1, 30}, Increment = 1,
    CurrentValue = 5, Flag = "Smoothing",
    Callback = function(v) settings.aimAssistSmoothing = v end
})

TabAim:CreateSlider({
    Name = "Prediction", Range = {0, 20}, Increment = 1,
    CurrentValue = 0, Flag = "Prediction",
    Callback = function(v) settings.aimAssistPrediction = v end
})

TabAim:CreateSlider({
    Name = "Triggerbot Delay", Range = {1, 10}, Increment = 1,
    CurrentValue = 1, Flag = "TriggerDelay",
    Callback = function(v) settings.triggerBotDelay = v / 10 end
})

TabAim:CreateDropdown({
    Name = "Target Part",
    Options = {"Head","UpperTorso","LowerTorso","HumanoidRootPart","Random"},
    CurrentOption = {"Head"},
    MultipleOptions = false,
    Flag = "TargetPart",
    Callback = function(v) settings.aimPart = type(v) == "table" and v[1] or v end
})

-- ═══════════════════════════════════════════
-- TAB ESP
-- ═══════════════════════════════════════════
local TabESP = Window:CreateTab("Visual ESP", "eye")

TabESP:CreateSection("ESP Features")

TabESP:CreateToggle({
    Name = "ESP Box", CurrentValue = false, Flag = "ESPBox",
    Callback = function(v) toggles.espBox = v end
})

TabESP:CreateToggle({
    Name = "ESP Line", CurrentValue = false, Flag = "ESPLine",
    Callback = function(v) toggles.espLine = v end
})

TabESP:CreateToggle({
    Name = "ESP Name", CurrentValue = false, Flag = "ESPName",
    Callback = function(v) toggles.espName = v end
})

TabESP:CreateToggle({
    Name = "ESP Distance", CurrentValue = false, Flag = "ESPDistance",
    Callback = function(v) toggles.espDistance = v end
})

TabESP:CreateSection("Advanced ESP")

TabESP:CreateToggle({
    Name = "ESP Health Bar", CurrentValue = false, Flag = "ESPHealth",
    Callback = function(v) toggles.espHealth = v end
})

TabESP:CreateToggle({
    Name = "ESP Skeleton", CurrentValue = false, Flag = "ESPSkeleton",
    Callback = function(v) toggles.espSkeleton = v end
})

-- ═══════════════════════════════════════════
-- TAB MISC
-- ═══════════════════════════════════════════
local TabMisc = Window:CreateTab("Misc", "settings")

TabMisc:CreateSection("Team Settings")

TabMisc:CreateToggle({
    Name = "Team Check Aim", CurrentValue = false, Flag = "TeamCheckAim",
    Callback = function(v) toggles.teamCheckAim = v end
})

TabMisc:CreateToggle({
    Name = "Team Check ESP", CurrentValue = false, Flag = "TeamCheckESP",
    Callback = function(v) toggles.teamCheckESP = v end
})

-- ═══════════════════════════════════════════
-- EVENTS
-- ═══════════════════════════════════════════
Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    if player ~= localPlayer then createESP(player) end
end)

Players.PlayerRemoving:Connect(function(player) removeESP(player) end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        createESP(player)
        player.CharacterAdded:Connect(function()
            task.wait(0.5); removeESP(player); createESP(player)
        end)
    end
end

localPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    for player in pairs(espObjects) do
        removeESP(player)
        if player.Parent then createESP(player) end
    end
end)

-- ═══════════════════════════════════════════
-- MAIN LOOP
-- ═══════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    if toggles.aimAssist then
        local mp = UserInputService:GetMouseLocation()
        FOVCircle.Position = mp
        FOVCircle.Visible  = true
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = getClosestPlayerToCursor()
            if target then aimAtWithMouse(target) end
        end
    else
        FOVCircle.Visible = false
    end
    if toggles.triggerBot then runTriggerBot() end
    updateESP()
end)

Rayfield:LoadConfiguration()
