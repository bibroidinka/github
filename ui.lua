local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local screenui = Instance.new("ScreenGui")
screenui.Name = "Zunesh Hub"
screenui.Parent = localPlayer:WaitForChild("PlayerGui")

local module = {}
module.ui = screenui
return module
