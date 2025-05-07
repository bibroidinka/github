-- esp.lua
local esp = {}

local drawings = {}
local camera = workspace.CurrentCamera
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

function esp.CreateESP(player)
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

function esp.RemoveESP(player)
    if drawings[player] then
        for _, drawing in ipairs(drawings[player]) do
            drawing:Remove()
        end
        drawings[player] = nil
    end
end

function esp.ToggleESP()
    for _, player in ipairs(players:GetPlayers()) do
        esp.CreateESP(player)
    end

    players.PlayerAdded:Connect(esp.CreateESP)
    players.PlayerRemoving:Connect(esp.RemoveESP)

    game:GetService("RunService").RenderStepped:Connect(function()
        for player, drawingObjects in pairs(drawings) do
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
                local box, health = unpack(drawingObjects)

                box.Visible = onScreen
                health.Visible = onScreen
                if onScreen then
                    box.Position = Vector2.new(pos.X, pos.Y - 20)
                    health.Position = Vector2.new(pos.X, pos.Y + 20)
                end
            else
                for _, drawing in ipairs(drawingObjects) do
                    drawing.Visible = false
                end
            end
        end
    end)
end

return esp
