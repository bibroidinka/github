-- backpackCheck.lua
local backpackCheck = {}

function backpackCheck.ToggleBackpackCheck()
    local Player = game.Players:GetPlayers()
    local player_name = ""
    for _, player in ipairs(Player) do
        player_name = player_name .. player.Name .. " Backpack\n"
        local backpack = player:FindFirstChild("Backpack") or player:WaitForChild("Backpack", 10)

        for _, tool in ipairs(backpack:GetChildren()) do
            player_name = player_name .. tool.Name .. "\n"
            if tool == nil then
                player_name = player_name .. "Unknow \n"
            end
        end
    end
    local labe = CreateLabel(player_name)
    scrollingFrame.Visible = true
end

return backpackCheck
