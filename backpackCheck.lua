-- backpackCheck.lua
local backpackCheck = {}

-- Создание UI элементов
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local screenui = localPlayer:WaitForChild("PlayerGui")

local scrollingFrame
local label

-- Функция для создания лейбла
function CreateLabel(text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 300, 0, 200)
	label.Position = UDim2.new(0, 10, 0, 10)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 14
	label.Text = text
	label.Parent = scrollingFrame
	return label
end

-- Создание scrollingFrame
local function CreateScrollingFrame()
	scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Size = UDim2.new(0, 300, 0, 200)
	scrollingFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
	scrollingFrame.BackgroundTransparency = 0.5
	scrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	scrollingFrame.ScrollBarThickness = 12
	scrollingFrame.Visible = false
	scrollingFrame.Parent = screenui
end

-- Функция для включения проверки рюкзаков
function backpackCheck.ToggleBackpackCheck()
	-- Проверка наличия scrollingFrame и создание, если его нет
	if not scrollingFrame then
		CreateScrollingFrame()
	end

	local player_name = ""

	-- Проходим по всем игрокам
	for _, player in ipairs(players:GetPlayers()) do
		player_name = player_name .. player.Name .. " Backpack\n"

		-- Находим рюкзак игрока
		local backpack = player:FindFirstChild("Backpack") or player:WaitForChild("Backpack", 10)

		-- Если рюкзак найден, перебираем все предметы в рюкзаке
		if backpack then
			for _, tool in ipairs(backpack:GetChildren()) do
				player_name = player_name .. tool.Name .. "\n"
			end
		else
			-- Если рюкзак не найден, отображаем "Unknown"
			player_name = player_name .. "No Backpack\n"
		end
	end

	-- Создаем или обновляем лейбл с информацией о рюкзаках
	if label then
		label.Text = player_name
	else
		label = CreateLabel(player_name)
	end

	-- Показываем scrollingFrame
	scrollingFrame.Visible = true
end

function RemoveFrame()
	label:Destroy()
	scrollingFrame.Visible = false
end

return backpackCheck
