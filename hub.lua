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

-- Универсальный поиск Remotes в игре
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

-- ==================== ОСНОВНОЙ ИНТЕРФЕЙС ====================
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
TitleLbl.Text = "⚡ Blox Fruits Fix Hub (F9 для логов)"
TitleLbl.TextColor3 = Color3.fromRGB(220, 200, 255)
TitleLbl.TextSize = 13
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.ZIndex = 6
TitleLbl.Parent = Header

-- Перетаскивание окна
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

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

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

-- ==================== СИСТЕМА КВЕСТОВ (ПЕРВОЕ МОРЕ) ====================
local function GetQuestDetails()
    local success, lv = pcall(function() return LocalPlayer.Data.Level.Value end)
    if not success or not lv then return "BanditQuest1", 1, "Bandit" end

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

-- ==================== НАДЕЖНЫЙ АВТОФАРМ ====================
CreateToggle("Ультимативный Авто-Фарм", false, function(state)
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

                -- 2. Ищем строго нужного квестового моба
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

                -- 3. Если моб найден — телепортируемся над ним и бьем
                if target and target:FindFirstChild("HumanoidRootPart") then
                    local tHrp = target.HumanoidRootPart
                    
                    humanoid.PlatformStand = true
                    hrp.CFrame = tHrp.CFrame + Vector3.new(0, 15, 0)
                    hrp.Velocity = Vector3.new(0, 0, 0)

                    -- Берем инструмент в руки (если не взят)
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

                    -- Прямая активация оружия для нанесения урона
                    if tool then
                        pcall(function()
                            tool:Activate()
                        end)
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

-- Noclip для прохода сквозь стены
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
    Text = "Скрипт перезапущен с расширенным поиском Remotes!",
    Duration = 4
})
