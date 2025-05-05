local screenui = Instance.new("ScreenGui")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

screenui.Name = "Games"
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

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(0, 300, 0, 200)
scrollingFrame.CanvasSize = UDim2.new(0, 101, 0, 101) -- позже обновим
scrollingFrame.Position = UDim2.new(0, 100, 0, 100)
scrollingFrame.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.Parent = screenui
scrollingFrame.Visible = false
scrollingFrame.BackgroundTransparency = 0

--окно вывода
function CreateLabel(text, pos)
	
	local label = Instance.new("TextLabel")
	label.Name = text
	label.Text = text
	label.BackgroundTransparency = 0.3
	label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	label.TextScaled = false
	label.TextSize = 18
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0
	label.Position = UDim2.new(0, 0, 0, 0)
	label.Size = UDim2.new(1, -10, 0, 0) -- ширина от прокрутки, высоту выставим ниже
	label.TextWrapped = true
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.SourceSans
	label.Parent = scrollingFrame

	-- Ждём один кадр, чтобы TextBounds успел рассчитаться
	task.wait()
	local neededHeight = label.TextBounds.Y
	label.Size = UDim2.new(1, -10, 0, neededHeight + 10)
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, neededHeight + 20)

	return label
end


-- Кнопки
local ESP = CreateButton("ESP", UDim2.new(0, 20, 0, 100))	
local ForPlayer = CreateButton("Backpack Check", UDim2.new(0, 20, 0, 150))
local TpNpc = CreateButton("Tp",UDim2.new(0,20,0,200))

local TpNpc_Click = false
local ESP_Click = false

ForPlayer.MouseButton1Click:Connect(function()
	local playersList = game.Players:GetPlayers()  -- Получаем список всех игроков
	local playerr = ""

	for _, player in ipairs(playersList) do
		playerr = playerr .. player.Name .. "'s Backpack:\n"

		-- Ждем, пока у игрока не будет рюкзака, если его нет
		local backpack = player:WaitForChild("Backpack", 10)  -- Подождем 10 секунд, если не найдем рюкзак
		if backpack then
			-- Собираем все инструменты в рюкзаке
			local tools = {}
			for _, tool in ipairs(backpack:GetChildren()) do
				-- Проверка, что это действительно инструмент
				if tool:IsA("Tool") then
					table.insert(tools, tool.Name)  -- Добавляем название инструмента в таблицу
				end
			end
			-- Если в рюкзаке есть инструменты
			if #tools > 0 then
				playerr = playerr .. table.concat(tools, "\n") .. "\n"
			else
				playerr = playerr .. "No Tools in Backpack\n"
			end
		else
			playerr = playerr .. "No Backpack found\n"
		end
	end

	-- Печать результатов или использование для вывода на экран
	print(playerr)

	
	local labeloutput = CreateLabel(playerr,UDim2.new(0.5,150,0.5,150))
	scrollingFrame.Visible = true
	
	wait(90)
	scrollingFrame.Visible = false
	labeloutput:Destroy()
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

local con -- Инициализация переменной коннектора
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
