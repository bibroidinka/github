-- создание и присвоение базовых переменных
local player = game.Players
local localPlayer = player.LocalPlayer

local tweenService = game:GetService("TweenService") -- Получаем TweenService
local completed_tp = true

local module = {}

local Character = localPlayer.Character or localPlayer:WaitForChild("Character")
local Humanoid = Character:WaitForChild("Humanoid")

local tween

-- функция для передвижения игрока
function module.moveCharacter(character,x,y,z)
    local targetPosition = Vector3.new(x,y,z)
    CollisionPlayer(character,false)


    local root = character:WaitForChild("HumanoidRootPart")
    local tweenInfo = TweenInfo.new(14, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    tween = tweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPosition.X,targetPosition.Y + 30,targetPosition.Z)})
    tween:Play()
    completed_tp = false
    tween.Completed:Connect(function()
        completed_tp = true
        CollisionPlayer(character,true)
    end)
    module.tween = tween
end

function CollisionPlayer(character, cancollide)
        for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = cancollide
        end
    end
end

function module.Setup(Tp_button)
    Tp_button.MouseButton1Click:Connect(function()
        if completed_tp then
            module.moveCharacter(localPlayer.Character,0,100,5)
        else
            print("Вы еще не долетели до места")
        end
    end)
end

return module
