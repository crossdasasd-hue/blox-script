-- Защита от дублирования
if _G.QuantumWorkingHub then
    pcall(function() _G.QuantumWorkingHub:Destroy() end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")

-- Главный контейнер
local SG = Instance.new("ScreenGui")
SG.Name = "QuantumWorkingHub"
SG.ZIndexBehavior = Enum.ZIndexBehavior.Global
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true

pcall(function()
    if gethui then SG.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(SG); SG.Parent = game:GetService("CoreGui")
    else SG.Parent = PlayerGui end
end)
if not SG.Parent then SG.Parent = PlayerGui end
_G.QuantumWorkingHub = SG

-- ==================== ПРИВЕТСТВИЕ (HELLO / ПРИВЕТ) ====================
local IntroGui = Instance.new("Frame")
IntroGui.Size = UDim2.new(1, 0, 1, 0)
IntroGui.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
IntroGui.ZIndex = 1000
IntroGui.Parent = SG

local HelloLbl = Instance.new("TextLabel")
HelloLbl.Size = UDim2.new(1, 0, 1, 0)
HelloLbl.BackgroundTransparency = 1
HelloLbl.Font = Enum.Font.GothamBold
HelloLbl.Text = "Hello / Привет"
HelloLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
HelloLbl.TextSize = 36
HelloLbl.TextTransparency = 1
HelloLbl.ZIndex = 1001
HelloLbl.Parent = IntroGui

task.spawn(function()
    TweenService:Create(HelloLbl, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    task.wait(1.5)
    TweenService:Create(HelloLbl, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(IntroGui, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    task.wait(0.8)
    IntroGui:Destroy()
end)

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

-- Шапка
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
TitleLbl.Text = "⚡ Blox Fruits Pro Hub"
TitleLbl.TextColor3 = Color3.fromRGB(220, 200, 255)
TitleLbl.TextSize = 14
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.ZIndex = 6
TitleLbl.Parent = Header

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
    _G.QuantumWorkingHub = nil
end)

local Config = {
    AutoFarm = false,
    Noclip = false,
    AutoChest = false,
    AutoFruit = false,
    AutoBuso = false,
    AutoStats = false,
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

-- ==================== ФУНКЦИИ ФАРМА И КВЕСТОВ ====================

-- Функция определения квеста по уровню
local function GetQuestDetails()
    local success, lv = pcall(function() return LocalPlayer.Data.Level.Value end)
    if not success or not lv then return nil, nil, nil end

    -- Примеры для 1-го моря (можно расширять)
    if lv >= 1 and lv <= 9 then
        return "BanditQuest1", 1, "Bandit"
    elseif lv >= 10 and lv <= 14 then
        return "JungleQuest", 1, "Monkey"
    elseif lv >= 15 and lv <= 29 then
        return "JungleQuest", 2, "Gorilla"
    elseif lv >= 30 and lv <= 39 then
        return "BuggyQuest1", 1, "Pirate"
    elseif lv >= 40 and lv <= 59 then
        return "BuggyQuest1", 2, "Brute"
    elseif lv >= 60 and lv <= 74 then
        return "DesertQuest", 1, "Desert Bandit"
    elseif lv >= 75 and lv <= 89 then
        return "DesertQuest", 2, "Desert Officer"
    elseif lv >= 90 and lv <= 99 then
        return "SnowQuest", 1, "Snow Bandit"
    elseif lv >= 100 and lv <= 119 then
        return "SnowQuest", 2, "Snowman"
    else
        -- Универсальный режим, если уровень выше
        return nil, nil, nil
    end
end

-- Авто-фарм с автоматическим взятием квестов и уроном по мобам
CreateToggle("Авто-фарм (Квесты + Урон)", false, function(state)
    Config.AutoFarm = state
    task.spawn(function()
        while Config.AutoFarm do
            task.wait(0.2)
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                -- Проверяем, есть ли активный квест на экране
                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                local hasActiveQuest = questGui and questGui.Visible

                local questName, questId, targetName = GetQuestDetails()

                if not hasActiveQuest and questName and Remotes and Remotes:FindFirstChild("CommF_") then
                    -- Берем квест автоматически
                    Remotes.CommF_:InvokeServer("RequestQuest", questName, questId)
                    task.wait(0.5)
                end

                -- Ищем нужного моба в папке Enemies
                local enemies = workspace:FindFirstChild("Enemies")
                local target = nil

                if enemies then
                    for _, enemy in pairs(enemies:GetChildren()) do
                        local eHum = enemy:FindFirstChild("Humanoid")
                        local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                        if eHum and eHrp and eHum.Health > 0 then
                            -- Если имя совпадает с целью квеста ИЛИ если квест не найден, берем любого живого
                            if not targetName or string.find(enemy.Name, targetName) then
                                target = enemy
                                break
                            end
                        end
                    end
                end

                -- Если моб найден — телепортируемся и бьем
                if target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("Humanoid") then
                    local tHrp = target.HumanoidRootPart
                    local tHum = target.Humanoid
                    
                    tHrp.CanCollide = false
                    tHum.WalkSpeed = 0
                    
                    -- Телепорт прямо над мобом
                    hrp.CFrame = tHrp.CFrame * CFrame.new(0, 10, 0)
                    
                    -- Авто-атака инструментом в руках
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end)
        end
    end)
end)

-- Остальные вспомогательные функции
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

CreateToggle("Авто-прокачка статов (Melee)", false, function(state)
    Config.AutoStats = state
    task.spawn(function()
        while Config.AutoStats do
            task.wait(2)
            pcall(function()
                if Remotes then
                    Remotes.CommF_:InvokeServer("AddPoint", "Melee", 3)
                end
            end)
        end
    end)
end)

CreateToggle("Анти-застревание (Noclip)", false, function(state)
    Config.Noclip = state
end)

RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚡ Pro Hub Updated",
    Text = "Система квестов и авто-фарма успешно обновлена!",
    Duration = 4
})
