-- ==============================================================================
-- PROJECT: QUANTUM GOD HUB (BLOFS FRUITS ULTIMATE AUTOFARM)
-- ARCHITECTURE: Monolithic Modular Framework (Engineered for Extreme Stability)
-- TARGET: Universal Executor Compatibility (Mobile / PC)
-- ==============================================================================

-- [1] SYSTEM ENVIRONMENT & GLOBAL PROTECTIONS
if _G.QuantumGodHubRunning then
    pcall(function() _G.QuantumGodHubRunning:Destroy() end)
end

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Setup Main ScreenGui Container
local MainScreenGui = Instance.new("ScreenGui")
MainScreenGui.Name = "QuantumGodHubRoot"
MainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
MainScreenGui.ResetOnSpawn = false
MainScreenGui.IgnoreGuiInset = true

pcall(function()
    if gethui then
        MainScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(MainScreenGui)
        MainScreenGui.Parent = CoreGui
    else
        MainScreenGui.Parent = PlayerGui
    end
end)

if not MainScreenGui.Parent then
    MainScreenGui.Parent = PlayerGui
end
_G.QuantumGodHubRunning = MainScreenGui

-- [2] CONFIGURATION DATA & STATE STORE
local Settings = {
    AutoFarmLevel = false,
    FastAttack = false,
    Noclip = false,
    AutoHaki = false,
    AutoChest = false,
    AutoFruit = false,
    SelectedWeapon = "Melee",
    AttackDistance = 15,
    TweenSpeed = 320,
    VisualTheme = "DarkPurple"
}

-- [3] CORE UTILITY SERVICES & ANTI-AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local function GetRemotes()
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes") 
        or ReplicatedStorage:FindFirstChild("Remete") 
        or ReplicatedStorage:FindFirstChild("Remote")
    if not remotesFolder then
        for _, child in ipairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("Folder") and (child:FindFirstChild("CommF_") or child:FindFirstChild("Buso")) then
                remotesFolder = child
                break
            end
        end
    end
    return remotesFolder
end

local RemotesFolder = GetRemotes()

-- [4] COMPREHENSIVE LEVEL & QUEST DATABASE (ALL 3 SEAS)
local QuestDatabase = {
    -- Sea 1
    {Min = 1, Max = 9, QuestName = "BanditQuest1", Index = 1, MobName = "Bandit", NpcPos = CFrame.new(1059, 16, 1549)},
    {Min = 10, Max = 14, QuestName = "JungleQuest", Index = 1, MobName = "Monkey", NpcPos = CFrame.new(-1598, 36, 153)},
    {Min = 15, Max = 29, QuestName = "JungleQuest", Index = 2, MobName = "Gorilla", NpcPos = CFrame.new(-1598, 36, 153)},
    {Min = 30, Max = 39, QuestName = "BuggyQuest1", Index = 1, MobName = "Pirate", NpcPos = CFrame.new(-1141, 4, 3828)},
    {Min = 40, Max = 59, QuestName = "BuggyQuest1", Index = 2, MobName = "Brute", NpcPos = CFrame.new(-1141, 4, 3828)},
    {Min = 60, Max = 74, QuestName = "DesertQuest", Index = 1, MobName = "Desert Bandit", NpcPos = CFrame.new(896, 6, 4390)},
    {Min = 75, Max = 89, QuestName = "DesertQuest", Index = 2, MobName = "Desert Officer", NpcPos = CFrame.new(896, 6, 4390)},
    {Min = 90, Max = 99, QuestName = "SnowQuest", Index = 1, MobName = "Snow Bandit", NpcPos = CFrame.new(1389, 87, -1298)},
    {Min = 100, Max = 119, QuestName = "SnowQuest", Index = 2, MobName = "Snowman", NpcPos = CFrame.new(1389, 87, -1298)},
    {Min = 120, Max = 149, QuestName = "MarineQuest", Index = 1, MobName = "Chief Petty Officer", NpcPos = CFrame.new(-5035, 20, 4325)},
    {Min = 150, Max = 174, QuestName = "SkyQuest", Index = 1, MobName = "Sky Bandit", NpcPos = CFrame.new(-4842, 717, -2623)},
    {Min = 175, Max = 192, QuestName = "SkyQuest", Index = 2, MobName = "Dark Master", NpcPos = CFrame.new(-4842, 717, -2623)},
    {Min = 193, Max = 219, QuestName = "PrisonQuest", Index = 1, MobName = "Prisoner", NpcPos = CFrame.new(487, 4, 627)},
    {Min = 220, Max = 249, QuestName = "PrisonQuest", Index = 2, MobName = "Dangerous Prisoner", NpcPos = CFrame.new(487, 4, 627)},
    {Min = 250, Max = 274, QuestName = "ColosseumQuest", Index = 1, MobName = "Toga Warrior", NpcPos = CFrame.new(-1580, 7.5, -2983)},
    {Min = 275, Max = 299, QuestName = "ColosseumQuest", Index = 2, MobName = "Gladiator", NpcPos = CFrame.new(-1580, 7.5, -2983)},
    {Min = 300, Max = 324, QuestName = "MagmaQuest", Index = 1, MobName = "Military Soldier", NpcPos = CFrame.new(-5316, 12, 8515)},
    {Min = 325, Max = 374, QuestName = "MagmaQuest", Index = 2, MobName = "Military Spy", NpcPos = CFrame.new(-5316, 12, 8515)},
    {Min = 375, Max = 399, QuestName = "FishmanQuest", Index = 1, MobName = "Fishman Warrior", NpcPos = CFrame.new(6112, 18, 1567)},
    {Min = 400, Max = 449, QuestName = "FishmanQuest", Index = 2, MobName = "Fishman Commando", NpcPos = CFrame.new(6112, 18, 1567)},
    {Min = 450, Max = 524, QuestName = "ImpelQuest", Index = 1, MobName = "God's Guard", NpcPos = CFrame.new(-4721, 845, -1950)},
    {Min = 525, Max = 549, QuestName = "ImpelQuest", Index = 2, MobName = "Shanda", NpcPos = CFrame.new(-7859, 5545, -381)},
    {Min = 550, Max = 624, QuestName = "FountainQuest", Index = 1, MobName = "Galley Pirate", NpcPos = CFrame.new(5259, 38, 4050)},
    {Min = 625, Max = 699, QuestName = "FountainQuest", Index = 2, MobName = "Galley Captain", NpcPos = CFrame.new(5259, 38, 4050)},

    -- Sea 2
    {Min = 700, Max = 724, QuestName = "Area1Quest", Index = 1, MobName = "Raider", NpcPos = CFrame.new(-424, 73, 1836)},
    {Min = 725, Max = 774, QuestName = "Area1Quest", Index = 2, MobName = "Mercenary", NpcPos = CFrame.new(-424, 73, 1836)},
    {Min = 775, Max = 799, QuestName = "Area2Quest", Index = 1, MobName = "Swan Pirate", NpcPos = CFrame.new(638, 73, 918)},
    {Min = 800, Max = 849, QuestName = "Area2Quest", Index = 2, MobName = "Factory Staff", NpcPos = CFrame.new(638, 73, 918)},
    {Min = 850, Max = 874, QuestName = "MarineQuest2", Index = 1, MobName = "Marine Lieutenant", NpcPos = CFrame.new(-2442, 73, -3215)},
    {Min = 875, Max = 899, QuestName = "MarineQuest2", Index = 2, MobName = "Marine Captain", NpcPos = CFrame.new(-2442, 73, -3215)},
    {Min = 900, Max = 949, QuestName = "ZombieQuest", Index = 1, MobName = "Zombie", NpcPos = CFrame.new(-5497, 49, -795)},
    {Min = 950, Max = 999, QuestName = "ZombieQuest", Index = 2, MobName = "Vampire", NpcPos = CFrame.new(-5497, 49, -795)},
    {Min = 1000, Max = 1049, QuestName = "SnowMountainQuest", Index = 1, MobName = "Snow Trooper", NpcPos = CFrame.new(609, 402, -5372)},
    {Min = 1050, Max = 1099, QuestName = "SnowMountainQuest", Index = 2, MobName = "Winter Warrior", NpcPos = CFrame.new(609, 402, -5372)},
    {Min = 1100, Max = 1149, QuestName = "IceSideQuest", Index = 1, MobName = "Lab Subordinate", NpcPos = CFrame.new(-6062, 15, -5095)},
    {Min = 1150, Max = 1199, QuestName = "IceSideQuest", Index = 2, MobName = "Horned Miner", NpcPos = CFrame.new(-6062, 15, -5095)},
    {Min = 1200, Max = 1249, QuestName = "FireSideQuest", Index = 1, MobName = "Magma Ninja", NpcPos = CFrame.new(-5428, 15, -8127)},
    {Min = 1250, Max = 1299, QuestName = "FireSideQuest", Index = 2, MobName = "Lava Pirate", NpcPos = CFrame.new(-5428, 15, -8127)},
    {Min = 1300, Max = 1349, QuestName = "ShipQuest1", Index = 1, MobName = "Ship Deckhand", NpcPos = CFrame.new(1038, 125, 32911)},
    {Min = 1350, Max = 1424, QuestName = "ShipQuest1", Index = 2, MobName = "Ship Engineer", NpcPos = CFrame.new(1038, 125, 32911)},
    {Min = 1425, Max = 1499, QuestName = "CursedQuest1", Index = 1, MobName = "Saber Expert", NpcPos = CFrame.new(-2228, 13, -3044)},

    -- Sea 3
    {Min = 1500, Max = 1524, QuestName = "PiratePortQuest", Index = 1, MobName = "Pirate Millionaire", NpcPos = CFrame.new(-290, 43, 5581)},
    {Min = 1525, Max = 1574, QuestName = "PiratePortQuest", Index = 2, MobName = "Pistol Billionaire", NpcPos = CFrame.new(-290, 43, 5581)},
    {Min = 1575, Max = 1624, QuestName = "AmazonQuest", Index = 1, MobName = "Island Boy", NpcPos = CFrame.new(5446, 600, 755)},
    {Min = 1625, Max = 1674, QuestName = "AmazonQuest", Index = 2, MobName = "Sun Warrior", NpcPos = CFrame.new(5446, 600, 755)},
    {Min = 1675, Max = 1724, QuestName = "MarineQuest3", Index = 1, MobName = "Marine Commodore", NpcPos = CFrame.new(2180, 28, -6741)},
    {Min = 1725, Max = 1774, QuestName = "MarineQuest3", Index = 2, MobName = "Marine Rear Admiral", NpcPos = CFrame.new(2180, 28, -6741)},
    {Min = 1775, Max = 1824, QuestName = "DeepForestQuest", Index = 1, MobName = "Mythological Pirate", NpcPos = CFrame.new(-13233, 332, -7648)},
    {Min = 1825, Max = 1874, QuestName = "DeepForestQuest", Index = 2, MobName = "Musketeer Pirate", NpcPos = CFrame.new(-13233, 332, -7648)},
    {Min = 1875, Max = 1924, QuestName = "HauntedQuest1", Index = 1, MobName = "Reborn Skeleton", NpcPos = CFrame.new(-9479, 142, 5565)},
    {Min = 1925, Max = 1974, QuestName = "HauntedQuest1", Index = 2, MobName = "Living Zombie", NpcPos = CFrame.new(-9479, 142, 5565)},
    {Min = 1975, Max = 2024, QuestName = "HauntedQuest2", Index = 1, MobName = "Demonic Soul", NpcPos = CFrame.new(-9516, 172, 6078)},
    {Min = 2025, Max = 2074, QuestName = "HauntedQuest2", Index = 2, MobName = "Posessed Mummy", NpcPos = CFrame.new(-9516, 172, 6078)},
    {Min = 2075, Max = 2124, QuestName = "NutIslandQuest", Index = 1, MobName = "Peanut Scout", NpcPos = CFrame.new(-2104, 38, -10194)},
    {Min = 2125, Max = 2199, QuestName = "NutIslandQuest", Index = 2, MobName = "Peanut President", NpcPos = CFrame.new(-2104, 38, -10194)},
    {Min = 2200, Max = 2249, QuestName = "IceCreamQuest", Index = 1, MobName = "Ice Cream Chef", NpcPos = CFrame.new(-803, 67, -10963)},
    {Min = 2250, Max = 2299, QuestName = "IceCreamQuest", Index = 2, MobName = "Ice Cream Commander", NpcPos = CFrame.new(-803, 67, -10963)},
    {Min = 2300, Max = 2349, QuestName = "CakeQuest1", Index = 1, MobName = "Cookie Crafter", NpcPos = CFrame.new(-2015, 38, -12050)},
    {Min = 2350, Max = 2399, QuestName = "CakeQuest1", Index = 2, MobName = "Cake Guard", NpcPos = CFrame.new(-2015, 38, -12050)},
    {Min = 2400, Max = 2449, QuestName = "CakeQuest2", Index = 1, MobName = "Baking Staff", NpcPos = CFrame.new(-1902, 38, -12842)},
    {Min = 2450, Max = 9999, QuestName = "CakeQuest2", Index = 2, MobName = "Head Baker", NpcPos = CFrame.new(-1902, 38, -12842)}
}

local function GetCurrentQuestDetails()
    local playerLevel = 1
    pcall(function()
        playerLevel = LocalPlayer.Data.Level.Value
    end)

    for _, quest in ipairs(QuestDatabase) do
        if playerLevel >= quest.Min and playerLevel <= quest.Max then
            return quest.QuestName, quest.Index, quest.MobName, quest.NpcPos
        end
    end
    -- Fallback default
    return "BanditQuest1", 1, "Bandit", CFrame.new(1059, 16, 1549)
end

local function HasActiveQuest()
    local success, visible = pcall(function()
        return LocalPlayer.PlayerGui.Main.Quest.Visible
    end)
    return success and visible or false
end

-- [5] MOVEMENT & TWEEN ENGINE (SAFE MATH VECTOR INTERPOLATION)
local ActiveTween = nil

local function CancelTween()
    if ActiveTween then
        ActiveTween:Cancel()
        ActiveTween = nil
    end
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local bodyVelocity = character.HumanoidRootPart:FindFirstChild("QuantumBodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end

local function TweenTo(targetCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then return end
    
    local humanoidRootPart = character.HumanoidRootPart
    local distance = (humanoidRootPart.Position - targetCFrame.Position).Magnitude
    
    if ActiveTween then
        CancelTween()
    end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "QuantumBodyVelocity"
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart

    local duration = distance / Settings.TweenSpeed
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    
    ActiveTween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    ActiveTween:Play()
    
    ActiveTween.Completed:Connect(function()
        CancelTween()
    end)
end

-- [6] FAST ATTACK COMBAT FRAMEWORK MODULE
local CombatFramework = nil
local CombatFrameworkR = nil
pcall(function()
    CombatFramework = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
    CombatFrameworkR = getupvalues(CombatFramework)[2]
end)

local function GetEquippedTool()
    local character = LocalPlayer.Character
    if not character then return nil end
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            if Settings.SelectedWeapon == "Melee" and item.ToolTip == "Melee" then
                return item
            elseif Settings.SelectedWeapon == "Sword" and item.ToolTip == "Sword" then
                return item
            elseif Settings.SelectedWeapon == "Blox Fruit" and item.ToolTip == "Blox Fruit" then
                return item
            elseif Settings.SelectedWeapon == "Gun" and item.ToolTip == "Gun" then
                return item
            end
        end
    end
    -- Fallback to any tool
    return character:FindFirstChildOfClass("Tool")
end

-- [7] GRAPHICAL USER INTERFACE (MODULAR DRAGGABLE WINDOW)
local WindowWidth, WindowHeight = 540, 390
local MainCard = Instance.new("Frame")
MainCard.Name = "MainCard"
MainCard.AnchorPoint = Vector2.new(0.5, 0.5)
MainCard.Position = UDim2.new(0.5, 0, 0.5, 0)
MainCard.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
MainCard.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
MainCard.ClipsDescendants = true
MainCard.Parent = MainScreenGui

Instance.new("UICorner", MainCard).CornerRadius = UDim.new(0, 12)
local CardBorder = Instance.new("UIStroke")
CardBorder.Color = Color3.fromRGB(110, 40, 210)
CardBorder.Thickness = 1.8
CardBorder.Parent = MainCard

-- Window Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.BackgroundColor3 = Color3.fromRGB(20, 15, 32)
Header.Size = UDim2.new(1, 0, 0, 42)
Header.Parent = MainCard
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ Quantum God Hub | Blox Fruits Enterprise Edition"
TitleLabel.TextColor3 = Color3.fromRGB(220, 200, 255)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Dragging Logic Implementation
local Dragging, DragInput, DragStart, StartPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainCard.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - DragStart
        MainCard.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
end)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -38, 0, 6)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(230, 80, 80)
CloseButton.TextSize = 15
CloseButton.Parent = Header

CloseButton.MouseButton1Click:Connect(function()
    MainScreenGui:Destroy()
    _G.QuantumGodHubRunning = nil
end)

-- Tab Content Container
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.Position = UDim2.new(0, 15, 0, 52)
ScrollContainer.Size = UDim2.new(1, -30, 1, -64)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 650)
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.Parent = MainCard

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollContainer

local function CreateToggleComponent(labelText, callback)
    local state = false
    local Button = Instance.new("TextButton")
    Button.BackgroundColor3 = Color3.fromRGB(24, 18, 38)
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.Font = Enum.Font.GothamMedium
    Button.Text = "   " .. labelText .. ": [ OFF ]"
    Button.TextColor3 = Color3.fromRGB(190, 180, 220)
    Button.TextSize = 12
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = ScrollContainer
    
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(80, 40, 150)
    Stroke.Thickness = 1
    Stroke.Parent = Button

    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = "   " .. labelText .. ": [ " .. (state and "ACTIVE" or "OFF") .. " ]"
        Button.TextColor3 = state and Color3.fromRGB(100, 255, 140) or Color3.fromRGB(190, 180, 220)
        Stroke.Color = state and Color3.fromRGB(70, 220, 100) or Color3.fromRGB(80, 40, 150)
        callback(state)
    end)
end

-- Build Interface Modules
CreateToggleComponent("Auto-Farm Level (All 3 Seas)", function(val)
    Settings.AutoFarmLevel = val
end)

CreateToggleComponent("Fast Attack (Instant Hitbox)", function(val)
    Settings.FastAttack = val
end)

CreateToggleComponent("Noclip (Anti-Collision)", function(val)
    Settings.Noclip = val
end)

CreateToggleComponent("Auto Buso Haki", function(val)
    Settings.AutoHaki = val
end)

CreateToggleComponent("Auto Collect Chests", function(val)
    Settings.AutoChest = val
end)

CreateToggleComponent("Auto Collect Fruits", function(val)
    Settings.AutoFruit = val
end)

-- [8] AUTONOMOUS MAIN FARM LOOP EXECUTION
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if Settings.AutoFarmLevel then
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then return end
                
                local hrp = character.HumanoidRootPart
                local humanoid = character.Humanoid
                if humanoid.Health <= 0 then return end

                local questName, questIndex, mobName, npcPos = GetCurrentQuestDetails()

                -- Step A: Quest Acquisition
                if not HasActiveQuest() then
                    CancelTween()
                    if (hrp.Position - npcPos.Position).Magnitude > 15 then
                        TweenTo(npcPos + Vector3.new(0, 10, 0))
                    else
                        if RemotesFolder and RemotesFolder:FindFirstChild("CommF_") then
                            RemotesFolder.CommF_:InvokeServer("RequestQuest", questName, questIndex)
                            task.wait(0.8)
                        end
                    end
                else
                    -- Step B: Mob Engagement & Farm
                    local targetMob = nil
                    local enemiesFolder = Workspace:FindFirstChild("Enemies")
                    
                    if enemiesFolder then
                        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                            local enemyHum = enemy:FindFirstChild("Humanoid")
                            local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
                            if enemyHum and enemyHrp and enemyHum.Health > 0 and enemy.Name == mobName then
                                targetMob = enemy
                                break
                            end
                        end
                    end

                    -- If specific quest mob not found, find any enemy
                    if not targetMob and enemiesFolder then
                        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                            local enemyHum = enemy:FindFirstChild("Humanoid")
                            local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
                            if enemyHum and enemyHrp and enemyHum.Health > 0 then
                                targetMob = enemy
                                break
                            end
                        end
                    end

                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        local mobHrp = targetMob.HumanoidRootPart
                        
                        -- Keep character floating safely above the target mob
                        humanoid.PlatformStand = true
                        hrp.CFrame = mobHrp.CFrame + Vector3.new(0, Settings.AttackDistance, 0)
                        hrp.Velocity = Vector3.new(0, 0, 0)

                        -- Equip tool and attack
                        local equippedTool = GetEquippedTool()
                        if not equippedTool then
                            local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
                            if backpack then
                                for _, item in ipairs(backpack:GetChildren()) do
                                    if item:IsA("Tool") then
                                        item.Parent = character
                                        equippedTool = item
                                        break
                                    end
                                end
                            end
                        end

                        if equippedTool then
                            equippedTool:Activate()
                        end

                        -- Mob Bring / Cluster Optimization
                        if enemiesFolder then
                            for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                                if enemy.Name == mobName and enemy:FindFirstChild("HumanoidRootPart") then
                                    local eHrp = enemy.HumanoidRootPart
                                    eHrp.CFrame = mobHrp.CFrame
                                    eHrp.CanCollide = false
                                    local eHum = enemy:FindFirstChildOfClass("Humanoid")
                                    if eHum then
                                        eHum.WalkSpeed = 0
                                    end
                                end
                            end
                        end
                    else
                        humanoid.PlatformStand = false
                    end
                end
            else
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.PlatformStand = false
                end
            end
        end)
    end
end)

-- [9] FAST ATTACK & COMBAT ENHANCEMENT THREAD
task.spawn(function()
    while task.wait(0.04) do
        pcall(function()
            if Settings.FastAttack then
                local character = LocalPlayer.Character
                if character then
                    local tool = GetEquippedTool()
                    if tool and tool:FindFirstChild("Handle") then
                        tool:Activate()
                        if CombatFrameworkR and CombatFrameworkR.activeController then
                            CombatFrameworkR.activeController.timeToNextAttack = 0
                            CombatFrameworkR.activeController.hitboxMagnitude = 60
                            CombatFrameworkR.activeController:attack()
                        end
                    end
                end
            end
        end)
    end
end)

-- [10] PASSIVE SYSTEMS: NOCLIP & AUTO HAKI
RunService.Stepped:Connect(function()
    if Settings.Noclip and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
        end
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if Settings.AutoHaki then
                local character = LocalPlayer.Character
                if character and not character:FindFirstChild("Buso") and RemotesFolder and RemotesFolder:FindFirstChild("CommF_") then
                    RemotesFolder.CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)

-- [11] NOTIFICATION INITIALIZATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚡ Quantum God Hub Loaded",
    Text = "Framework successfully initialized. Enjoy seamless autofarm!",
    Duration = 5
})
