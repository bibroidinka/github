local screenui = Instance.new("ScreenGui")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

screenui.Name = "Games"
screenui.Parent = localPlayer:WaitForChild("PlayerGui")

local drawings = {}
local NPC = workspace:WaitForChild("Enemies")

-- Функция поиска NPC
function FindNPC(npcName)
    for _, npc in ipairs(NPC:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.Position
        end
    end
    return nil
end

-- Функция создания ESP
function createESP(player)
    if player == localPlayer then return end

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    local box = Drawing.new("Text")
    box.Text = player.Name
    box.Size = 16
    box.Color = Color3.new(1, 1, 1)
    box.Center = true
    box.Outline = true
    box.Visible = false

    local health = Drawing.new("Text")
    health.Text = "Health: " .. tostring(humanoid.Health)
    health.Size = 11
    health.Color = Color3.new(1, 0, 0)
    health.Center = false
    health.Outline = true
    health.Visible = false

    drawings[player] = {box, health}

    humanoid.HealthChanged:Connect(function()
        health.Text = "Health: " .. tostring(humanoid.Health)
    end)
end

-- Удаление ESP
function removeESP(player)
    if drawings[player] then
        for _, drawing in ipairs(drawings[player]) do
            drawing:Remove()
        end
        drawings[player] = nil
    end
end

-- Создание кнопки
function CreateButton(text, pos)
    local Button = Instance.new("TextButton")
    Button.Name = text
    Button.Text = text
    Button.BackgroundTransparency = 0.3
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextScaled = true
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextStrokeColor3 = Color3.new(0, 0, 0)
    Button.TextStrokeTransparency = 0
    Button.Position = pos
    Button.Size = UDim2.new(0, 150, 0, 40)
    Button.Parent = screenui
    return Button
end

-- Создание ScrollFrame
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(0, 300, 0, 200)
scrollingFrame.Position = UDim2.new(0, 100, 0, 100)
scrollingFrame.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.Visible = false
scrollingFrame.BackgroundTransparency = 0

-- Функция для создания метки
function CreateLabel(text, pos)
    print("Creating label with text: " .. text)  -- Debugging line
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Text = text
    label.BackgroundTransparency = 0.3
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextSize = 18
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextWrapped = true
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = pos
    label.Size = UDim2.new(1, -10, 0, 0)
    label.Parent = scrollingFrame

    -- Подождать кадр для вычисления TextBounds
    task.wait()
    local neededHeight = label.TextBounds.Y
    print("TextBounds height: " .. tostring(neededHeight))  -- Debugging line
    label.Size = UDim2.new(1, -10, 0, neededHeight + 10)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, neededHeight + 20)  -- Обновляем размер CanvasSize

    return label
end

-- Кнопки
local ESP = CreateButton("ESP", UDim2.new(0, 20, 0, 100))
local ForPlayer = CreateButton("Backpack Check", UDim2.new(0, 20, 0, 150))
local TpNpc = CreateButton("Tp", UDim2.new(0, 20, 0, 200))

-- Обработчик для кнопки Backpack Check
ForPlayer.MouseButton1Click:Connect(function()
    local playersList = game.Players:GetPlayers()  -- Получаем список всех игроков
    local playerr = ""

    for _, player in ipairs(playersList) do
        playerr = playerr .. player.Name .. "'s Backpack:\n"

        -- Ждем, пока у игрока не будет рюкзака
        local backpack = player:FindFirstChild("Backpack") or player:WaitForChild("Backpack", 10)
        if backpack then
            -- Собираем все инструменты в рюкзаке
            local tools = {}
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    table.insert(tools, tool.Name)  -- Добавляем название инструмента в таблицу
                end
            end

            -- Если в рюкзаке есть инструменты
            if #tools > 0 then
                playerr = playerr .. table.concat(tools, "\n") .. "\n"
            else
                playerr = playerr .. "No Tools in Backpack\n"
            end
        else
            playerr = playerr .. "No Backpack found\n"
        end
    end

    -- Печать результатов для дебага
    print("Backpack details:\n" .. playerr)

    -- Создаем метку с текстом
    local labeloutput = CreateLabel(playerr, UDim2.new(0.5, 150, 0.5, 150))

    -- Делаем scrollingFrame видимым
    scrollingFrame.Visible = true

    -- Обновляем размер канвы, если текст слишком длинный
    task.wait(0.1)  -- Немного подождем, чтобы метка успела обновиться
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, labeloutput.TextBounds.Y + 20)  -- Устанавливаем размер канвы в зависимости от высоты текста

    -- Убираем метку через 90 секунд
    wait(90)
    scrollingFrame.Visible = false
    labeloutput:Destroy()
end)
