local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local screenui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenui.Name = "Zunesh Hub"

local CreateButton = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/UI/CreateButton.lua"))()
local CreateLabel = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/UI/CreateLabel.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/ESP.lua"))()
local AutoFarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/AutoFarm.lua"))()
local BackpackViewer = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/BackpackViewer.lua"))()

-- UI элементы
local Frame = Instance.new("Frame")
Frame.Position = UDim2.new(0.5, -250, 0.5, -250)
Frame.Size = UDim2.new(0, 500, 0, 500)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.5
Frame.Parent = screenui
Frame.Visible = false

local scrollingFrame = Instance.new("ScrollingFrame", screenui)
scrollingFrame.Size = UDim2.new(0, 400, 0, 300)
scrollingFrame.Position = UDim2.new(0.5, -250, 0.5, -250)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.Visible = false

-- Кнопка открытия
local Zunesh_Hub = CreateButton("Zunesh Hub", UDim2.new(0,20,0,50), UDim2.new(0, 40, 0, 40), screenui)

local Zunesh_hub_click = false
Zunesh_Hub.MouseButton1Click:Connect(function()
	Zunesh_hub_click = not Zunesh_hub_click
	Frame.Visible = Zunesh_hub_click

	if Zunesh_hub_click then
		-- Кнопки + ярлыки
		local ESP_Label = CreateLabel("ESP", UDim2.new(0,0,0,0), Frame)
		local ESP_Button = CreateButton("", UDim2.new(0,0,0,30), UDim2.new(0,40,0,40), Frame)

		local BP_Label = CreateLabel("Backpack Check", UDim2.new(0,0,0,60), Frame)
		local BP_Button = CreateButton("", UDim2.new(0,0,0,90), UDim2.new(0,40,0,40), Frame)

		local AF_Label = CreateLabel("AutoFarm", UDim2.new(0,0,0,120), Frame)
		local AF_Button = CreateButton("", UDim2.new(0,0,0,150), UDim2.new(0,40,0,40), Frame)

		-- Подключения
		ESP.Setup(ESP_Button)
		BackpackViewer.Setup(BP_Button, scrollingFrame)
		AutoFarm.Setup(AF_Button)
	else
		Frame:ClearAllChildren()
	end
end)
