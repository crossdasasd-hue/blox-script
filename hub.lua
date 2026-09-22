-- Выводим стандартное системное уведомление Roblox (как ачивка)
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ Delta Hub: Blox Fruits",
        Text = "Скрипт успешно загружен и запущен!",
        Icon = "rbxassetid://6023426915", -- Иконка системного уведомления
        Duration = 6
    })
end)

-- Пытаемся загрузить графический интерфейс
local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/crossdasasd-hue/blox-script/main/hub.lua"))()
end)

if not success then
    print("Ошибка загрузки основного файла. Проверь ссылку.")
end
