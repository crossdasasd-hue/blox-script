-- Защита от повторного открытия
if _G.QuantumStyleHub then
    pcall(function() _G.QuantumStyleHub:Destroy() end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

-- Создаем главный контейнер (ScreenGui)
local SG = Instance.new("ScreenGui")
SG.Name = "QuantumStyleHub"
SG.ZIndexBehavior = Enum.ZIndexBehavior.Global
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true

-- Функция защиты от обнаружения / привязки к CoreGui (если поддерживает экзекутор)
pcall(function()
    if gethui then
        SG.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(SG)
        SG.Parent = game:GetService("CoreGui")
    else
        SG.Parent = CoreGui
    end
end)
if not SG.Parent then
    SG.Parent = PlayerGui
end
_G.QuantumStyleHub = SG

-- Затемнение фона
local Backdrop = Instance.new("Frame")
Backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Backdrop.BackgroundTransparency = 0.5
Backdrop.Size = UDim2.new(1, 0, 1, 0)
Backdrop.Parent = SG

-- Главное окно (в стиле Quantum Onyx: фиолетово-темные тона)
local W, H = 480, 320
local Card = Instance.new("Frame")
Card.AnchorPoint = Vector2.new(0.5, 0.5)
Card.Position = UDim2.new(0.5, 0, 0.5, 0)
Card.Size = UDim2.new(0, W, 0, H)
Card.BackgroundColor3 = Color3.fromRGB(15, 12, 24)
Card.ClipsDescendants = true
Card.Parent = SG

local CardCorner = Instance.new("UICorner")
CardCorner.CornerRadius = UDim.new(0, 12)
CardCorner.Parent = Card

local CardStroke = Instance.new("UIStroke")
CardStroke.Color = Color3.fromRGB(120, 60, 220)
CardStroke.Thickness = 1.5
CardStroke.Parent = Card

-- Шапка окна
local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(22, 16, 36)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Parent = Card

Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local TitleLbl = Instance.new("TextLabel")
TitleLbl.BackgroundTransparency = 1
TitleLbl.Position = UDim2.new(0, 15, 0, 0)
TitleLbl.Size = UDim2.new(1, -50, 1, 0)
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.Text = "⚡ Blox Fruits Hub — Delta Edition"
TitleLbl.TextColor3 = Color3.fromRGB(220, 200, 255)
TitleLbl.TextSize = 14
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.Parent = Header

-- Кнопка закрытия (крестик)
local CloseBtn = Instance.new("TextButton")
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 80, 80)
CloseBtn.TextSize = 16
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
    _G.QuantumStyleHub = nil
end)

-- Контейнер для кнопок функций
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 15, 0, 55)
ContentFrame.Size = UDim2.new(1, -30, 1, -65)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 250)
ContentFrame.ScrollBarThickness = 4
ContentFrame.Parent = Card

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 10)
UIList.Parent = ContentFrame

-- Функция создания красивой кнопки-переключателя (Toggle)
local function CreateToggle(titleText, callback)
    interpretorState = false
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
    ToggleBtn.Size = UDim2.new(1, 0, 0, 42)
    ToggleBtn.Font = Enum.Font.GothamMedium
    ToggleBtn.Text = "   " .. titleText .. ": [ ВЫКЛ ]"
    ToggleBtn.TextColor3 = Color3.fromRGB(200, 180, 240)
    ToggleBtn.TextSize = 12
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtn.Parent = ContentFrame
    
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(90, 40, 170)
    Stroke.Thickness = 1
    Stroke.Parent = ToggleBtn

    local active = false
    ToggleBtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            ToggleBtn.Text = "   " .. titleText .. ": [ ВКЛ ]"
            ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 140)
            Stroke.Color = Color3.fromRGB(80, 220, 110)
        else
            ToggleBtn.Text = "   " .. titleText .. ": [ ВЫКЛ ]"
            ToggleBtn.TextColor3 = Color3.fromRGB(200, 180, 240)
            Stroke.Color = Color3.fromRGB(90, 40, 170)
        end
        callback(active)
    end)
end

-- Добавляем нужные функции фарминга прямо в этот худ:
CreateToggle("Авто-фарм уровня и квестов", function(state)
    _G.AutoFarm = state
    task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.2)
            pcall(function()
                local enemies = workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, enemy in pairs(enemies:GetChildren()) do
                        if not _G.AutoFarm then break end
                        local hrp = enemy:FindFirstChild("HumanoidRootPart")
                        local hum = enemy:FindFirstChild("Humanoid")
                        if hrp and hum and hum.Health > 0 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 10, 0)
                            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end
                    end
                end
            end)
        end
    end)
end)

CreateToggle("Анти-застревание (Noclip)", function(state)
    _G.Noclip = state
end)

game:GetService("RunService").Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

CreateToggle("Авто-сбор сундуков", function(state)
    _G.AutoChest = state
    task.spawn(function()
        while _G.AutoChest do
            task.wait(0.3)
            pcall(function()
                for _, obj in pairs(workspace:GetChildren()) do
                    if not _G.AutoChest then break end
                    if string.find(obj.Name, "Chest") and obj:IsA("Part") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                    end
                end
            end)
        end
    end)
end)

-- Уведомление об успешном запуске
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Quantum HUD",
    Text = "Интерфейс успешно загружен!",
    Duration = 3
})
