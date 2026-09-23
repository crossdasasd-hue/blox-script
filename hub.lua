print("Шаг 1: Старт скрипта")

-- Проверяем скачивание Fluent UI
local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success or not Fluent then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Ошибка!",
        Text = "Не удалось скачать Fluent UI",
        Duration = 5
    })
    return
end

print("Шаг 2: Fluent UI скачан, создаем окно...")

-- Создаем окно
local Window = Fluent:Window({
    Title = "Blox Fruits | Test Hub",
    SubTitle = "Debug Mode",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 480),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Успех!",
    Text = "Окно создано!",
    Duration = 5
})

-- Добавляем одну вкладку для проверки
local Tabs = {
    Main = Window:AddTab({ Title = "Главная", Icon = "home" })
}

Tabs.Main:AddParagraph({
    Title = "Привет!",
    Content = "Если ты видишь этот текст, значит интерфейс полностью заработал."
})
