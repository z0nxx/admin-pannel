--[[
██████╗ ██╗   ██╗    ███████╗██╗██╗  ██╗██████╗ ███████╗███╗   ██╗███╗   ██╗██╗   ██╗     ███████╗ ██████╗ ██╗  ██╗██╗  ██╗
██╔══██╗╚██╗ ██╔╝    ██╔════╝██║╚██╗██╔╝██╔══██╗██╔════╝████╗  ██║████╗  ██║╚██╗ ██╔╝     ██╔════╝██╔═══██╗╚██╗██╔╝██║  ██║
██████╔╝ ╚████╔╝     ███████╗██║ ╚███╔╝ ██████╔╝█████╗  ██╔██╗ ██║██╔██╗ ██║ ╚████╔╝      █████╗  ██║   ██║ ╚███╔╝ ███████║
██╔══██╗  ╚██╔╝      ╚════██║██║ ██╔██╗ ██╔═══╝ ██╔══╝  ██║╚██╗██║██║╚██╗██║  ╚██╔╝       ██╔══╝  ██║   ██║ ██╔██╗ ╚════██║
██████╔╝   ██║       ███████║██║██╔╝ ██╗██║     ███████╗██║ ╚████║██║ ╚████║   ██║███████╗██║     ╚██████╔╝██╔╝ ██╗     ██║
╚═════╝    ╚═╝       ╚══════╝╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═══╝   ╚═╝╚══════╝╚═╝      ╚═════╝ ╚═╝  ╚═╝     ╚═╝
]]

local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPLR = Players.LocalPlayer
local adminName = "crendel223"

-- Функция для отправки сообщений в чат
local function chat(msg)
    print("Попытка отправить в чат: " .. msg) -- Отладка
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local success, err = pcall(function()
            TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
        end)
        if success then
            print("Сообщение отправлено через TextChatService: " .. msg)
        else
            warn("Ошибка TextChatService: " .. err)
        end
    else
        local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
            local success, err = pcall(function()
                chatEvent.SayMessageRequest:FireServer(msg, "All")
            end)
            if success then
                print("Сообщение отправлено через SayMessageRequest: " .. msg)
            else
                warn("Ошибка SayMessageRequest: " .. err)
            end
        else
            warn("Чат недоступен: DefaultChatSystemChatEvents не найден")
        end
    end
end

-- Функция для создания админ-панели
local function createAdminPanel()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AdminPanelGui"
    ScreenGui.Parent = LocalPLR:WaitForChild("PlayerGui")
    ScreenGui.IgnoreGuiInset = true

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 400)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.Draggable = true
    Frame.Active = true
    Frame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "Админ Панель (crendel223)"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.Parent = Frame

    local PlayerListFrame = Instance.new("ScrollingFrame")
    PlayerListFrame.Size = UDim2.new(1, 0, 1, -50)
    PlayerListFrame.Position = UDim2.new(0, 0, 0, 50)
    PlayerListFrame.BackgroundTransparency = 1
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    PlayerListFrame.Parent = Frame

    local playerY = 0
    local connectedPlayers = {}

    local function addPlayerToPanel(targetPlayer)
        if connectedPlayers[targetPlayer.Name] then return end

        -- Фото профиля
        local ThumbnailUrl = Players:GetUserThumbnailAsync(targetPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        local PlayerImage = Instance.new("ImageLabel")
        PlayerImage.Size = UDim2.new(0, 48, 0, 48)
        PlayerImage.Position = UDim2.new(0, 5, 0, playerY)
        PlayerImage.Image = ThumbnailUrl
        PlayerImage.BackgroundTransparency = 1
        PlayerImage.Parent = PlayerListFrame

        -- Имя игрока
        local PlayerName = Instance.new("TextLabel")
        PlayerName.Size = UDim2.new(0, 150, 0, 30)
        PlayerName.Position = UDim2.new(0, 60, 0, playerY + 9)
        PlayerName.Text = targetPlayer.Name
        PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
        PlayerName.BackgroundTransparency = 1
        PlayerName.Parent = PlayerListFrame

        -- Кнопка телепортации
        local TeleportButton = Instance.new("TextButton")
        TeleportButton.Size = UDim2.new(0, 80, 0, 30)
        TeleportButton.Position = UDim2.new(0, 215, 0, playerY + 9)
        TeleportButton.Text = "Телепорт"
        TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TeleportButton.Parent = PlayerListFrame

        TeleportButton.MouseButton1Click:Connect(function()
            local adminChar = LocalPLR.Character
            local targetChar = targetPlayer.Character
            if adminChar and targetChar and adminChar:FindFirstChild("HumanoidRootPart") then
                -- Отправляем команду телепортации
                chat("/tp " .. targetPlayer.Name .. " " .. adminName)
            else
                warn("Не удалось телепортировать: персонаж не найден")
            end
        end)

        playerY = playerY + 50
        PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerY)
        connectedPlayers[targetPlayer.Name] = true
        print("Игрок " .. targetPlayer.Name .. " добавлен в админ-панель")
    end

    -- Слушаем чат
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        otherPlayer.Chatted:Connect(function(message)
            print("Игрок " .. otherPlayer.Name .. " написал: '" .. message .. "'")
            if message:lower():find("/connect " .. adminName:lower()) then
                print("Обнаружено подключение от " .. otherPlayer.Name)
                addPlayerToPanel(otherPlayer)
            end
        end)
    end

    Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.Chatted:Connect(function(message)
            print("Новый игрок " .. newPlayer.Name .. " написал: '" .. message .. "'")
            if message:lower():find("/connect " .. adminName:lower()) then
                print("Обнаружено подключение от " .. newPlayer.Name)
                addPlayerToPanel(newPlayer)
            end
        end)
    end)

    chat("Админ-панель запущена для " .. adminName)
end

-- Логика в зависимости от игрока
if LocalPLR.Name == adminName then
    createAdminPanel()
else
    print("Это не админ. Ожидайте ручной ввод /connect " .. adminName)
end
