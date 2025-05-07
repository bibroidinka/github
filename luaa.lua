local screenui = Instance.new("ScreenGui")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

screenui.Name = "Zunesh Hub"
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

function CreateButton(text, pos,size,parent)
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
	Button.Size = size
	Button.Parent = parent or screenui
	return Button
end

local Frame = Instance.new("Frame")
Frame.Name = "Frame"
Frame.Position = UDim2.new(0.5, -250, 0.5, -250)
Frame.Size = UDim2.new(0, 500, 0, 500)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.5
Frame.Parent = screenui
Frame.Visible = false


local scrollingFrame = Instance.new("ScrollingFrame", screenui)
scrollingFrame.Size = UDim2.new(0, 400, 0, 300)
scrollingFrame.Position = UDim2.new(0.5, -250, 0.5, -250)
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

local Zunesh_Hub = CreateButton("Zunesh Hub", UDim2.new(0,20,0,50), UDim2.new(0, 40, 0, 40),screenui)


local Zunesh_hub_click = false
local TpNpc_Click = false
local ESP_Click = false
local ForPlayer_click = false

local ESP 
local ForPlayer
local AutoFarm

Zunesh_Hub.MouseButton1Click:Connect(function()
	if Zunesh_hub_click == false then
		Zunesh_hub_click = true
		
		Frame.Visible = true
		ESP = CreateButton("ESP", UDim2.new(0, 20, 0, 100),UDim2.new(0, 150, 0, 40),Frame)
		ForPlayer = CreateButton("Backpack Check", UDim2.new(0, 20, 0, 150),UDim2.new(0, 150, 0, 40),Frame)
		AutoFarm = CreateButton("",UDim2.new(0,20,0,200),UDim2.new(0, 40, 0, 40),Frame)
		
		local labe = nil
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
				if labe then
					labe:Destroy()
					labe = nil
				end
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
		AutoFarm.MouseButton1Click:Connect(function()
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
				AutoFarm.Text = "✓"
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
				AutoFarm.Text = ""
				-- Проверяем, есть ли коннектор и отключаем его
				if con then
					con:Disconnect()
					con = nil
				end
			end
		end)

		
	else
		Zunesh_hub_click = false
		if ESP and ForPlayer and AutoFarm then
			ESP:Destroy()
			ForPlayer:Destroy()
			AutoFarm:Destroy()
			ESP = nil
			ForPlayer = nil
			AutoFarm = nil
		end
		Frame.Visible = false
	end
end)

