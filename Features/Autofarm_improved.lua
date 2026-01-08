local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local TpNpc = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/TpNpc.lua"))()

local module = {}
local con
local attackCon
local isOn = false

-- Настройки
local ATTACK_DISTANCE = 15  -- Дистанция для начала атаки
local TP_HEIGHT = 30  -- Высота телепортации над NPC
local NPC_NAMES = {"Bandit", "Thief", "Enemy"}  -- Список имен NPC для фарма

-- Функция поиска ближайшего живого NPC
local function FindClosestNPC()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local myPos = char.HumanoidRootPart.Position
    local closestNPC = nil
    local closestDistance = math.huge
    
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then
        return nil
    end
    
    for _, npc in ipairs(enemiesFolder:GetChildren()) do
        -- Проверяем имя NPC
        local isValidName = false
        for _, validName in ipairs(NPC_NAMES) do
            if npc.Name == validName then
                isValidName = true
                break
            end
        end
        
        if isValidName then
            local humanoid = npc:FindFirstChild("Humanoid")
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            
            -- Проверяем что NPC жив и имеет нужные части
            if humanoid and hrp and humanoid.Health > 0 then
                local distance = (myPos - hrp.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestNPC = npc
                end
            end
        end
    end
    
    return closestNPC, closestDistance
end

-- Функция атаки NPC
local function AttackNPC(npc)
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Ищем оружие в рюкзаке или персонаже
    local tool = char:FindFirstChildOfClass("Tool")
    
    -- Если нет оружия в руках, берем из рюкзака
    if not tool then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            tool = backpack:FindFirstChildOfClass("Tool")
            if tool then
                humanoid:EquipTool(tool)
                task.wait(0.1)  -- Небольшая задержка для экипировки
            end
        end
    end
    
    -- Активируем оружие
    if tool then
        tool:Activate()
    end
    
    -- Альтернативный метод: используем встроенную атаку (для игр типа Combat Warriors)
    local combat = char:FindFirstChild("Combat")
    if combat then
        local clickEvent = combat:FindFirstChild("ClickEvent") or combat:FindFirstChild("Click")
        if clickEvent and clickEvent:IsA("RemoteEvent") then
            clickEvent:FireServer()
        end
    end
end

-- Основная функция фарма
local function FarmLoop()
    if not isOn then return end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local targetNPC, distance = FindClosestNPC()
    
    if targetNPC then
        local npcHRP = targetNPC:FindFirstChild("HumanoidRootPart")
        local npcHumanoid = targetNPC:FindFirstChild("Humanoid")
        
        if npcHRP and npcHumanoid and npcHumanoid.Health > 0 then
            -- Если далеко - телепортируемся
            if distance > ATTACK_DISTANCE then
                TpNpc.moveCharacter(char, npcHRP.Position.X, npcHRP.Position.Y, npcHRP.Position.Z)
            else
                -- Если близко - атакуем
                -- Останавливаем телепортацию если она идет
                if TpNpc.tween then
                    TpNpc.tween:Cancel()
                end
                
                -- Поворачиваемся к NPC
                local myHRP = char.HumanoidRootPart
                local lookVector = (npcHRP.Position - myHRP.Position).Unit
                myHRP.CFrame = CFrame.new(myHRP.Position, myHRP.Position + lookVector)
                
                -- Атакуем
                AttackNPC(targetNPC)
            end
        end
    else
        -- Если нет NPC поблизости, останавливаем телепортацию
        if TpNpc.tween then
            TpNpc.tween:Cancel()
        end
    end
end

function module.Setup(button)
    button.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        
        if not isOn then
            isOn = true
            button.Text = "✓"
            button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            
            -- Основной цикл фарма
            con = RunService.Heartbeat:Connect(function()
                FarmLoop()
            end)
            
            -- Дополнительный цикл для постоянной атаки (быстрее)
            attackCon = RunService.RenderStepped:Connect(function()
                if isOn then
                    local targetNPC, distance = FindClosestNPC()
                    if targetNPC and distance <= ATTACK_DISTANCE then
                        AttackNPC(targetNPC)
                    end
                end
            end)
            
            print("AutoFarm включен! Фармлю NPC: " .. table.concat(NPC_NAMES, ", "))
        else
            isOn = false
            button.Text = ""
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            
            -- Останавливаем телепортацию
            if TpNpc.tween then
                TpNpc.tween:Cancel()
            end
            
            -- Отключаем циклы
            if con then 
                con:Disconnect() 
                con = nil 
            end
            if attackCon then 
                attackCon:Disconnect() 
                attackCon = nil 
            end
            
            print("AutoFarm выключен!")
        end
    end)
end

-- Функция для добавления новых имен NPC
function module.AddNPCName(name)
    table.insert(NPC_NAMES, name)
end

-- Функция для установки списка имен NPC
function module.SetNPCNames(names)
    NPC_NAMES = names
end

return module