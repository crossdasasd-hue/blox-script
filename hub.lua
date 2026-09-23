-- Защита от дублирования
if _G.SimpleBloxFruitsHub then
    _G.SimpleBloxFruitsHub:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Создаем свой собственный графический интерфейс (HUD), который точно не зависнет
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleBloxFruitsHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
_G.SimpleBloxFruitsHub = ScreenGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 280)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "⚡ Delta Hub: Blox Fruits"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    _G.SimpleBloxFruitsHub = nil
end)

-- Кнопка Фарма Уровня
local FarmBtn = Instance.new("TextButton")
FarmBtn.Size = UDim2.new(0, 310, 0, 45)
FarmBtn.Position = UDim2.new(0, 20, 0, 60)
FarmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
FarmBtn.Text = "Авто-фарм уровня: ВЫКЛ"
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.TextSize, FarmBtn.Font = 14, Enum.Font.SourceSansBold
FarmBtn.Parent = MainFrame

Instance.new("UICorner", FarmBtn).CornerRadius = UDim.new(0, 6)

local farming = false
FarmBtn.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        FarmBtn.Text = "Авто-фарм уровня: ВКЛ"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        FarmBtn.Text = "Авто-фарм уровня: ВЫКЛ"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
    
    -- Логика фарма
    task.spawn(function()
        while farming do
            task.wait(0.2)
            pcall(function()
                local enemies = workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, enemy in pairs(enemies:GetChildren()) do
                        if not farming then break end
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

-- Кнопка Анти-застревания (Noclip)
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0, 310, 0, 45)
NoclipBtn.Position = UDim2.new(0, 20, 0, 120)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
NoclipBtn.Text = "Noclip (Сквозь стены): ВЫКЛ"
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipBtn.TextSize, NoclipBtn.Font = 14, Enum.Font.SourceSansBold
NoclipBtn.Parent = MainFrame

Instance.new("UICorner", NoclipBtn).CornerRadius = UDim.new(0, 6)

local noclipActive = false
NoclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    NoclipBtn.Text = noclipActive and "Noclip (Сквозь стены): ВКЛ" or "Noclip (Сквозь стены): ВЫКЛ"
    NoclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 100)
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Уведомление об успешном открытии
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚡ Delta Hub",
    Text = "Интерфейс успешно отрисован!",
    Duration = 3
})
