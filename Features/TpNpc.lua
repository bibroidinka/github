-- создание и присвоение базовых переменных
local player = game.Players
local localPlayer = player.LocalPlayer

local tweenService = game:GetService("TweenService") -- Получаем TweenService
local completed_tp = true

local module = {}

local Character = localPlayer.Character or localPlayer:WaitForChild("Character")
local Humanoid = Character:WaitForChild("Humanoid")


-- функция для передвижения игрока
function moveCharacter(character,TargetPositiones)
    CollisionPlayer(character,false)


    local root = character:WaitForChild("HumanoidRootPart")
    local tweenInfo = TweenInfo.new(25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local targetPosition = Vector3.new(TargetPositiones)
    local tween = tweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    completed_tp = false
    tween.Completed:Connect(function()
        completed_tp = true
        CollisionPlayer(character,true)
    end)

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
            moveCharacter(localPlayer.Character,0,100,5)
        else
            print("Вы еще не долетели до места")
        end
    end)
end

return module
