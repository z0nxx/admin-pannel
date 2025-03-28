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

        -- Кнопка телепортации
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
            if adminChar and targetChar and adminChar:FindFirstChild("HumanoidRootPart") then
                -- Пробуем отправить команду через чат
                local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
                    chatEvent.SayMessageRequest:FireServer("/tp " .. targetPlayer.Name .. " " .. adminName, "All")
                    print("Команда телепортации отправлена: /tp " .. targetPlayer.Name .. " " .. adminName)
                else
                    warn("Чат недоступен, телепортация невозможна через сервер")
                    -- Визуальная телепортация как запасной вариант
                    targetChar.HumanoidRootPart.CFrame = adminChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    print("Игрок " .. targetPlayer.Name .. " телепортирован к админу (визуально)")
                end
            else
                warn("Не удалось телепортировать: персонаж не найден")
            end
        end)

        playerY = playerY + 50
        PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerY)
        connectedPlayers[targetPlayer.Name] = true
    end

    -- Слушаем чат с отладкой
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        otherPlayer.Chatted:Connect(function(message)
            print("Игрок " .. otherPlayer.Name .. " написал: " .. message)
            if message:find("/connect " .. adminName) then
                print("Обнаружено подключение от " .. otherPlayer.Name)
                addPlayerToPanel(otherPlayer)
            end
        end)
    end

    Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.Chatted:Connect(function(message)
            print("Новый игрок " .. newPlayer.Name .. " написал: " .. message)
            if message:find("/connect " .. adminName) then
                print("Обнаружено подключение от " .. newPlayer.Name)
                addPlayerToPanel(newPlayer)
            end
        end)
    end)
end

-- Логика в зависимости от игрока
if player.Name == adminName then
    createAdminPanel()
    print("Админ-панель запущена для " .. adminName)
else
    print("Это не админ. Ожидайте ручной ввод /connect " .. adminName)
end
