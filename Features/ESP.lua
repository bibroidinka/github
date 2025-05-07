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

local playerAdded, playerRemoved, renderConnection

function module.Setup(button)
	local isActive = false
	local runService = game:GetService("RunService")

	button.MouseButton1Click:Connect(function()
		if not isActive then
			isActive = true
			button.Text = "✓"

			-- Создаем ESP для всех игроков
			for _, p in ipairs(players:GetPlayers()) do createESP(p) end

			-- Подключаем события PlayerAdded и PlayerRemoving
			playerAdded = players.PlayerAdded:Connect(createESP)
			playerRemoved = players.PlayerRemoving:Connect(removeESP)

			-- Подключаем RenderStepped для отображения
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
			-- Отключаем ESP
			isActive = false
			button.Text = ""

			-- Отключаем события PlayerAdded и PlayerRemoving
			if playerAdded then 
				playerAdded:Disconnect() 
				print("Disconnecting PlayerAdded")
			end
			if playerRemoved then 
				playerRemoved:Disconnect() 
				print("Disconnecting PlayerRemoving")
			end

			-- Отключаем RenderStepped
			if renderConnection then 
				renderConnection:Disconnect() 
				print("Disconnecting RenderStepped")
			end

			-- Удаляем все объекты ESP
			for _, p in ipairs(players:GetPlayers()) do removeESP(p) end

			-- Очищаем таблицу drawings
			table.clear(drawings)
		end
	end)
end

return module
