-- LocalScript для инжектора
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local adminName = "crendel223"

-- Функция для создания админ-панели
local function createAdminPanel()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AdminPanelGui"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

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

        -- Кнопка телепортации (только у админа)
        local TeleportButton = Instance.new("TextButton")
        TeleportButton.Size = UDim2.new(0, 80, 0, 30)
        TeleportButton.Position = UDim2.new(0, 215, 0, playerY + 9)
        TeleportButton.Text = "Телепорт"
        TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TeleportButton.Parent = PlayerListFrame

        TeleportButton.MouseButton1Click:Connect(function()
            local adminChar = player.Character
            local targetChar = targetPlayer.Character
            if adminChar and targetChar and adminChar:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
                -- Телепортируем игрока к админу
                targetChar.HumanoidRootPart.CFrame = adminChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5) -- Чуть впереди админа
                print("Игрок " .. targetPlayer.Name .. " телепортирован к админу")
            else
                warn("Не удалось телепортировать: персонаж не найден")
            end
        end)

        playerY = playerY + 50
        PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerY)
        connectedPlayers[targetPlayer.Name] = true
    end

    -- Слушаем чат
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        otherPlayer.Chatted:Connect(function(message)
            if message == "/connect " .. adminName then
                addPlayerToPanel(otherPlayer)
            end
        end)
    end

    Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.Chatted:Connect(function(message)
            if message == "/connect " .. adminName then
                addPlayerToPanel(newPlayer)
            end
        end)
    end)
end

-- Функция для отправки сообщения в чат
local function sendConnectMessage()
    print("Попытка отправить сообщение от " .. player.Name)
    local success, err = pcall(function()
        local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
            chatEvent.SayMessageRequest:FireServer("/connect " .. adminName, "All")
            print("Сообщение успешно отправлено: /connect " .. adminName)
        else
            warn("Чат недоступен, пробуем альтернативный метод")
            alternativeConnect()
        end
    end)
    if not success then
        warn("Ошибка при отправке: " .. err)
        alternativeConnect()
    end
end

-- Альтернативный метод через TextBox
local function alternativeConnect()
    print("Альтернативный метод для " .. player.Name)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 200, 0, 50)
    TextBox.Position = UDim2.new(0, 0, 0, 0)
    TextBox.Text = "/connect " .. adminName
    TextBox.Parent = ScreenGui
    
    TextBox:CaptureFocus()
    wait(0.1)
    TextBox.Text = "/connect " .. adminName
    local chatBar = player.PlayerGui:FindFirstChild("Chat") and player.PlayerGui.Chat:FindFirstChild("Frame") and player.PlayerGui.Chat.Frame:FindFirstChild("ChatBar")
    if chatBar then
        chatBar.Text = "/connect " .. adminName
        keypress(0x0D) -- Нажатие Enter
        wait(0.1)
        keyrelease(0x0D)
    end
    TextBox:ReleaseFocus()
    ScreenGui:Destroy()
end

-- Логика в зависимости от игрока
if player.Name == adminName then
    createAdminPanel()
    print("Админ-панель запущена для " .. adminName)
else
    sendConnectMessage()
end
