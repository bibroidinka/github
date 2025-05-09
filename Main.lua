local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local screenui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenui.Name = "Zunesh Hub"

local CreateButton = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/UI/CreateButton.lua"))()
local CreateLabel = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/UI/CreateLabel.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/ESP.lua"))()
local AutoFarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/AutoFarm.lua"))()
local BackpackViewer = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/BackpackViewer.lua"))()
local TpNpc = loadstring(game:HttpGet(""))

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
local Button_Create = false

local ESP_Label,ESP_Button
local BP_Label,BP_Button
local AF_Label,AF_Button
local TPNPC_Label,TPNPC_Button

local Zunesh_hub_click = false
Zunesh_Hub.MouseButton1Click:Connect(function()
	Zunesh_hub_click = not Zunesh_hub_click
	Frame.Visible = Zunesh_hub_click

	if Zunesh_hub_click then
		if Button_Create == false then
			Button_Create = true
			-- Кнопки + ярлыки
			ESP_Label = CreateLabel("ESP", UDim2.new(0,0,0,0), Frame)
			ESP_Button = CreateButton("", UDim2.new(0,0,0,40), UDim2.new(0,40,0,40), Frame)

			BP_Label = CreateLabel("Backpack Check", UDim2.new(0,0,0,80), Frame)
			BP_Button = CreateButton("", UDim2.new(0,0,0,120), UDim2.new(0,40,0,40), Frame)

			AF_Label = CreateLabel("AutoFarm", UDim2.new(0,0,0,160), Frame)
			AF_Button = CreateButton("", UDim2.new(0,0,0,200), UDim2.new(0,40,0,40), Frame)

			TPNPC_Label = CreateLabel("TP",UDim2.new(0,0,0,240),Frame)
			TPNPC_Button = CreateButton("",UDim2.new(0,0,0,280),UDim2.new(0,40,0,40),Frame)
		end
		
		-- Подключения

		ESP.Setup(ESP_Button)
		TpNpc.Setup(TPNPC_Button)
		BackpackViewer.Setup(BP_Button, scrollingFrame)
		AutoFarm.Setup(AF_Button)
	else
		Frame.Visible = false
	end
end)
