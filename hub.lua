-- Защита от дублирования
if _G.QuantumGodHub then
    pcall(function() _G.QuantumGodHub:Destroy() end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")

-- Главный контейнер
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

-- ==================== ОСНОВНОЙ ХУД ====================
local W, H = 520, 380
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

-- Шапка (с поддержкой перетаскивания)
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
TitleLbl.Text = "⚡ Blox Fruits Noclip + Quest + Skill 1"
TitleLbl.TextColor3 = Color3.fromRGB(220, 200, 255)
TitleLbl.TextSize = 14
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.ZIndex = 6
TitleLbl.Parent = Header

-- Логика перетаскивания окна за шапку
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Card.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Card.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Контейнер для скролла
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 15, 0, 50)
ContentFrame.Size = UDim2.new(1, -30, 1, -60)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 550)
ContentFrame.ScrollBarThickness = 4
ContentFrame.ZIndex = 2
ContentFrame.Parent = Card

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = ContentFrame

-- Кнопки сворачивания и закрытия
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.BackgroundTransparency = 1
ToggleMenuBtn.Position = UDim2.new(1, -70, 0, 5)
ToggleMenuBtn.Size = UDim2.new(0, 30, 0, 30)
ToggleMenuBtn.Font = Enum.Font.GothamBold
ToggleMenuBtn.Text = "_"
ToggleMenuBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleMenuBtn.TextSize = 16
ToggleMenuBtn.ZIndex = 6
ToggleMenuBtn.Parent = Header

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

local menuVisible = true
ToggleMenuBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    ContentFrame.Visible = menuVisible
    Card.Size = menuVisible and UDim2.new(0, W, 0, H) or UDim2.new(0, W, 0, 40)
    ToggleMenuBtn.Text = menuVisible and "_" or "+"
end)

CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
    _G.QuantumGodHub = nil
end)

local Config = {
    AutoFarm = false,
    Noclip = false,
    AutoChest = false,
    AutoFruit = false,
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

-- ==================== СИСТЕМА КВЕСТОВ ПЕРВОГО МОРЯ ====================
local function GetQuestDetails()
    local success, lv = pcall(function() return LocalPlayer.Data.Level.Value end)
    if not success or not lv then return nil, nil, nil end

    if lv >= 1 and lv <= 9 then return "BanditQuest1", 1, "Bandit"
    elseif lv >= 10 and lv <= 14 then return "JungleQuest", 1, "Monkey"
    elseif lv >= 15 and lv <= 29 then return "JungleQuest", 2, "Gorilla"
    elseif lv >= 30 and lv <= 39 then return "BuggyQuest1", 1, "Pirate"
    elseif lv >= 40 and lv <= 59 then return "BuggyQuest1", 2, "Brute"
    elseif lv >= 60 and lv <= 74 then return "DesertQuest", 1, "Desert Bandit"
    elseif lv >= 75 and lv <= 89 then return "DesertQuest", 2, "Desert Officer"
    elseif lv >= 90 and lv <= 99 then return "SnowQuest", 1, "Snow Bandit"
    elseif lv >= 100 and lv <= 119 then return "SnowQuest", 2, "Snowman"
    else return "MarineQuest", 1, "Trainee" end
end

-- Проверка активного квеста через интерфейс игры
local function HasQuest()
    local success, val = pcall(function()
        local questFrame = LocalPlayer.PlayerGui.Main.Quest
        return questFrame.Visible
    end)
    return success and val or false
end

-- ==================== АВТОФАРМ (КВЕСТ + НОУКЛИП СВЕРХУ + СКИЛЛ 1 + УДАР) ====================
CreateToggle("Умный Авто-фарм (Noclip Сверху + Квест + Скилл 1)", false, function(state)
    Config.AutoFarm = state
    task.spawn(function()
        while Config.AutoFarm do
            task.wait(0.2)
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
                local hrp = char.HumanoidRootPart
                local humanoid = char.Humanoid

                -- 1. Берем квест, если его нет
                if not HasQuest() then
                    local qName, qId, _ = GetQuestDetails()
                    if qName and Remotes and Remotes:FindFirstChild("CommF_") then
                        Remotes.CommF_:InvokeServer("RequestQuest", qName, qId)
                        task.wait(0.6)
                    end
                end

                -- 2. Ищем моба
                local enemies = workspace:FindFirstChild("Enemies")
                local target = nil
                local _, _, targetName = GetQuestDetails()

                if enemies then
                    for _, enemy in pairs(enemies:GetChildren()) do
                        local eHum = enemy:FindFirstChild("Humanoid")
                        local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                        if eHum and eHrp and eHum.Health > 0 then
                            if not targetName or string.find(enemy.Name, targetName) then
                                target = enemy
                                break
                            end
                        end
                    end
                end

                -- 3. Если есть моб — зависаем над ним в NoClip и бьем (включая скилл 1)
                if target and target:FindFirstChild("HumanoidRootPart") then
                    local tHrp = target.HumanoidRootPart
                    
                    -- Отключаем гравитацию и падение, чтобы не падать на моба
                    humanoid.PlatformStand = true
                    
                    -- Фиксируем позицию строго сверху на высоте 15 блоков (полный Noclip-полёт)
                    hrp.CFrame = tHrp.CFrame * CFrame.new(0, 15, 0)
                    hrp.Velocity = Vector3.new(0, 0, 0)

                    -- Достаем оружие в руки
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

                    -- Атака (Клик + Скилл 1)
                    if tool then
                        tool:Activate()
                        -- Прожимаем навык/скилл "1"
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.One, false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.One, false, game)
                    end
                else
                    humanoid.PlatformStand = false
                end
            end)
        end
        -- Возвращаем нормальное состояние при выключении
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.PlatformStand = false
            end
        end)
    end)
end)

-- Глобальный Noclip (чтобы проходить сквозь стены)
CreateToggle("Анти-застревание (Noclip)", false, function(state)
    Config.Noclip = state
end)

RunService.Stepped:Connect(function()
    if (Config.Noclip or Config.AutoFarm) and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
                part.CanCollide = false 
            end
        end
    end
end)

-- Вспомогательные функции
CreateToggle("Авто-Хаки (Buso Haki)", false, function(state)
    Config.AutoBuso = state
    task.spawn(function()
        while Config.AutoBuso do
            task.wait(1.5)
            pcall(function()
                if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("Buso") and Remotes then
                    Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end)
end)

CreateToggle("Авто-сбор фруктов", false, function(state)
    Config.AutoFruit = state
    task.spawn(function()
        while Config.AutoFruit do
            task.wait(0.5)
            pcall(function()
                for _, item in pairs(workspace:GetChildren()) do
                    if not Config.AutoFruit then break end
                    if item:IsA("Tool") and item:FindFirstChild("Handle") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = item.Handle.CFrame
                    end
                end
            end)
        end
    end)
end)

CreateToggle("Авто-сбор сундуков", false, function(state)
    Config.AutoChest = state
    task.spawn(function()
        while Config.AutoChest do
            task.wait(0.4)
            pcall(function()
                for _, obj in pairs(workspace:GetChildren()) do
                    if not Config.AutoChest then break end
                    if string.find(obj.Name, "Chest") and obj:IsA("Part") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                    end
                end
            end)
        end
    end)
end)

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚡ God Mode Hub",
    Text = "Полет на ноуклипе сверху и авто-скилл 1 активированы!",
    Duration = 4
})
