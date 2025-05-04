local screenui = Instance.new("ScreenGui")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

screenui.Name = "MyCheatUI"
screenui.Parent = localPlayer:WaitForChild("PlayerGui")

local drawings = {}
local NPC = workspace:WaitForChild("Enemies")
function FindNPC(npcName)
	for _, npc in ipairs(NPC:GetChildren()) do
		if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
			return npc.HumanoidRootPart.Position
		end
	end
	return nil
end
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
	
function removeESP(player)
	if drawings[player] then
		for _, drawing in ipairs(drawings[player]) do
			drawing:Remove()
		end
		drawings[player] = nil
	end
end

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

-- Кнопки
local ESP = CreateButton("ESP", UDim2.new(0, 20, 0, 100))
local ForPlayer = CreateButton("Backpack Check", UDim2.new(0, 20, 0, 150))
local TpNpc = CreateButton("Tp",UDim2.new(0,20,0,200))

local TpNpc_Click = false
local ESP_Click = false

ForPlayer.MouseButton1Click:Connect(function()
	
	local playersList = game.Players:GetPlayers()  -- Получаем список всех игроков
	for _, player in ipairs(playersList) do
		print(player.Name .. "'s Backpack contents:")
		for _, tool in ipairs(player.Backpack:GetChildren()) do  -- Перебор предметов в рюкзаке
			print(" - " .. tool.Name)  -- Печатаем имя предмета
		end
	end
	
end)

-- Подключение ESP
ESP.MouseButton1Click:Connect(function()
	if ESP_Click == false then
		ESP_Click = true
		for _, player in ipairs(players:GetPlayers()) do
			createESP(player)
		end

		players.PlayerAdded:Connect(createESP)
		players.PlayerRemoving:Connect(removeESP)

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
	else 
		ESP_Click = false
		for _, player in ipairs(players:GetPlayers()) do
			removeESP(player)
		end
		drawings = {}
	end

end)

TpNpc.MouseButton1Click:Connect(function()
	local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	
	-- Проверка наличия папки Enemies
	local enemiesFolder = workspace:FindFirstChild("Enemies")
	while not enemiesFolder do
		wait(0.1)
		enemiesFolder = workspace:FindFirstChild("Enemies")
	end
	if TpNpc_Click == false then
		TpNpc_Click = true
		game:GetService("RunService").RenderStepped:Connect(function()

			local npcPosition = FindNPC("Bandit")
			humanoidRootPart.CFrame = CFrame.new(npcPosition.X, npcPosition.Y+10,npcPosition.Z)
		end)
	else 
		TpNpc_Click = false
	end
end)
