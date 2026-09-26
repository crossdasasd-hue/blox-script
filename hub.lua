-- ==============================================================================
-- PROJECT: QUANTUM GOD HUB (ENTERPRISE MASTER EDITION v6.0)
-- ARCHITECTURE: Strict Monolithic Error-Boundary Framework
-- TARGET: Universal Mobile & PC Executor Environment (Delta, Codex, Fluxus, etc.)
-- ==============================================================================

print("[QuantumCore] Initializing Quantum God Hub Master Engine...")

if _G.QuantumGodHubEnterpriseRunning then
    pcall(function()
        _G.QuantumGodHubEnterpriseRunning:Destroy()
    end)
    print("[QuantumCore] Destroyed existing active instance.")
end

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [1] SECURE GRAPHICAL ROOT CONTAINER SETUP
local RootScreenGui = Instance.new("ScreenGui")
RootScreenGui.Name = "QuantumGodHubMasterContainer"
RootScreenGui.ResetOnSpawn = false
RootScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
RootScreenGui.IgnoreGuiInset = true

local parentSuccess = pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(RootScreenGui)
        RootScreenGui.Parent = CoreGui
    elseif gethui then
        RootScreenGui.Parent = gethui()
    else
        RootScreenGui.Parent = CoreGui
    end
end)

if not parentSuccess or not RootScreenGui.Parent then
    RootScreenGui.Parent = PlayerGui
end

_G.QuantumGodHubEnterpriseRunning = RootScreenGui

-- [2] CONFIGURATION STATE STORE
local HubConfig = {
    AutoFarmLevel = false,
    FastAttack = false,
    Noclip = false,
    AutoHaki = false,
    AutoChest = false,
    AutoFruit = false,
    AttackDistance = 14,
    TweenSpeed = 320
}

-- [3] ANTI-AFK & REMOTES
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

local function LocateRemotesFolder()
    local folder = ReplicatedStorage:FindFirstChild("Remotes") 
        or ReplicatedStorage:FindFirstChild("Remete") 
        or ReplicatedStorage:FindFirstChild("Remote")
    if not folder then
        for _, child in ipairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("Folder") and (child:FindFirstChild("CommF_") or child:FindFirstChild("Buso")) then
                folder = child
                break
            end
        end
    end
    return folder
end

local RemotesDirectory = LocateRemotesFolder()

-- [4] COMPREHENSIVE QUEST DATABASE (ALL 3 SEAS)
local ComprehensiveQuestDatabase = {
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

local function FetchCurrentQuestDetails()
    local playerLevel = 1
    pcall(function()
        playerLevel = LocalPlayer.Data.Level.Value
    end)
    for _, questData in ipairs(ComprehensiveQuestDatabase) do
        if playerLevel >= questData.Min and playerLevel <= questData.Max then
            return questData.QuestName, questData.Index, questData.MobName, questData.NpcPos
        end
    end
    return "BanditQuest1", 1, "Bandit", CFrame.new(1059, 16, 1549)
end

local function IsQuestActiveOnScreen()
    local success, visible = pcall(function()
        return LocalPlayer.PlayerGui.Main.Quest.Visible
    end)
    return success and visible or false
end

-- [5] TWEEN ENGINE
local MasterTweenReference = nil

local function AbortActiveTween()
    if MasterTweenReference then
        MasterTweenReference:Cancel()
        MasterTweenReference = nil
    end
    pcall(function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local velocityHolder = character.HumanoidRootPart:FindFirstChild("QuantumMasterVelocityHolder")
            if velocityHolder then
                velocityHolder:Destroy()
            end
        end
    end)
end

local function ExecuteTweenToCFrame(destinationCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then return end
    
    local hrp = character.HumanoidRootPart
    local totalDistance = (hrp.Position - destinationCFrame.Position).Magnitude
    
    if MasterTweenReference then
        AbortActiveTween()
    end

    local velocityHolder = Instance.new("BodyVelocity")
    velocityHolder.Name = "QuantumMasterVelocityHolder"
    velocityHolder.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    velocityHolder.Velocity = Vector3.new(0, 0, 0)
    velocityHolder.Parent = hrp

    local calculatedDuration = totalDistance / HubConfig.TweenSpeed
    local tweenInfoConfig = TweenInfo.new(calculatedDuration, Enum.EasingStyle.Linear)
    
    MasterTweenReference = TweenService:Create(hrp, tweenInfoConfig, {CFrame = destinationCFrame})
    MasterTweenReference:Play()
    
    MasterTweenReference.Completed:Connect(function()
        AbortActiveTween()
    end)
end

-- [6] COMBAT TOOL GETTER
local function GetActiveEquippedTool()
    local character = LocalPlayer.Character
    if not character then return nil end
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            return item
        end
    end
    return nil
end

-- [7] GRAPHICAL USER INTERFACE (GUI)
local PrimaryCard = Instance.new("Frame")
PrimaryCard.Name = "QuantumPrimaryCard"
PrimaryCard.AnchorPoint = Vector2.new(0.5, 0.5)
PrimaryCard.Position = UDim2.new(0.5, 0, 0.5, 0)
PrimaryCard.Size = UDim2.new(0, 520, 0, 380)
PrimaryCard.BackgroundColor3 = Color3.fromRGB(14, 11, 24)
PrimaryCard.ClipsDescendants = true
PrimaryCard.Parent = RootScreenGui

Instance.new("UICorner", PrimaryCard).CornerRadius = UDim.new(0, 12)
local CardOutlineStroke = Instance.new("UIStroke")
CardOutlineStroke.Color = Color3.fromRGB(120, 45, 230)
CardOutlineStroke.Thickness = 1.8
CardOutlineStroke.Parent = PrimaryCard

local WindowHeader = Instance.new("Frame")
WindowHeader.Name = "WindowHeader"
WindowHeader.BackgroundColor3 = Color3.fromRGB(22, 16, 36)
WindowHeader.Size = UDim2.new(1, 0, 0, 44)
WindowHeader.Parent = PrimaryCard
Instance.new("UICorner", WindowHeader).CornerRadius = UDim.new(0, 12)

local HeaderTitleText = Instance.new("TextLabel")
HeaderTitleText.BackgroundTransparency = 1
HeaderTitleText.Position = UDim2.new(0, 15, 0, 0)
HeaderTitleText.Size = UDim2.new(1, -90, 1, 0)
HeaderTitleText.Font = Enum.Font.GothamBold
HeaderTitleText.Text = "⚡ Quantum God Hub | Enterprise Edition"
HeaderTitleText.TextColor3 = Color3.fromRGB(230, 210, 255)
HeaderTitleText.TextSize = 13
HeaderTitleText.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitleText.Parent = WindowHeader

local IsWindowDragging, DragStartPoint, WindowStartPos
WindowHeader.InputBegan:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
        IsWindowDragging = true
        DragStartPoint = inputObject.Position
        WindowStartPos = PrimaryCard.Position
        inputObject.Changed:Connect(function()
            if inputObject.UserInputState == Enum.UserInputState.End then
                IsWindowDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(inputObject)
    if IsWindowDragging and (inputObject.UserInputType == Enum.UserInputType.MouseMovement or inputObject.UserInputType == Enum.UserInputType.Touch) then
        local deltaVector = inputObject.Position - DragStartPoint
        PrimaryCard.Position = UDim2.new(WindowStartPos.X.Scale, WindowStartPos.X.Offset + deltaVector.X, WindowStartPos.Y.Scale, WindowStartPos.Y.Offset + deltaVector.Y)
    end
end)

local CloseActionButton = Instance.new("TextButton")
CloseActionButton.BackgroundTransparency = 1
CloseActionButton.Position = UDim2.new(1, -40, 0, 7)
CloseActionButton.Size = UDim2.new(0, 30, 0, 30)
CloseActionButton.Font = Enum.Font.GothamBold
CloseActionButton.Text = "✕"
CloseActionButton.TextColor3 = Color3.fromRGB(240, 80, 80)
CloseActionButton.TextSize = 16
CloseActionButton.Parent = WindowHeader

CloseActionButton.MouseButton1Click:Connect(function()
    RootScreenGui:Destroy()
    _G.QuantumGodHubEnterpriseRunning = nil
end)

local MainScrollContainer = Instance.new("ScrollingFrame")
MainScrollContainer.Name = "MainScrollContainer"
MainScrollContainer.BackgroundTransparency = 1
MainScrollContainer.Position = UDim2.new(0, 15, 0, 54)
MainScrollContainer.Size = UDim2.new(1, -30, 1, -66)
MainScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 450)
MainScrollContainer.ScrollBarThickness = 4
MainScrollContainer.Parent = PrimaryCard

local LayoutManager = Instance.new("UIListLayout")
LayoutManager.Padding = UDim.new(0, 8)
LayoutManager.Parent = MainScrollContainer

local function ConstructToggleComponent(titleString, callbackFunction)
    local toggleState = false
    local componentButton = Instance.new("TextButton")
    componentButton.BackgroundColor3 = Color3.fromRGB(26, 20, 42)
    componentButton.Size = UDim2.new(1, 0, 0, 40)
    componentButton.Font = Enum.Font.GothamMedium
    componentButton.Text = "   " .. titleString .. ": [ OFF ]"
    componentButton.TextColor3 = Color3.fromRGB(190, 180, 220)
    componentButton.TextSize = 12
    componentButton.TextXAlignment = Enum.TextXAlignment.Left
    componentButton.Parent = MainScrollContainer
    
    Instance.new("UICorner", componentButton).CornerRadius = UDim.new(0, 8)
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(85, 45, 160)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = componentButton

    componentButton.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        componentButton.Text = "   " .. titleString .. ": [ " .. (toggleState and "ACTIVE" or "OFF") .. " ]"
        componentButton.TextColor3 = toggleState and Color3.fromRGB(100, 255, 140) or Color3.fromRGB(190, 180, 220)
        buttonStroke.Color = toggleState and Color3.fromRGB(70, 220, 100) or Color3.fromRGB(85, 45, 160)
        callbackFunction(toggleState)
    end)
end

ConstructToggleComponent("Auto-Farm Level (All 3 Seas)", function(state)
    HubConfig.AutoFarmLevel = state
end)

ConstructToggleComponent("Fast Attack (Instant Combat)", function(state)
    HubConfig.FastAttack = state
end)

ConstructToggleComponent("Noclip (Anti-Collision)", function(state)
    HubConfig.Noclip = state
end)

ConstructToggleComponent("Auto Buso Haki", function(state)
    HubConfig.AutoHaki = state
end)

ConstructToggleComponent("Auto Collect Chests", function(state)
    HubConfig.AutoChest = state
end)

ConstructToggleComponent("Auto Collect Fruits", function(state)
    HubConfig.AutoFruit = state
end)

-- [8] AUTONOMOUS MAIN AUTO-FARM ENGINE LOOP
task.spawn(function()
    while task.wait(0.18) do
        pcall(function()
            if HubConfig.AutoFarmLevel then
                local characterRef = LocalPlayer.Character
                if not characterRef or not characterRef:FindFirstChild("HumanoidRootPart") or not characterRef:FindFirstChild("Humanoid") then return end
                
                local hrp = characterRef.HumanoidRootPart
                local humanoid = characterRef.Humanoid
                if humanoid.Health <= 0 then return end

                local questName, questIndex, targetMobName, npcPosition = FetchCurrentQuestDetails()

                if not IsQuestActiveOnScreen() then
                    AbortActiveTween()
                    if (hrp.Position - npcPosition.Position).Magnitude > 18 then
                        ExecuteTweenToCFrame(npcPosition + Vector3.new(0, 12, 0))
                    else
                        if RemotesDirectory and RemotesDirectory:FindFirstChild("CommF_") then
                            RemotesDirectory.CommF_:InvokeServer("RequestQuest", questName, questIndex)
                            task.wait(0.7)
                        end
                    end
                else
                    local targetMobInstance = nil
                    local enemiesFolderRef = Workspace:FindFirstChild("Enemies")
                    
                    if enemiesFolderRef then
                        for _, enemyModel in ipairs(enemiesFolderRef:GetChildren()) do
                            local enemyHum = enemyModel:FindFirstChild("Humanoid")
                            local enemyHrp = enemyModel:FindFirstChild("HumanoidRootPart")
                            if enemyHum and enemyHrp and enemyHum.Health > 0 and enemyModel.Name == targetMobName then
                                targetMobInstance = enemyModel
                                break
                            end
                        end
                    end

                    if not targetMobInstance and enemiesFolderRef then
                        for _, enemyModel in ipairs(enemiesFolderRef:GetChildren()) do
                            local enemyHum = enemyModel:FindFirstChild("Humanoid")
                            local enemyHrp = enemyModel:FindFirstChild("HumanoidRootPart")
                            if enemyHum and enemyHrp and enemyHum.Health > 0 then
                                targetMobInstance = enemyModel
                                break
                            end
                        end
                    end

                    if targetMobInstance and targetMobInstance:FindFirstChild("HumanoidRootPart") then
                        local mobRootPart = targetMobInstance.HumanoidRootPart
                        
                        humanoid.PlatformStand = true
                        hrp.CFrame = mobRootPart.CFrame + Vector3.new(0, HubConfig.AttackDistance, 0)
                        hrp.Velocity = Vector3.new(0, 0, 0)

                        local activeTool = GetActiveEquippedTool()
                        if not activeTool then
                            local backpackContainer = LocalPlayer:FindFirstChildOfClass("Backpack")
                            if backpackContainer then
                                for _, itemObj in ipairs(backpackContainer:GetChildren()) do
                                    if itemObj:IsA("Tool") then
                                        itemObj.Parent = characterRef
                                        activeTool = itemObj
                                        break
                                    end
                                end
                            end
                        end

                        if activeTool then
                            activeTool:Activate()
                        end

                        if enemiesFolderRef then
                            for _, enemyModel in ipairs(enemiesFolderRef:GetChildren()) do
                                if enemyModel.Name == targetMobName and enemyModel:FindFirstChild("HumanoidRootPart") then
                                    local eRoot = enemyModel.HumanoidRootPart
                                    eRoot.CFrame = mobRootPart.CFrame
                                    eRoot.CanCollide = false
                                    local eHum = enemyModel:FindFirstChildOfClass("Humanoid")
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
                local characterRef = LocalPlayer.Character
                if characterRef and characterRef:FindFirstChild("Humanoid") then
                    characterRef.Humanoid.PlatformStand = false
                end
            end
        end)
    end
end)

-- [9] FAST ATTACK WORKER THREAD
task.spawn(function()
    while task.wait(0.035) do
        pcall(function()
            if HubConfig.FastAttack then
                local characterRef = LocalPlayer.Character
                if characterRef then
                    local equippedToolRef = GetActiveEquippedTool()
                    if equippedToolRef and equippedToolRef:FindFirstChild("Handle") then
                        equippedToolRef:Activate()
                    end
                end
            end
        end)
    end
end)

-- [10] PASSIVE NOCLIP MODULE
RunService.Stepped:Connect(function()
    if HubConfig.Noclip and LocalPlayer.Character then
        local hrpRef = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrpRef then
            hrpRef.AssemblyLinearVelocity = Vector3.new(hrpRef.AssemblyLinearVelocity.X, 0, hrpRef.AssemblyLinearVelocity.Z)
        end
        for _, partObj in ipairs(LocalPlayer.Character:GetDescendants()) do
            if partObj:IsA("BasePart") and partObj.Name ~= "HumanoidRootPart" then
                partObj.CanCollide = false
            end
        end
    end
end)

-- [11] PASSIVE HAKI MAINTENANCE
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if HubConfig.AutoHaki then
                local characterRef = LocalPlayer.Character
                if characterRef and not characterRef:FindFirstChild("Buso") and RemotesDirectory and RemotesDirectory:FindFirstChild("CommF_") then
                    RemotesDirectory.CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)

-- [12] PASSIVE CHEST & FRUIT COLLECTION
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local hrpRef = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrpRef then return end

            if HubConfig.AutoChest then
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Part") and string.find(obj.Name, "Chest") then
                        hrpRef.CFrame = obj.CFrame
                        task.wait(0.1)
                        break
                    end
                end
            end

            if HubConfig.AutoFruit then
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                        hrpRef.CFrame = obj.Handle.CFrame
                        task.wait(0.2)
                        break
                    end
                end
            end
        end)
    end
end)

-- [13] NOTIFICATION
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "⚡ Quantum God Hub Enterprise",
        Text = "Master Framework successfully compiled and loaded!",
        Duration = 6
    })
end)

print("[QuantumCore] Execution completed successfully without syntax errors.")
