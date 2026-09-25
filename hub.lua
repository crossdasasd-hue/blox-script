-- Часть 1: Ядро и Система Квестов
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- Защита от AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Поиск Remotes
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") 
    or ReplicatedStorage:FindFirstChild("Remete") 
    or ReplicatedStorage:FindFirstChild("Remote")

-- База квестов всех 3 морей
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

print("Часть 1 загружена успешно! Твой квест сейчас: " .. GetQuestDetails())
-- Часть 2: Система плавного полета (Tween)
local TweenService = game:GetService("TweenService")

getgenv().Tweening = false
getgenv().CurrentTween = nil

local function StopTween()
    if getgenv().CurrentTween then
        getgenv().CurrentTween:Cancel()
        getgenv().CurrentTween = nil
    end
    getgenv().Tweening = false
    
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChild("BodyVelocity")
        local bg = hrp:FindFirstChild("BodyGyro")
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end

local function FlyTo(targetPosition, speed)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local distance = (hrp.Position - targetPosition).Magnitude
    
    -- Стандартная скорость полета в топовых скриптах (около 300-350)
    speed = speed or 320 
    
    if getgenv().Tweening then
        StopTween()
    end
    
    getgenv().Tweening = true
    
    -- Защита от падения во время полета
    local bodyVel = hrp:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity")
    bodyVel.Name = "BodyVelocity"
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.Parent = hrp

    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    
    getgenv().CurrentTween = tween
    tween:Play()
    
    local conn
    conn = tween.Completed:Connect(function()
        StopTween()
        if conn then conn:Disconnect() end
    end)
end

-- Тестовая проверка: полет на 50 блоков вверх и обратно через 3 секунды
task.spawn(function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        print("Тест полета: взлетаем...")
        FlyTo(hrp.Position + Vector3.new(0, 50, 0), 150)
    end
end)

print("Часть 2 загружена успешно! Система полета активирована.")
-- Часть 3: Fast Attack (Ускоренная атака и автоматический удар)
local RS = game:GetService("RunService")
local CombatFramework = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local RigController = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework").RigController)
local RigControllerR = getupvalues(RigController)[2]
local ActiveController = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework").ActiveController)
local ActiveControllerR = getupvalues(ActiveController)[2]

getgenv().FastAttackEnabled = true

local function GetCurrentBlade()
    local char = LocalPlayer.Character
    if not char then return nil end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        return tool
    end
    return nil
end

-- Основной цикл мгновенных ударов
task.spawn(function()
    while task.wait(0.01) do
        pcall(function()
            if getgenv().FastAttackEnabled then
                local blade = GetCurrentBlade()
                if blade then
                    -- Эмуляция быстрых ударов через внутренние функции игры
                    if CombatFrameworkR.activeController then
                        CombatFrameworkR.activeController.timeToNextAttack = 0
                        CombatFrameworkR.activeController.hitboxMagnitude = 60
                        CombatFrameworkR.activeController:attack()
                    end
                end
            end
        end)
    end
end)

print("Часть 3 загружена успешно! Fast Attack активирован.")
-- Часть 4: Автоматический фарм (Квесты + Телепортация к мобам)
getgenv().AutoFarm = true

local function GetClosestMob(mobName)
    local target = nil
    local shortestDistance = math.huge
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart

    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v.Name == mobName then
            local head = v:FindFirstChild("Head") or v:FindFirstChild("HumanoidRootPart")
            if head then
                local dist = (hrp.Position - head.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    target = v
                end
            end
        end
    end
    
    -- Если в Enemies нет, ищем в папе с мобами на спавне
    if not target then
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == mobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local head = v:FindFirstChild("Head") or v:FindFirstChild("HumanoidRootPart")
                if head then
                    local dist = (hrp.Position - head.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        target = v
                    end
                end
            end
        end
    end

    return target
end

-- Основной цикл автофарма
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if getgenv().AutoFarm then
                local questName, questIndex, mobName = GetQuestDetails()
                
                -- Проверка: есть ли уже активный квест
                local questGui = LocalPlayer.PlayerGui.Main.Quest
                local isQuestActive = questGui.Visible
                
                if not isQuestActive then
                    -- Если квест не взят — летим к NPC выдачи квеста и берем его
                    -- (Встроенный обработчик диалогов CommF_)
                    if Remotes then
                        local args = {
                            [1] = "StartQuest",
                            [2] = questName,
                            [3] = questIndex
                        }
                        Remotes.CommF_:InvokeServer(unpack(args))
                    end
                    task.wait(1)
                else
                    -- Квест есть — ищем моба и летим к нему
                    local mob = GetClosestMob(mobName)
                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        local mobCFrame = mob.HumanoidRootPart.CFrame
                        -- Телепортируемся/подлетаем чуть выше моба, чтобы не получать урон
                        if type(FlyTo) == "function" then
                            FlyTo(mobCFrame.Position + Vector3.new(0, 15, 0), 350)
                        end
                        
                        -- Принудительно притягиваем мобов к себе для быстрого удара
                        for _, e in pairs(workspace.Enemies:GetChildren()) do
                            if e.Name == mobName and e:FindFirstChild("HumanoidRootPart") then
                                e.HumanoidRootPart.CFrame = mobCFrame
                                e.HumanoidRootPart.CanCollide = false
                                local hum = e:FindFirstChildOfClass("Humanoid")
                                if hum then
                                    hum.WalkSpeed = 0
                                    hum.JumpPower = 0
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

print("Часть 4 загружена успешно! Автофарм запущен.")
-- ==================== ФИНАЛЬНЫЙ СКРИПТ: BLOX FRUITS ULTIMATE HUB ====================
if _G.QuantumGodHub then
    pcall(function() _G.QuantumGodHub:Destroy() end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- 1. Защита от AFK кика
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 2. Поиск Remotes
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

-- 3. База квестов (Все 3 моря)
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

-- 4. Система безопасного полета (Tween)
getgenv().Tweening = false
getgenv().CurrentTween = nil

local function StopTween()
    if getgenv().CurrentTween then
        getgenv().CurrentTween:Cancel()
        getgenv().CurrentTween = nil
    end
    getgenv().Tweening = false
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChild("BodyVelocity")
        if bv then bv:Destroy() end
    end
end

local function FlyTo(targetPosition, speed)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    local distance = (hrp.Position - targetPosition).Magnitude
    speed = speed or 320 
    
    if getgenv().Tweening then StopTween() end
    getgenv().Tweening = true
    
    local bodyVel = hrp:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity")
    bodyVel.Name = "BodyVelocity"
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.Parent = hrp

    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    getgenv().CurrentTween = tween
    tween:Play()
    
    local conn
    conn = tween.Completed:Connect(function()
        StopTween()
        if conn then conn:Disconnect() end
    end)
end

-- 5. Интерфейс (GUI)
local SG = Instance.new("ScreenGui")
SG.Name = "QuantumGodHub"
SG.ZIndexBehavior = Enum.ZIndexBehavior.Global
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
pcall(function() SG.Parent = game:GetService("CoreGui") end)
if not SG.Parent then SG.Parent = PlayerGui end
_G.QuantumGodHub = SG

local W, H = 500, 360
local Card = Instance.new("Frame")
Card.AnchorPoint = Vector2.new(0.5, 0.5)
Card.Position = UDim2.new(0.5, 0, 0.5, 0)
Card.Size = UDim2.new(0, W, 0, H)
Card.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
Card.ClipsDescendants = true
Card.Parent = SG
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(26, 20, 40)
Header.Size = UDim2.new(1, 0, 0, 38)
Header.Parent = Card
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local TitleLbl = Instance.new("TextLabel")
TitleLbl.BackgroundTransparency = 1
TitleLbl.Position = UDim2.new(0, 12, 0, 0)
TitleLbl.Size = UDim2.new(1, -80, 1, 0)
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.Text = "⚡ Blox Fruits Pro Hub [Anti-AFK + All Seas]"
TitleLbl.TextColor3 = Color3.fromRGB(210, 190, 255)
TitleLbl.TextSize = 12
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.Parent = Header

-- Перетаскивание окна
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Card.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -35, 0, 4)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
CloseBtn.TextSize = 14
CloseBtn.Parent = Header
CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
    _G.QuantumGodHub = nil
end)

local Content = Instance.new("ScrollingFrame")
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 15, 0, 48)
Content.Size = UDim2.new(1, -30, 1, -58)
Content.CanvasSize = UDim2.new(0, 0, 0, 400)
Content.ScrollBarThickness = 3
Content.Parent = Card

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Content

local Config = {
    AutoFarm = false,
    FastAttack = false,
    Noclip = false,
    AutoBuso = false
}

local function AddToggle(name, callback)
    local state = false
    local Btn = Instance.new("TextButton")
    Btn.BackgroundColor3 = Color3.fromRGB(28, 22, 44)
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.Font = Enum.Font.GothamMedium
    Btn.Text = "   " .. name .. ": [ ВЫКЛ ]"
    Btn.TextColor3 = Color3.fromRGB(180, 170, 210)
    Btn.TextSize, Btn.TextXAlignment = 12, Enum.TextXAlignment.Left
    Btn.Parent = Content
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = "   " .. name .. ": [ " .. (state and "ВКЛ" or "ВЫКЛ") .. " ]"
        Btn.TextColor3 = state and Color3.fromRGB(100, 255, 140) or Color3.fromRGB(180, 170, 210)
        callback(state)
    end)
end

-- 6. Подключение логики к кнопкам интерфейса
AddToggle("Авто-Фарм Уровней (Все моря)", function(state) Config.AutoFarm = state end)
AddToggle("Fast Attack (Быстрый удар)", function(state) Config.FastAttack = state end)
AddToggle("Noclip (Проход сквозь стены)", function(state) Config.Noclip = state end)
AddToggle("Авто-Хаки (Buso Haki)", function(state) Config.AutoBuso = state end)

-- Цикл Автофарма
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if Config.AutoFarm then
                local qName, qIndex, targetName = GetQuestDetails()
                local questGui = LocalPlayer.PlayerGui.Main.Quest
                
                if not questGui.Visible then
                    if Remotes and Remotes:FindFirstChild("CommF_") then
                        Remotes.CommF_:InvokeServer("RequestQuest", qName, qIndex)
                    end
                    task.wait(1)
                else
                    local target = nil
                    if workspace:FindFirstChild("Enemies") then
                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                            if enemy.Name == targetName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                target = enemy
                                break
                            end
                        end
                    end
                    
                    if target and target:FindFirstChild("HumanoidRootPart") then
                        local tHrp = target.HumanoidRootPart
                        FlyTo(tHrp.Position + Vector3.new(0, 12, 0), 320)
                        
                        -- Притягивание мобов к себе
                        for _, e in pairs(workspace.Enemies:GetChildren()) do
                            if e.Name == targetName and e:FindFirstChild("HumanoidRootPart") then
                                e.HumanoidRootPart.CFrame = tHrp.CFrame
                                e.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- Цикл Fast Attack
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            if Config.FastAttack then
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Handle") then
                        tool:Activate()
                    end
                end
            end
        end)
    end
end)

-- Цикл Noclip и Buso
RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
                part.CanCollide = false 
            end
        end
    end
end)

task.spawn(function()
    while task.wait(3) do
        pcall(function()
            if Config.AutoBuso and LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("Buso") then
                if Remotes and Remotes:FindFirstChild("CommF_") then
                    Remotes.CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚡ Прокачка активирована",
    Text = "Интерфейс успешно загружен. Всё работает плавно!",
    Duration = 5
})
