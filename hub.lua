-- Защита от дублирования
if _G.QuantumGodHub then
    pcall(function() _G.QuantumGodHub:Destroy() end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- Защита от AFK кика
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Универсальный поиск Remotes
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") 
    or ReplicatedStorage:FindFirstChild("Remete") 
    or ReplicatedStorage:FindFirstChild("Remote")

if not Remotes then
    for _, v in pairs(ReplicatedStorage:GetChildren()) do
        if v:IsA("Folder") and (v:FindFirstChild("CommF_") or v:FindFirstChild("Buso")) then
            Remotes = v
            break
        end
    end
end

-- Главный контейнер GUI
local SG = Instance.new("ScreenGui")
SG.Name = "QuantumGodHub"
SG.ZIndexBehavior = Enum.ZIndexBehavior.Global
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true

pcall(function()
    if gethui then SG.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(SG); SG.Parent = game:GetService("CoreGui")
    else SG.Parent = PlayerGui end
end)
if not SG.Parent then SG.Parent = PlayerGui end
_G.QuantumGodHub = SG

-- ==================== ИНТЕРФЕЙС ====================
local W, H = 520, 390
local Card = Instance.new("Frame")
Card.AnchorPoint = Vector2.new(0.5, 0.5)
Card.Position = UDim2.new(0.5, 0, 0.5, 0)
Card.Size = UDim2.new(0, W, 0, H)
Card.BackgroundColor3 = Color3.fromRGB(15, 12, 24)
Card.ClipsDescendants = true
Card.Parent = SG

Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)
local CardStroke = Instance.new("UIStroke")
CardStroke.Color = Color3.fromRGB(120, 60, 220)
CardStroke.Thickness = 1.5
CardStroke.Parent = Card

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(22, 16, 36)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.ZIndex = 5
Header.Parent = Card
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local TitleLbl = Instance.new("TextLabel")
TitleLbl.BackgroundTransparency = 1
TitleLbl.Position = UDim2.new(0, 15, 0, 0)
TitleLbl.Size = UDim2.new(1, -100, 1, 0)
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.Text = "⚡ Blox Fruits Ultimate Hub + Anti-AFK"
TitleLbl.TextColor3 = Color3.fromRGB(220, 200, 255)
TitleLbl.TextSize = 13
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.ZIndex = 6
TitleLbl.Parent = Header

-- Перетаскивание окна (исправлено)
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Card.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 15, 0, 50)
ContentFrame.Size = UDim2.new(1, -30, 1, -60)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 650)
ContentFrame.ScrollBarThickness = 4
ContentFrame.ZIndex = 2
ContentFrame.Parent = Card

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = ContentFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 80, 80)
CloseBtn.TextSize = 16
CloseBtn.ZIndex = 6
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
    _G.QuantumGodHub = nil
end)

local Config = {
    AutoFarm = false,
    Noclip = false,
    AutoBuso = false,
}

local function CreateToggle(titleText, defaultState, callback)
    local state = defaultState
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
    ToggleBtn.Size = UDim2.new(1, 0, 0, 38)
    ToggleBtn.Font = Enum.Font.GothamMedium
    ToggleBtn.Text = "   " .. titleText .. ": [ " .. (state and "ВКЛ" or "ВЫКЛ") .. " ]"
    ToggleBtn.TextColor3 = state and Color3.fromRGB(100, 255, 140) or Color3.fromRGB(200, 180, 240)
    ToggleBtn.TextSize, ToggleBtn.TextXAlignment = 12, Enum.TextXAlignment.Left
    ToggleBtn.ZIndex = 3
    ToggleBtn.Parent = ContentFrame
    
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = state and Color3.fromRGB(80, 220, 110) or Color3.fromRGB(90, 40, 170)
    Stroke.Thickness = 1
    Stroke.Parent = ToggleBtn

    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.Text = "   " .. titleText .. ": [ " .. (state and "ВКЛ" or "ВЫКЛ") .. " ]"
        ToggleBtn.TextColor3 = state and Color3.fromRGB(100, 255, 140) or Color3.fromRGB(200, 180, 240)
        Stroke.Color = state and Color3.fromRGB(80, 220, 110) or Color3.fromRGB(90, 40, 170)
        callback(state)
    end)
end

-- ==================== ПОЛНАЯ БАЗА КВЕСТОВ (1, 2, 3 МОРЯ) ====================
local function GetQuestDetails()
    local success, lv = pcall(function() return LocalPlayer.Data.Level.Value end)
    if not success or not lv then return "BanditQuest1", 1, "Bandit" end

    -- Море 1
    if lv <= 9 then return "BanditQuest1", 1, "Bandit"
    elseif lv <= 14 then return "JungleQuest", 1, "Monkey"
    elseif lv <= 29 then return "JungleQuest", 2, "Gorilla"
    elseif lv <= 39 then return "BuggyQuest1", 1, "Pirate"
    elseif lv <= 59 then return "BuggyQuest1", 2, "Brute"
    elseif lv <= 74 then return "DesertQuest", 1, "Desert Bandit"
    elseif lv <= 89 then return "DesertQuest", 2, "Desert Officer"
    elseif lv <= 99 then return "SnowQuest", 1, "Snow Bandit"
    elseif lv <= 119 then return "SnowQuest", 2, "Snowman"
    elseif lv <= 149 then return "MarineQuest", 1, "Chief Petty Officer"
    elseif lv <= 174 then return "SkyQuest", 1, "Sky Bandit"
    elseif lv <= 192 then return "SkyQuest", 2, "Dark Master"
    elseif lv <= 219 then return "PrisonQuest", 1, "Prisoner"
    elseif lv <= 249 then return "PrisonQuest", 2, "Dangerous Prisoner"
    elseif lv <= 274 then return "ColosseumQuest", 1, "Toga Warrior"
    elseif lv <= 299 then return "ColosseumQuest", 2, "Gladiator"
    elseif lv <= 324 then return "MagmaQuest", 1, "Military Soldier"
    elseif lv <= 374 then return "MagmaQuest", 2, "Military Spy"
    elseif lv <= 399 then return "FishmanQuest", 1, "Fishman Warrior"
    elseif lv <= 449 then return "FishmanQuest", 2, "Fishman Commando"
    elseif lv <= 524 then return "ImpelQuest", 1, "God's Guard"
    elseif lv <= 549 then return "ImpelQuest", 2, "Shanda"
    elseif lv <= 624 then return "FountainQuest", 1, "Galley Pirate"
    elseif lv <= 699 then return "FountainQuest", 2, "Galley Captain"

    -- Море 2
    elseif lv <= 724 then return "Area1Quest", 1, "Raider"
    elseif lv <= 774 then return "Area1Quest", 2, "Mercenary"
    elseif lv <= 799 then return "Area2Quest", 1, "Swan Pirate"
    elseif lv <= 849 then return "Area2Quest", 2, "Factory Staff"
    elseif lv <= 874 then return "MarineQuest2", 1, "Marine Lieutenant"
    elseif lv <= 899 then return "MarineQuest2", 2, "Marine Captain"
    elseif lv <= 949 then return "ZombieQuest", 1, "Zombie"
    elseif lv <= 999 then return "ZombieQuest", 2, "Vampire"
    elseif lv <= 1049 then return "SnowMountainQuest", 1, "Snow Trooper"
    elseif lv <= 1099 then return "SnowMountainQuest", 2, "Winter Warrior"
    elseif lv <= 1149 then return "IceSideQuest", 1, "Lab Subordinate"
    elseif lv <= 1199 then return "IceSideQuest", 2, "Horned Miner"
    elseif lv <= 1249 then return "FireSideQuest", 1, "Magma Ninja"
    elseif lv <= 1299 then return "FireSideQuest", 2, "Lava Pirate"
    elseif lv <= 1349 then return "ShipQuest1", 1, "Ship Deckhand"
    elseif lv <= 1424 then return "ShipQuest1", 2, "Ship Engineer"
    elseif lv <= 1499 then return "CursedQuest1", 1, "Saber Expert"

    -- Море 3
    elseif lv <= 1524 then return "PiratePortQuest", 1, "Pirate Millionaire"
    elseif lv <= 1574 then return "PiratePortQuest", 2, "Pistol Billionaire"
    elseif lv <= 1624 then return "AmazonQuest", 1, "Island Boy"
    elseif lv <= 1674 then return "AmazonQuest", 2, "Sun Warrior"
    elseif lv <= 1724 then return "MarineQuest3", 1, "Marine Commodore"
    elseif lv <= 1774 then return "MarineQuest3", 2, "Marine Rear Admiral"
    elseif lv <= 1824 then return "DeepForestQuest", 1, "Mythological Pirate"
    elseif lv <= 1874 then return "DeepForestQuest", 2, "Musketeer Pirate"
    elseif lv <= 1924 then return "HauntedQuest1", 1, "Reborn Skeleton"
    elseif lv <= 1974 then return "HauntedQuest1", 2, "Living Zombie"
    elseif lv <= 2024 then return "HauntedQuest2", 1, "Demonic Soul"
    elseif lv <= 2074 then return "HauntedQuest2", 2, "Posessed Mummy"
    elseif lv <= 2124 then return "NutIslandQuest", 1, "Peanut Scout"
    elseif lv <= 2199 then return "NutIslandQuest", 2, "Peanut President"
    elseif lv <= 2249 then return "IceCreamQuest", 1, "Ice Cream Chef"
    elseif lv <= 2299 then return "IceCreamQuest", 2, "Ice Cream Commander"
    elseif lv <= 2349 then return "CakeQuest1", 1, "Cookie Crafter"
    elseif lv <= 2399 then return "CakeQuest1", 2, "Cake Guard"
    elseif lv <= 2449 then return "CakeQuest2", 1, "Baking Staff"
    elseif lv <= 2550 then return "CakeQuest2", 2, "Head Baker"
    else return "CakeQuest2", 2, "Head Baker" end
end

local function HasQuest()
    local success, val = pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        if mainGui and mainGui:FindFirstChild("Quest") then
            return mainGui.Quest.Visible
        end
        return false
    end)
    return success and val or false
end

-- ==================== АВТО-ФАРМ ====================
CreateToggle("Авто-Фарм Уровней (Все 3 моря)", false, function(state)
    Config.AutoFarm = state
    task.spawn(function()
        while Config.AutoFarm do
            task.wait(0.1)
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
                local hrp = char.HumanoidRootPart
                local humanoid = char.Humanoid

                if humanoid.Health <= 0 then return end

                -- 1. Проверяем квест
                if not HasQuest() then
                    local qName, qId, _ = GetQuestDetails()
                    if qName and Remotes and Remotes:FindFirstChild("CommF_") then
                        pcall(function()
                            Remotes.CommF_:InvokeServer("RequestQuest", qName, qId)
                        end)
                        task.wait(1.5)
                        return
                    end
                end

                -- 2. Ищем моба
                local enemies = workspace:FindFirstChild("Enemies")
                local target = nil
                local _, _, targetName = GetQuestDetails()

                if enemies and targetName then
                    for _, enemy in pairs(enemies:GetChildren()) do
                        local eHum = enemy:FindFirstChild("Humanoid")
                        local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                        if eHum and eHrp and eHum.Health > 0 then
                            if string.find(enemy.Name, targetName) then
                                target = enemy
                                break
                            end
                        end
                    end
                end

                -- 3. Телепортация и удар
                if target and target:FindFirstChild("HumanoidRootPart") then
                    local tHrp = target.HumanoidRootPart
                    
                    humanoid.PlatformStand = true
                    hrp.CFrame = tHrp.CFrame + Vector3.new(0, 15, 0)
                    hrp.Velocity = Vector3.new(0, 0, 0)

                    local tool = char:FindFirstChildOfClass("Tool")
                    if not tool then
                        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
                        if backpack then
                            for _, item in pairs(backpack:GetChildren()) do
                                if item:IsA("Tool") then
                                    item.Parent = char
                                    tool = item
                                    break
                                end
                            end
                        end
                    end

                    if tool then
                        pcall(function() tool:Activate() end)
                    end
                else
                    humanoid.PlatformStand = false
                end
            end)
        end
        
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.PlatformStand = false
            end
        end)
    end)
end)

-- Noclip
CreateToggle("Анти-застревание (Noclip)", false, function(state)
    Config.Noclip = state
end)

RunService.Stepped:Connect(function()
    if (Config.Noclip or Config.AutoFarm) and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
        end
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
                part.CanCollide = false 
            end
        end
    end
end)

-- Авто-Хаки
CreateToggle("Авто-Хаки (Buso Haki)", false, function(state)
    Config.AutoBuso = state
    task.spawn(function()
        while Config.AutoBuso do
            task.wait(2)
            pcall(function()
                if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("Buso") and Remotes and Remotes:FindFirstChild("CommF_") then
                    Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end)
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚡ God Mode Hub",
    Text = "Успешно загружено! Добавлен Анти-АФК и квесты всех морей.",
    Duration = 4
})
