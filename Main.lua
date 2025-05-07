local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local screenui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenui.Name = "Zunesh Hub"

local CreateButton = require(script.UI.CreateButton)
local CreateLabel = require(script.UI.CreateLabel)
local ESP = require(script.Features.ESP)
local AutoFarm = require(script.Features.AutoFarm)
local BackpackViewer = require(script.Features.BackpackViewer)

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
		local ESP_Label = CreateLabel("ESP", UDim2.new(0,20,0,90), Frame)
		local ESP_Button = CreateButton("", UDim2.new(0,20,0,100), UDim2.new(0,40,0,40), Frame)

		local BP_Label = CreateLabel("Backpack Check", UDim2.new(0,20,0,140), Frame)
		local BP_Button = CreateButton("", UDim2.new(0,20,0,150), UDim2.new(0,40,0,40), Frame)

		local AF_Label = CreateLabel("AutoFarm", UDim2.new(0,20,0,190), Frame)
		local AF_Button = CreateButton("", UDim2.new(0,20,0,200), UDim2.new(0,40,0,40), Frame)

		-- Подключения
		ESP.Setup(ESP_Button)
		BackpackViewer.Setup(BP_Button, scrollingFrame)
		AutoFarm.Setup(AF_Button)
	else
		Frame:ClearAllChildren()
	end
end)
