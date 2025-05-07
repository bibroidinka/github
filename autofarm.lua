-- autofarm.lua
local autofarm = {}

local TpNpc_Click = false

function autofarm.FindNPC(npcName)
    local NPC = workspace:WaitForChild("Enemies")
    for _, npc in ipairs(NPC:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.Position
        end
    end
    return nil
end

function autofarm.ToggleAutoFarm()
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local RunService = game:GetService("RunService")

    if not TpNpc_Click then
        TpNpc_Click = true
        -- Start autofarm
        local con = RunService.RenderStepped:Connect(function()
            local npcPosition = autofarm.FindNPC("Bandit")
            if npcPosition then
                humanoidRootPart.CFrame = CFrame.new(npcPosition.X, npcPosition.Y + 25, npcPosition.Z)
            end
        end)
    else
        TpNpc_Click = false
        -- Stop autofarm
    end
end

return autofarm
