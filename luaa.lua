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



local scrollingFrame = Instance.new("ScrollingFrame", screenui)
scrollingFrame.Size = UDim2.new(0, 400, 0, 300)
scrollingFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 1000) -- вручную указываем большую высоту
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.Visible = false

function CreateLabel(text)
	local textLabel = Instance.new("TextLabel", scrollingFrame)
	textLabel.Size = UDim2.new(1, 0, 0, 1000) -- текст на всю CanvasSize
	textLabel.TextWrapped = true
	textLabel.TextYAlignment = Enum.TextYAlignment.Top
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text
	return textLabel
end


-- Кнопки
local ESP = CreateButton("ESP", UDim2.new(0, 20, 0, 100))
local ForPlayer = CreateButton("Backpack Check", UDim2.new(0, 20, 0, 150))
local TpNpc = CreateButton("Tp",UDim2.new(0,20,0,200))

local TpNpc_Click = false
local ESP_Click = false
local ForPlayer_click = false
local labe
--	 Тестирование: добавим несколько меток
ForPlayer.MouseButton1Click:Connect(function()
	if	ForPlayer_click == false then
		ForPlayer_click = true
		
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
		labe = CreateLabel(player_name)
		scrollingFrame.Visible = true
	else
		ForPlayer_click = false
		labe:Destroy()
		scrollingFrame.Visible = false
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

-- Переменные коннекторы
local con 
local conn
TpNpc.MouseButton1Click:Connect(function()
	local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	local RunService = game:GetService("RunService")

	-- Проверка наличия папки Enemies
	local enemiesFolder = workspace:FindFirstChild("Enemies")
	while not enemiesFolder do
		wait(0.1)
		enemiesFolder = workspace:FindFirstChild("Enemies")
	end

	if not TpNpc_Click then
		TpNpc_Click = true
		-- Устанавливаем коннектор
		con = RunService.RenderStepped:Connect(function()
			local npcPosition = FindNPC("Bandit")
			if npcPosition then
				humanoidRootPart.CFrame = CFrame.new(npcPosition.X, npcPosition.Y+25, npcPosition.Z)
			end
		end)
	else
		TpNpc_Click = false
		-- Проверяем, есть ли коннектор и отключаем его
		if con then
			con:Disconnect()
		end
	end
	conn = RunService.RenderStepped:Connect(function()
		local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Melee")
		if tool:IsA("Melee") then
			tool:Activate()
		end
		
	end)
end)
