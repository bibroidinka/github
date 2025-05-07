local players = game:GetService("Players")
local camera = workspace.CurrentCamera
local localPlayer = players.LocalPlayer
local drawings = {}

local module = {}

local function createESP(player)
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

local function removeESP(player)
	if drawings[player] then
		for _, drawing in ipairs(drawings[player]) do
			drawing:Remove()
		end
		drawings[player] = nil
	end
end

local playerAdded,playerRemove


function module.Setup(button)
	local isActive = false
	local runService = game:GetService("RunService")
	local renderConnection

	button.MouseButton1Click:Connect(function()

		if isActive == false then
			isActive = true
			button.Text = "✓"
			for _, p in ipairs(players:GetPlayers()) do createESP(p) end
			playerAdded = players.PlayerAdded:Connect(createESP)
			playerRemove = players.PlayerRemoving:Connect(removeESP)

			if renderConnection then renderConnection:Disconnect() end
			renderConnection = runService.RenderStepped:Connect(function()
				for player, drawingObjects in pairs(drawings) do
					local char = player.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						local pos, onScreen = camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
						local box, health = unpack(drawingObjects)
						box.Visible = onScreen
						health.Visible = onScreen
						if onScreen then
							box.Position = Vector2.new(pos.X, pos.Y - 20)
							health.Position = Vector2.new(pos.X, pos.Y + 20)
						end
					else
						for _, d in ipairs(drawingObjects) do d.Visible = false end
					end
				end
			end)
		else
			isActive = false
			button.Text = ""
			if playerAdded then playerAdded:Disconnect() end
			if playerRemove then playerRemove:Disconnect() end
			if renderConnection then renderConnection:Disconnect() end
			for _, p in ipairs(players:GetPlayers()) do removeESP(p) end
			table.clear(drawings)
		end
	end)
end

return module
