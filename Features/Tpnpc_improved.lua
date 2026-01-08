-- создание и присвоение базовых переменных
local player = game.Players
local localPlayer = player.LocalPlayer

local tweenService = game:GetService("TweenService")
local completed_tp = true

local module = {}

local Character = localPlayer.Character or localPlayer:WaitForChild("Character")
local Humanoid = Character:WaitForChild("Humanoid")

module.tween = nil

-- Функция для отключения/включения коллизии персонажа
function module.SetCollision(character, cancollide)
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = cancollide
        end
    end
end

-- Основная функция для передвижения персонажа
function module.moveCharacter(character, x, y, z)
    local targetPosition = Vector3.new(x, y, z)
    module.SetCollision(character, false)

    local root = character:WaitForChild("HumanoidRootPart")
    
    -- Отменяем предыдущий tween если он существует
    if module.tween then
        module.tween:Cancel()
    end
    
    -- Вычисляем расстояние для динамического времени
    local distance = (root.Position - targetPosition).Magnitude
    local speed = 100  -- скорость в studs/сек
    local duration = math.max(0.5, distance / speed)  -- минимум 0.5 сек
    
    local tweenInfo = TweenInfo.new(
        duration, 
        Enum.EasingStyle.Sine, 
        Enum.EasingDirection.Out
    )
    
    -- Создаем и запускаем tween
    module.tween = tweenService:Create(
        root, 
        tweenInfo, 
        {CFrame = CFrame.new(targetPosition.X, targetPosition.Y + 5, targetPosition.Z)}
    )
    
    module.tween:Play()
    completed_tp = false
    
    module.tween.Completed:Connect(function()
        completed_tp = true
        module.SetCollision(character, true)
    end)
end

-- Мгновенная телепортация (для быстрого перемещения)
function module.instantTeleport(character, x, y, z)
    local root = character:WaitForChild("HumanoidRootPart")
    module.SetCollision(character, false)
    
    root.CFrame = CFrame.new(x, y, z)
    
    task.wait(0.1)
    module.SetCollision(character, true)
end

-- Проверка завершения телепортации
function module.isCompleted()
    return completed_tp
end

-- Отмена текущей телепортации
function module.cancelTeleport()
    if module.tween then
        module.tween:Cancel()
        completed_tp = true
        if localPlayer.Character then
            module.SetCollision(localPlayer.Character, true)
        end
    end
end

function module.Setup(Tp_button)
    Tp_button.MouseButton1Click:Connect(function()
        if completed_tp then
            module.moveCharacter(localPlayer.Character, 0, 100, 5)
        else
            print("Вы еще не долетели до места")
        end
    end)
end

return module