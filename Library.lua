-- By Astral

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local NebulaUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/astral-123/Library/refs/heads/main/Library.lua"))()

local localPlayer = Players.LocalPlayer

local toggles = {
    autoFarm = false,
    autoCoin = false,
    bossFarm = false,
    bossInstantKill = false,
    orbitAll = false,
    orbitAllLowLvl = false,
    respawnAtDeath = false,
    killAura = false,
    targetedOrbit = false
}

local settings = {
    selectedTarget = nil,
    bugReportText = ""
}

local Window = NebulaUi:CreateWindow({
    Name = "Astral Hub - Animal Simulator",
    ToggleKey = Enum.KeyCode.V,
    KeySystem = false,
    Key = "AstralHub2024",
    Resizable = false
})

local Settings = Window:CreateTab("Settings")

-- TAB FARMING
local TabFarming = Window:CreateTab("Farming")

local FarmingLeft = TabFarming:AddSection("Anti AFK", "left")

FarmingLeft:AddButton({
    Name = "Anti AFK",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        localPlayer.Idled:connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
        
        RunService.Stepped:connect(function()
            pcall(function()
                localPlayer.Character.Humanoid:ChangeState(11)
            end)
        end)
    end,
})

local FarmingRight = TabFarming:AddSection("Auto Farm", "right")

FarmingRight:AddToggle({
    Name = "Farming Grind 5k/Spawn",
    Default = false,
    Callback = function(value)
        toggles.autoFarm = value
        
        if toggles.autoFarm then
            task.spawn(function()
                while toggles.autoFarm do
                    pcall(function()
                        local char = localPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if not hrp then return end
                        
                        local level = localPlayer:FindFirstChild("leaderstats") and localPlayer.leaderstats:FindFirstChild("Level") and localPlayer.leaderstats.Level.Value
                        local dummy
                        
                        if level and level < 5000 then
                            dummy = workspace:FindFirstChild("MAP") and workspace.MAP:FindFirstChild("dummies") and workspace.MAP.dummies:FindFirstChild("Dummy")
                        else
                            dummy = workspace:FindFirstChild("MAP") and workspace.MAP:FindFirstChild("5k_dummies") and workspace.MAP["5k_dummies"]:FindFirstChild("Dummy2")
                        end
                        
                        if dummy and dummy:FindFirstChild("Humanoid") and dummy:FindFirstChild("HumanoidRootPart") and dummy.Humanoid.Health > 0 then
                            local targetCFrame = dummy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            hrp.CFrame = targetCFrame
                            hrp.Velocity = Vector3.new(0, 0, 0)
                            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            
                            ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(dummy.Humanoid, 2)
                            
                            if ReplicatedStorage:FindFirstChild("SkillsInRS") and ReplicatedStorage.SkillsInRS:FindFirstChild("RemoteEvent") then
                                ReplicatedStorage.SkillsInRS.RemoteEvent:FireServer(dummy.HumanoidRootPart.Position, "NewLightningball")
                            end
                        end
                    end)
                    wait()
                end
            end)
        end
    end,
})

FarmingRight:AddToggle({
    Name = "Auto Coin",
    Default = false,
    Callback = function(value)
        toggles.autoCoin = value
        
        if toggles.autoCoin then
            task.spawn(function()
                while toggles.autoCoin do
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Events"):WaitForChild("CoinEvent"):FireServer()
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end,
})

local BossLeft = TabFarming:AddSection("Boss Farm", "left")

BossLeft:AddToggle({
    Name = "Grind Farm Boss [No TP]",
    Default = false,
    Callback = function(value)
        toggles.bossFarm = value
        
        if toggles.bossFarm then
            task.spawn(function()
                local bossList = {"CRABBOSS", "CENTAUR", "BOSSBEAR", "BOSSDEER", "DragonGiraffe", "Griffin", "LavaGorilla"}
                while toggles.bossFarm do
                    pcall(function()
                        local npcFolder = workspace:FindFirstChild("NPC")
                        if npcFolder then
                            for _, bossName in ipairs(bossList) do
                                local boss = npcFolder:FindFirstChild(bossName)
                                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                                    ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(boss.Humanoid, 1)
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end,
})

BossLeft:AddToggle({
    Name = "Grind Farm Boss [TP]",
    Default = false,
    Callback = function(value)
        toggles.bossInstantKill = value
        
        if toggles.bossInstantKill then
            task.spawn(function()
                local bossList = {"CRABBOSS", "CENTAUR", "BOSSBEAR", "BOSSDEER", "DragonGiraffe", "Griffin", "LavaGorilla"}
                local currentPart = nil
                local partUpdateConnection = nil
                
                while toggles.bossInstantKill do
                    local allBossesDead = true
                    local shouldStop = false
                    
                    pcall(function()
                        local npcFolder = workspace:FindFirstChild("NPC")
                        if not npcFolder then return end
                        
                        for _, bossName in ipairs(bossList) do
                            if not toggles.bossInstantKill then 
                                shouldStop = true
                                return
                            end
                            
                            local boss = npcFolder:FindFirstChild(bossName)
                            
                            if boss and boss:FindFirstChild("Humanoid") and boss:FindFirstChild("HumanoidRootPart") and boss.Humanoid.Health > 0 then
                                allBossesDead = false
                                
                                local bossHRP = boss.HumanoidRootPart
                                local bossHumanoid = boss.Humanoid
                                local playerHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                                
                                if playerHRP then
                                    if currentPart then
                                        currentPart:Destroy()
                                        currentPart = nil
                                    end
                                    if partUpdateConnection then
                                        partUpdateConnection:Disconnect()
                                        partUpdateConnection = nil
                                    end
                                    
                                    local tpOffset = Vector3.new(0, 0, 10)
                                    if bossName == "CRABBOSS" then
                                        tpOffset = Vector3.new(0, 5, 15)
                                    end
                                    
                                    local part = Instance.new("Part")
                                    part.Size = Vector3.new(10, 1, 10)
                                    part.Anchored = true
                                    part.CanCollide = true
                                    part.Transparency = 0.3
                                    part.Material = Enum.Material.Neon
                                    part.BrickColor = BrickColor.new("Royal purple")
                                    part.Parent = workspace
                                    currentPart = part
                                    
                                    partUpdateConnection = RunService.Heartbeat:Connect(function()
                                        if currentPart and bossHRP and bossHRP.Parent then
                                            currentPart.Position = bossHRP.Position + tpOffset
                                        end
                                    end)
                                    
                                    for i = 1, 5 do
                                        if not toggles.bossInstantKill then 
                                            shouldStop = true
                                            return
                                        end
                                        
                                        if bossHRP and bossHRP.Parent and currentPart then
                                            playerHRP.CFrame = currentPart.CFrame + Vector3.new(0, 3, 0)
                                            playerHRP.Velocity = Vector3.new(0, 0, 0)
                                            playerHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                            
                                            ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(bossHumanoid, 2)
                                            wait(0.05)
                                        end
                                    end
                                    
                                    if not toggles.bossInstantKill then 
                                        shouldStop = true
                                        return
                                    end
                                    
                                    if bossHumanoid and bossHumanoid.Parent then
                                        bossHumanoid:ChangeState(15)
                                    end
                                    
                                    wait(0.3)
                                    
                                    if partUpdateConnection then
                                        partUpdateConnection:Disconnect()
                                        partUpdateConnection = nil
                                    end
                                    if currentPart then
                                        currentPart:Destroy()
                                        currentPart = nil
                                    end
                                    
                                    wait(0.3)
                                end
                            end
                        end
                    end)
                    
                    if shouldStop or not toggles.bossInstantKill then
                        if partUpdateConnection then
                            partUpdateConnection:Disconnect()
                            partUpdateConnection = nil
                        end
                        if currentPart then
                            currentPart:Destroy()
                            currentPart = nil
                        end
                        return
                    end
                    
                    if allBossesDead then
                        pcall(function()
                            local char = localPlayer.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            if not hrp then return end
                            
                            local level = localPlayer:FindFirstChild("leaderstats") and localPlayer.leaderstats:FindFirstChild("Level") and localPlayer.leaderstats.Level.Value
                            local dummy
                            
                            if level and level < 5000 then
                                dummy = workspace:FindFirstChild("MAP") and workspace.MAP:FindFirstChild("dummies") and workspace.MAP.dummies:FindFirstChild("Dummy")
                            else
                                dummy = workspace:FindFirstChild("MAP") and workspace.MAP:FindFirstChild("5k_dummies") and workspace.MAP["5k_dummies"]:FindFirstChild("Dummy2")
                            end
                            
                            if dummy and dummy:FindFirstChild("Humanoid") and dummy:FindFirstChild("HumanoidRootPart") and dummy.Humanoid.Health > 0 then
                                local targetCFrame = dummy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                                hrp.CFrame = targetCFrame
                                hrp.Velocity = Vector3.new(0, 0, 0)
                                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                
                                ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(dummy.Humanoid, 2)
                                
                                if ReplicatedStorage:FindFirstChild("SkillsInRS") and ReplicatedStorage.SkillsInRS:FindFirstChild("RemoteEvent") then
                                    ReplicatedStorage.SkillsInRS.RemoteEvent:FireServer(dummy.HumanoidRootPart.Position, "NewLightningball")
                                end
                            end
                        end)
                    end
                    
                    wait()
                end
                
                if partUpdateConnection then
                    partUpdateConnection:Disconnect()
                    partUpdateConnection = nil
                end
                if currentPart then
                    currentPart:Destroy()
                    currentPart = nil
                end
            end)
        end
    end,
})

-- TAB PVP
local TabPvP = Window:CreateTab("PvP")

local PvPLeft = TabPvP:AddSection("Orbit Combat", "left")

PvPLeft:AddToggle({
    Name = "Orbit All Players",
    Default = false,
    Callback = function(value)
        toggles.orbitAll = value
        
        if toggles.orbitAll then
            task.spawn(function()
                local angle = 0
                local currentTarget = nil
                
                while toggles.orbitAll do
                    pcall(function()
                        local validTargets = {}
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                                local fightingZone = workspace:FindFirstChild("FightingArea") and workspace.FightingArea:FindFirstChild("FightingZonePart")
                                local inZone = false
                                
                                if fightingZone then
                                    local hrpPos = p.Character.HumanoidRootPart.Position
                                    local zonePos = fightingZone.Position
                                    local zoneSize = fightingZone.Size
                                    
                                    if hrpPos.X >= zonePos.X - zoneSize.X/2 and hrpPos.X <= zonePos.X + zoneSize.X/2 and
                                       hrpPos.Y >= zonePos.Y - zoneSize.Y/2 and hrpPos.Y <= zonePos.Y + zoneSize.Y/2 and
                                       hrpPos.Z >= zonePos.Z - zoneSize.Z/2 and hrpPos.Z <= zonePos.Z + zoneSize.Z/2 then
                                        inZone = true
                                    end
                                end
                                
                                if not inZone then
                                    table.insert(validTargets, p)
                                end
                            end
                        end
                        
                        if #validTargets > 0 then
                            if not currentTarget or not table.find(validTargets, currentTarget) then
                                currentTarget = validTargets[math.random(1, #validTargets)]
                            end
                            
                            local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local targetHRP = currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart")
                            local targetHumanoid = currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid")
                            
                            if hrp and targetHRP and targetHumanoid then
                                local fightingZone = workspace:FindFirstChild("FightingArea") and workspace.FightingArea:FindFirstChild("FightingZonePart")
                                if fightingZone then
                                    local targetPos = targetHRP.Position
                                    local zonePos = fightingZone.Position
                                    local zoneSize = fightingZone.Size
                                    
                                    if targetPos.X >= zonePos.X - zoneSize.X/2 and targetPos.X <= zonePos.X + zoneSize.X/2 and
                                       targetPos.Y >= zonePos.Y - zoneSize.Y/2 and targetPos.Y <= zonePos.Y + zoneSize.Y/2 and
                                       targetPos.Z >= zonePos.Z - zoneSize.Z/2 and targetPos.Z <= zonePos.Z + zoneSize.Z/2 then
                                        currentTarget = nil
                                        wait(0.03)
                                        return
                                    end
                                end
                                
                                angle = angle + 0.5
                                local radius = 15
                                local offset = Vector3.new(
                                    math.cos(angle) * radius,
                                    0,
                                    math.sin(angle) * radius
                                )
                                
                                hrp.CFrame = CFrame.new(targetHRP.Position + offset, targetHRP.Position)
                                ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(targetHumanoid, 2)
                                
                                if ReplicatedStorage:FindFirstChild("SkillsInRS") and ReplicatedStorage.SkillsInRS:FindFirstChild("RemoteEvent") then
                                    ReplicatedStorage.SkillsInRS.RemoteEvent:FireServer(targetHRP.Position, "NewLightningball")
                                end
                            end
                        else
                            currentTarget = nil
                        end
                    end)
                    
                    wait(0.03)
                end
            end)
        end
    end,
})

PvPLeft:AddToggle({
    Name = "Orbit All Low Level",
    Default = false,
    Callback = function(value)
        toggles.orbitAllLowLvl = value
        
        if toggles.orbitAllLowLvl then
            task.spawn(function()
                local angle = 0
                local currentTarget = nil
                
                while toggles.orbitAllLowLvl do
                    pcall(function()
                        local myLevel = localPlayer:FindFirstChild("leaderstats") and localPlayer.leaderstats:FindFirstChild("Level") and localPlayer.leaderstats.Level.Value or 0
                        
                        local validTargets = {}
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                                local targetLevel = p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Level") and p.leaderstats.Level.Value or 0
                                
                                if targetLevel < myLevel then
                                    local fightingZone = workspace:FindFirstChild("FightingArea") and workspace.FightingArea:FindFirstChild("FightingZonePart")
                                    local inZone = false
                                    
                                    if fightingZone then
                                        local hrpPos = p.Character.HumanoidRootPart.Position
                                        local zonePos = fightingZone.Position
                                        local zoneSize = fightingZone.Size
                                        
                                        if hrpPos.X >= zonePos.X - zoneSize.X/2 and hrpPos.X <= zonePos.X + zoneSize.X/2 and
                                           hrpPos.Y >= zonePos.Y - zoneSize.Y/2 and hrpPos.Y <= zonePos.Y + zoneSize.Y/2 and
                                           hrpPos.Z >= zonePos.Z - zoneSize.Z/2 and hrpPos.Z <= zonePos.Z + zoneSize.Z/2 then
                                            inZone = true
                                        end
                                    end
                                    
                                    if not inZone then
                                        table.insert(validTargets, p)
                                    end
                                end
                            end
                        end
                        
                        if #validTargets > 0 then
                            if not currentTarget or not table.find(validTargets, currentTarget) then
                                currentTarget = validTargets[math.random(1, #validTargets)]
                            end
                            
                            local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local targetHRP = currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart")
                            local targetHumanoid = currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid")
                            
                            if hrp and targetHRP and targetHumanoid then
                                local fightingZone = workspace:FindFirstChild("FightingArea") and workspace.FightingArea:FindFirstChild("FightingZonePart")
                                if fightingZone then
                                    local targetPos = targetHRP.Position
                                    local zonePos = fightingZone.Position
                                    local zoneSize = fightingZone.Size
                                    
                                    if targetPos.X >= zonePos.X - zoneSize.X/2 and targetPos.X <= zonePos.X + zoneSize.X/2 and
                                       targetPos.Y >= zonePos.Y - zoneSize.Y/2 and targetPos.Y <= zonePos.Y + zoneSize.Y/2 and
                                       targetPos.Z >= zonePos.Z - zoneSize.Z/2 and targetPos.Z <= zonePos.Z + zoneSize.Z/2 then
                                        currentTarget = nil
                                        wait(0.03)
                                        return
                                    end
                                end
                                
                                angle = angle + 0.5
                                local radius = 15
                                local offset = Vector3.new(
                                    math.cos(angle) * radius,
                                    0,
                                    math.sin(angle) * radius
                                )
                                
                                hrp.CFrame = CFrame.new(targetHRP.Position + offset, targetHRP.Position)
                                ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(targetHumanoid, 2)
                                
                                if ReplicatedStorage:FindFirstChild("SkillsInRS") and ReplicatedStorage.SkillsInRS:FindFirstChild("RemoteEvent") then
                                    ReplicatedStorage.SkillsInRS.RemoteEvent:FireServer(targetHRP.Position, "NewLightningball")
                                end
                            end
                        else
                            currentTarget = nil
                        end
                    end)
                    
                    wait(0.03)
                end
            end)
        end
    end,
})

local PvPRight = TabPvP:AddSection("Kill Aura", "right")

PvPRight:AddToggle({
    Name = "Kill Aura (Nearest)",
    Default = false,
    Callback = function(value)
        toggles.killAura = value
        
        if toggles.killAura then
            task.spawn(function()
                while toggles.killAura do
                    pcall(function()
                        local char = localPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        
                        if hrp then
                            local nearestPlayer = nil
                            local nearestDistance = math.huge
                            
                            for _, player in pairs(Players:GetPlayers()) do
                                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                                    local distance = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                    if distance < nearestDistance then
                                        nearestDistance = distance
                                        nearestPlayer = player
                                    end
                                end
                            end
                            
                            if nearestPlayer and nearestPlayer.Character then
                                local targetHRP = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
                                local targetHumanoid = nearestPlayer.Character:FindFirstChild("Humanoid")
                                
                                if targetHRP and targetHumanoid then
                                    ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(targetHumanoid, 2)
                                    
                                    if ReplicatedStorage:FindFirstChild("SkillsInRS") and ReplicatedStorage.SkillsInRS:FindFirstChild("RemoteEvent") then
                                        ReplicatedStorage.SkillsInRS.RemoteEvent:FireServer(targetHRP.Position, "NewLightningball")
                                    end
                                end
                            end
                        end
                    end)
                    
                    task.wait(0.1)
                end
            end)
        end
    end,
})

local TargetSection = TabPvP:AddSection("Targeted Attack", "right")

local function getPlayerList()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

TargetSection:AddDropdown({
    Name = "Select Target Player",
    Options = getPlayerList(),
    Default = getPlayerList()[1] or "No Players",
    Callback = function(value)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name == value then
                settings.selectedTarget = player
            end
        end
    end,
})

TargetSection:AddToggle({
    Name = "Targeted Orbit Attack",
    Default = false,
    Callback = function(value)
        toggles.targetedOrbit = value
        
        if toggles.targetedOrbit then
            if not settings.selectedTarget then
                toggles.targetedOrbit = false
                return
            end
            
            task.spawn(function()
                local angle = 0
                
                while toggles.targetedOrbit do
                    pcall(function()
                        local target = settings.selectedTarget
                        
                        if not target or not Players:FindFirstChild(target.Name) or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") or not target.Character:FindFirstChild("Humanoid") or target.Character.Humanoid.Health <= 0 then
                            toggles.targetedOrbit = false
                            return
                        end
                        
                        local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                        local targetHumanoid = target.Character:FindFirstChild("Humanoid")
                        
                        if hrp and targetHRP and targetHumanoid then
                            angle = angle + 0.5
                            local radius = 15
                            local offset = Vector3.new(
                                math.cos(angle) * radius,
                                0,
                                math.sin(angle) * radius
                            )
                            hrp.CFrame = CFrame.new(targetHRP.Position + offset, targetHRP.Position)
                            
                            ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(targetHumanoid, 2)
                            
                            if ReplicatedStorage:FindFirstChild("SkillsInRS") then
                                ReplicatedStorage.SkillsInRS.RemoteEvent:FireServer(targetHRP.Position, "NewLightningball")
                            end
                        end
                    end)
                    
                    wait(0.03)
                end
            end)
        end
    end,
})

-- TAB SCRIPTS
local TabScripts = Window:CreateTab("Scripts")

local ScriptsLeft = TabScripts:AddSection("Respawn", "left")

ScriptsLeft:AddToggle({
    Name = "Respawn at Death Position",
    Default = false,
    Callback = function(value)
        toggles.respawnAtDeath = value
        
        if toggles.respawnAtDeath then
            local deathPosition = nil
            
            localPlayer.CharacterAdded:Connect(function(char)
                if toggles.respawnAtDeath and deathPosition then
                    task.wait(0.5)
                    local hrp = char:WaitForChild("HumanoidRootPart", 5)
                    if hrp then
                        hrp.CFrame = CFrame.new(deathPosition)
                    end
                end
            end)
            
            task.spawn(function()
                while toggles.respawnAtDeath do
                    pcall(function()
                        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
                            localPlayer.Character.Humanoid.Died:Connect(function()
                                if localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    deathPosition = localPlayer.Character.HumanoidRootPart.Position
                                end
                            end)
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})

local ScriptsRight = TabScripts:AddSection("External Scripts", "right")

ScriptsRight:AddButton({
    Name = "Load Dex Explorer",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
        end)
    end,
})

ScriptsRight:AddButton({
    Name = "Load Infinite Yield",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
    end,
})

-- TAB SETTINGS
local TabSettings = Window:CreateTab("Settings")

local SettingsLeft = TabSettings:AddSection("Bug Report", "left")

SettingsLeft:AddTextBox({
    Name = "Bug Description",
    Placeholder = "Describe the bug...",
    Default = "",
    Callback = function(text, enterPressed)
        settings.bugReportText = text
    end,
})

SettingsLeft:AddButton({
    Name = "Send Bug Report",
    Callback = function()
        if settings.bugReportText == "" or settings.bugReportText == nil then
            return
        end
        
        local webhookURL = "https://discordapp.com/api/webhooks/1463603005189259284/cFKHE_lJu4wAD92K5jx-jOgNbCNm5AJor2xF_P_pbSeKWgTvDAiqOwhO3eY3APBIAIs-"
        
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local playerName = localPlayer.Name
        local playerDisplayName = localPlayer.DisplayName
        
        local data = {
            ["embeds"] = {{
                ["title"] = "New Bug Report - Animal Simulator",
                ["description"] = settings.bugReportText,
                ["color"] = 9055334,
                ["fields"] = {
                    {
                        ["name"] = "Player",
                        ["value"] = playerName .. " (@" .. playerDisplayName .. ")",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Time",
                        ["value"] = timestamp,
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "Astral Hub Bug Report System"
                }
            }}
        }
        
        pcall(function()
            request({
                Url = webhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(data)
            })
        end)
    end,
})
