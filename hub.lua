-- Отладка загрузки
print("[Delta Hub] Запуск скрипта...")

-- Проверка доступности интернета и загрузки Fluent UI
local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success or not Fluent then
    warn("[Delta Hub] Ошибка: Не удалось загрузить библиотеку интерфейса Fluent UI!")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Delta Hub Error",
        Text = "Не удалось загрузить библиотеку интерфейса!",
        Duration = 5
    })
    return
end

print("[Delta Hub] Интерфейс успешно загружен, создаем окно...")

local SaveManager = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/InterfaceManager.lua"))()

local Window = Fluent:Window({
    Title = "Blox Fruits | Delta God Mode Hub",
    SubTitle = "v5.1 Debug Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 480),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Вкладки
local Tabs = {
    Main = Window:AddTab({ Title = "Фарм Уровней", Icon = "swords" }),
    Bosses = Window:AddTab({ Title = "Фарм Боссов", Icon = "skull" }),
    Items = Window:AddTab({ Title = "Фрукты / Сундуки", Icon = "package" }),
    Stats = Window:AddTab({ Title = "Статы & Прочее", Icon = "bar-chart-2" }),
    Teleport = Window:AddTab({ Title = "Телепорты", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Настройки / Меню", Icon = "settings" })
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Config = {
    AutoFarmLevel = false,
    AutoQuest = false,
    BringMobs = true,
    FastAttack = false,
    AutoBuso = true,
    Noclip = false,
    AutoBoss = false,
    SelectedBoss = "Darkbeard",
    AutoChest = false,
    AutoFruitCollect = false,
    SelectedStat = "Melee",
    AutoStat = false
}

function TpTo(CFramePos)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFramePos
        end
    end)
end

RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- 1. ФАРМ УРОВНЕЙ
Tabs.Main:AddToggle("AutoQuestToggle", {
    Title = "Авто-взятие квестов по уровню",
    Default = false,
    Callback = function(Value) Config.AutoQuest = Value end
})

Tabs.Main:AddToggle("AutoFarmLevelToggle", {
    Title = "Авто-фарм уровня (Универсальный)",
    Default = false,
    Callback = function(Value)
        Config.AutoFarmLevel = Value
        task.spawn(function()
            while Config.AutoFarmLevel do
                task.wait(0.1)
                pcall(function()
                    if Config.AutoQuest then
                        local questGui = LocalPlayer.PlayerGui.Main.Quest
                        if not questGui.Visible then
                            Remotes.CommF_:InvokeServer("RequestQuest")
                        end
                    end
                    local enemiesFolder = Workspace:FindFirstChild("Enemies")
                    if enemiesFolder then
                        for _, enemy in pairs(enemiesFolder:GetChildren()) do
                            if not Config.AutoFarmLevel then break end
                            local hum = enemy:FindFirstChild("Humanoid")
                            local hrp = enemy:FindFirstChild("HumanoidRootPart")
                            if hum and hrp and hum.Health > 0 then
                                if Config.BringMobs then
                                    hrp.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                                    hrp.CanCollide = false
                                    hum.WalkSpeed = 0
                                end
                                TpTo(hrp.CFrame * CFrame.new(0, 12, 3))
                                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                if tool and tool:FindFirstChild("Handle") then
                                    tool:Activate()
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
})

Tabs.Main:AddToggle("BringMobsToggle", {
    Title = "Сбор мобов (Bring Mobs)",
    Default = true,
    Callback = function(Value) Config.BringMobs = Value end
})

Tabs.Main:AddToggle("NoclipToggle", {
    Title = "Анти-застревание (Noclip)",
    Default = false,
    Callback = function(Value) Config.Noclip = Value end
})

Tabs.Main:AddToggle("AutoBusoToggle", {
    Title = "Авто-Хаки (Buso Haki)",
    Default = true,
    Callback = function(Value)
        Config.AutoBuso = Value
        task.spawn(function()
            while Config.AutoBuso do
                task.wait(1)
                pcall(function()
                    if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("Buso") then
                        Remotes.CommF_:InvokeServer("Buso")
                    end
                end)
            end
        end)
    end
})

-- 2. ФАРМ БОССОВ
local BossList = {"Darkbeard", "Cursed Captain", "Order", "rip_indra", "Dough King", "Beautiful Pirate", "Cake Prince"}
Tabs.Bosses:AddDropdown("BossDropdown", {
    Title = "Выбрать босса",
    Values = BossList,
    Default = 1,
    Callback = function(Value) Config.SelectedBoss = Value end
})

Tabs.Bosses:AddToggle("AutoBossToggle", {
    Title = "Авто-фарм выбранного босса",
    Default = false,
    Callback = function(Value)
        Config.AutoBoss = Value
        task.spawn(function()
            while Config.AutoBoss do
                task.wait(0.3)
                pcall(function()
                    local target = Workspace.Enemies:FindFirstChild(Config.SelectedBoss)
                    if target and target:FindFirstChild("HumanoidRootPart") and target.Humanoid.Health > 0 then
                        TpTo(target.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    else
                        task.wait(3)
                    end
                end)
            end
        end)
    end
})

-- 3. СУНДУКИ И ФРУКТЫ
Tabs.Items:AddToggle("AutoChestToggle", {
    Title = "Авто-сбор сундуков",
    Default = false,
    Callback = function(Value)
        Config.AutoChest = Value
        task.spawn(function()
            while Config.AutoChest do
                task.wait(0.2)
                pcall(function()
                    for _, obj in pairs(Workspace:GetChildren()) do
                        if string.find(obj.Name, "Chest") and obj:IsA("Part") then
                            TpTo(obj.CFrame)
                        end
                    end
                end)
            end
        end)
    end
})

Tabs.Items:AddToggle("AutoFruitCollect", {
    Title = "Авто-сбор упавших фруктов",
    Default = false,
    Callback = function(Value)
        Config.AutoFruitCollect = Value
        task.spawn(function()
            while Config.AutoFruitCollect do
                task.wait(0.5)
                pcall(function()
                    for _, item in pairs(Workspace:GetChildren()) do
                        if item:IsA("Tool") and item:FindFirstChild("Handle") then
                            TpTo(item.Handle.CFrame)
                        end
                    end
                end)
            end
        end)
    end
})

-- 4. НАСТРОЙКИ
Tabs.Settings:AddButton({
    Title = "Выгрузить скрипт",
    Callback = function()
        Config.AutoFarmLevel = false
        Config.AutoBoss = false
        Config.AutoChest = false
        Config.AutoFruitCollect = false
        Config.Noclip = false
        Fluent:Destroy()
    end
})

Fluent:Notify({
    Title = "Delta Hub Debug",
    Content = "Скрипт успешно отработал и запущен!",
    Duration = 5
})

print("[Delta Hub] Инициализация завершена успешно.")
SaveManager:LoadAutoloadConfig()
