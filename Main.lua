local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local screenui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenui.Name = "Zunesh Hub"
screenui.ResetOnSpawn = false

local CreateButton = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/UI/CreateButton.lua"))()
local CreateLabel = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/UI/CreateLabel.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/ESP.lua"))()
local AutoFarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/AutoFarm.lua"))()
local BackpackViewer = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/BackpackViewer.lua"))()
local TpNpc = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/TpNpc.lua"))()

-- UI элементы
local Frame = Instance.new("Frame")
Frame.Position = UDim2.new(0.5, -250, 0.5, -250)
Frame.Size = UDim2.new(0, 500, 0, 500)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
Frame.Parent = screenui
Frame.Visible = false

-- Заголовок Frame
local FrameTitle = Instance.new("TextLabel")
FrameTitle.Size = UDim2.new(1, 0, 0, 40)
FrameTitle.Position = UDim2.new(0, 0, 0, 0)
FrameTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FrameTitle.BackgroundTransparency = 0.3
FrameTitle.Text = "Zunesh Hub - Settings"
FrameTitle.TextColor3 = Color3.new(0, 1, 0)
FrameTitle.TextScaled = true
FrameTitle.Font = Enum.Font.GothamBold
FrameTitle.Parent = Frame

-- Кнопка закрытия
local CloseButton = CreateButton("X", UDim2.new(1, -45, 0, 5), UDim2.new(0, 35, 0, 30), Frame)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.TextColor3 = Color3.new(1, 1, 1)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(0, 400, 0, 300)
scrollingFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollingFrame.BackgroundTransparency = 0.3
scrollingFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
scrollingFrame.Visible = false
scrollingFrame.Parent = screenui

-- Кнопка открытия главного меню
local Zunesh_Hub = CreateButton("Zunesh Hub", UDim2.new(0, 20, 0, 50), UDim2.new(0, 100, 0, 40), screenui)
Zunesh_Hub.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
Zunesh_Hub.Font = Enum.Font.GothamBold

local Button_Create = false

local ESP_Label, ESP_Button
local BP_Label, BP_Button
local AF_Label, AF_Button
local TPNPC_Label, TPNPC_Button
local Settings_Label, Settings_Button

-- Настройки AutoFarm
local NPCInput, NPCAddButton, NPCListLabel

local Zunesh_hub_click = false
Zunesh_Hub.MouseButton1Click:Connect(function()
	Zunesh_hub_click = not Zunesh_hub_click
	Frame.Visible = Zunesh_hub_click

	if Zunesh_hub_click then
		if Button_Create == false then
			Button_Create = true
			
			local yOffset = 50  -- Начальная позиция Y (после заголовка)
			local buttonSpacing = 60  -- Расстояние между секциями
			
			-- ESP Section
			ESP_Label = CreateLabel("ESP (Player Wallhack)", UDim2.new(0, 10, 0, yOffset), Frame)
			ESP_Label.TextXAlignment = Enum.TextXAlignment.Left
			ESP_Label.TextColor3 = Color3.new(1, 1, 1)
			ESP_Button = CreateButton("", UDim2.new(1, -60, 0, yOffset), UDim2.new(0, 50, 0, 40), Frame)
			ESP_Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			yOffset = yOffset + buttonSpacing
			
			-- Backpack Viewer Section
			BP_Label = CreateLabel("Backpack Viewer", UDim2.new(0, 10, 0, yOffset), Frame)
			BP_Label.TextXAlignment = Enum.TextXAlignment.Left
			BP_Label.TextColor3 = Color3.new(1, 1, 1)
			BP_Button = CreateButton("", UDim2.new(1, -60, 0, yOffset), UDim2.new(0, 50, 0, 40), Frame)
			BP_Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			yOffset = yOffset + buttonSpacing
			
			-- AutoFarm Section
			AF_Label = CreateLabel("AutoFarm (Smart NPC Farm)", UDim2.new(0, 10, 0, yOffset), Frame)
			AF_Label.TextXAlignment = Enum.TextXAlignment.Left
			AF_Label.TextColor3 = Color3.new(1, 1, 1)
			AF_Button = CreateButton("", UDim2.new(1, -60, 0, yOffset), UDim2.new(0, 50, 0, 40), Frame)
			AF_Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			yOffset = yOffset + buttonSpacing
			
			-- TP Section
			TPNPC_Label = CreateLabel("Teleport (0, 100, 5)", UDim2.new(0, 10, 0, yOffset), Frame)
			TPNPC_Label.TextXAlignment = Enum.TextXAlignment.Left
			TPNPC_Label.TextColor3 = Color3.new(1, 1, 1)
			TPNPC_Button = CreateButton("", UDim2.new(1, -60, 0, yOffset), UDim2.new(0, 50, 0, 40), Frame)
			TPNPC_Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			yOffset = yOffset + buttonSpacing
			
			-- Settings Button
			Settings_Label = CreateLabel("AutoFarm Settings", UDim2.new(0, 10, 0, yOffset), Frame)
			Settings_Label.TextXAlignment = Enum.TextXAlignment.Left
			Settings_Label.TextColor3 = Color3.new(1, 1, 0)
			Settings_Button = CreateButton("⚙", UDim2.new(1, -60, 0, yOffset), UDim2.new(0, 50, 0, 40), Frame)
			Settings_Button.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
			Settings_Button.TextScaled = true
			yOffset = yOffset + buttonSpacing
			
			-- Информационная панель внизу
			local InfoLabel = Instance.new("TextLabel")
			InfoLabel.Size = UDim2.new(1, -20, 0, 60)
			InfoLabel.Position = UDim2.new(0, 10, 1, -70)
			InfoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			InfoLabel.BackgroundTransparency = 0.5
			InfoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
			InfoLabel.TextSize = 12
			InfoLabel.TextWrapped = true
			InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
			InfoLabel.Text = "ℹ️ AutoFarm: Automatically finds & attacks NPC\n💡 Tip: Configure NPC names in Settings"
			InfoLabel.Font = Enum.Font.Gotham
			InfoLabel.Parent = Frame
			
			-- Создание панели настроек AutoFarm
			local SettingsFrame = Instance.new("Frame")
			SettingsFrame.Size = UDim2.new(0, 450, 0, 400)
			SettingsFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
			SettingsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			SettingsFrame.BackgroundTransparency = 0.1
			SettingsFrame.BorderSizePixel = 3
			SettingsFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
			SettingsFrame.Visible = false
			SettingsFrame.Parent = screenui
			
			-- Заголовок настроек
			local SettingsTitle = Instance.new("TextLabel")
			SettingsTitle.Size = UDim2.new(1, 0, 0, 40)
			SettingsTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			SettingsTitle.BackgroundTransparency = 0.3
			SettingsTitle.Text = "AutoFarm Settings - NPC Names"
			SettingsTitle.TextColor3 = Color3.new(1, 1, 0)
			SettingsTitle.TextScaled = true
			SettingsTitle.Font = Enum.Font.GothamBold
			SettingsTitle.Parent = SettingsFrame
			
			-- Инструкция
			local InstructionLabel = Instance.new("TextLabel")
			InstructionLabel.Size = UDim2.new(1, -20, 0, 50)
			InstructionLabel.Position = UDim2.new(0, 10, 0, 50)
			InstructionLabel.BackgroundTransparency = 1
			InstructionLabel.TextColor3 = Color3.new(1, 1, 1)
			InstructionLabel.TextSize = 14
			InstructionLabel.TextWrapped = true
			InstructionLabel.TextYAlignment = Enum.TextYAlignment.Top
			InstructionLabel.Text = "Enter NPC names to farm. Add multiple names, one at a time."
			InstructionLabel.Font = Enum.Font.Gotham
			InstructionLabel.Parent = SettingsFrame
			
			-- Input для имени NPC
			NPCInput = Instance.new("TextBox")
			NPCInput.Size = UDim2.new(1, -120, 0, 40)
			NPCInput.Position = UDim2.new(0, 10, 0, 110)
			NPCInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			NPCInput.BorderColor3 = Color3.fromRGB(0, 200, 0)
			NPCInput.BorderSizePixel = 2
			NPCInput.TextColor3 = Color3.new(1, 1, 1)
			NPCInput.TextSize = 16
			NPCInput.PlaceholderText = "Enter NPC name (e.g., Bandit)"
			NPCInput.Text = ""
			NPCInput.Font = Enum.Font.Gotham
			NPCInput.Parent = SettingsFrame
			
			-- Кнопка добавления NPC
			NPCAddButton = CreateButton("+", UDim2.new(1, -100, 0, 110), UDim2.new(0, 80, 0, 40), SettingsFrame)
			NPCAddButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
			NPCAddButton.TextSize = 24
			NPCAddButton.Font = Enum.Font.GothamBold
			
			-- Список добавленных NPC
			NPCListLabel = Instance.new("TextLabel")
			NPCListLabel.Size = UDim2.new(1, -20, 0, 180)
			NPCListLabel.Position = UDim2.new(0, 10, 0, 160)
			NPCListLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			NPCListLabel.BackgroundTransparency = 0.5
			NPCListLabel.BorderColor3 = Color3.fromRGB(0, 150, 0)
			NPCListLabel.BorderSizePixel = 2
			NPCListLabel.TextColor3 = Color3.new(0, 1, 0)
			NPCListLabel.TextSize = 14
			NPCListLabel.TextWrapped = true
			NPCListLabel.TextYAlignment = Enum.TextYAlignment.Top
			NPCListLabel.TextXAlignment = Enum.TextXAlignment.Left
			NPCListLabel.Text = "Current NPCs:\n- Bandit (default)"
			NPCListLabel.Font = Enum.Font.Code
			NPCListLabel.Parent = SettingsFrame
			
			-- Кнопка закрытия настроек
			local SettingsCloseButton = CreateButton("Close", UDim2.new(0.5, -50, 1, -50), UDim2.new(0, 100, 0, 40), SettingsFrame)
			SettingsCloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
			
			SettingsCloseButton.MouseButton1Click:Connect(function()
				SettingsFrame.Visible = false
			end)
			
			-- Функция обновления списка NPC
			local function UpdateNPCList()
				local npcList = "Current NPCs:\n"
				-- Здесь нужно получить список из AutoFarm, но для простоты используем стандартный
				npcList = npcList .. "- Bandit\n"
				-- Можно расширить если AutoFarm.GetNPCNames() будет доступна
				NPCListLabel.Text = npcList
			end
			
			-- Обработка добавления NPC
			NPCAddButton.MouseButton1Click:Connect(function()
				local npcName = NPCInput.Text
				if npcName ~= "" then
					-- Добавляем NPC в AutoFarm
					if AutoFarm.AddNPCName then
						AutoFarm.AddNPCName(npcName)
						print("✅ Added NPC:", npcName)
						
						-- Обновляем список
						local currentText = NPCListLabel.Text
						NPCListLabel.Text = currentText .. "- " .. npcName .. "\n"
						
						NPCInput.Text = ""
						
						-- Визуальная обратная связь
						NPCAddButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
						wait(0.3)
						NPCAddButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
					else
						warn("⚠️ AutoFarm.AddNPCName() not available. Update your AutoFarm.lua!")
					end
				end
			end)
			
			-- Обработка нажатия Enter в текстовом поле
			NPCInput.FocusLost:Connect(function(enterPressed)
				if enterPressed and NPCInput.Text ~= "" then
					NPCAddButton.MouseButton1Click:Fire()
				end
			end)
			
			-- Обработчик кнопки Settings
			Settings_Button.MouseButton1Click:Connect(function()
				SettingsFrame.Visible = not SettingsFrame.Visible
			end)
		end
		
		-- Подключения модулей
		ESP.Setup(ESP_Button)
		TpNpc.Setup(TPNPC_Button)
		BackpackViewer.Setup(BP_Button, scrollingFrame)
		AutoFarm.Setup(AF_Button)
	else
		Frame.Visible = false
	end
end)

-- Обработчик кнопки закрытия
CloseButton.MouseButton1Click:Connect(function()
	Frame.Visible = false
	Zunesh_hub_click = false
end)

-- Функция для перетаскивания UI
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

FrameTitle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

FrameTitle.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

print("✅ Zunesh Hub loaded successfully!")
print("📌 Features: ESP, BackpackViewer, AutoFarm, TpNpc")
print("⚙️ Click 'Zunesh Hub' to open menu")
