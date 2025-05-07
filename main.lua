-- main.lua
local ui = require(game:GetService("ReplicatedStorage"):WaitForChild("ZuneshHub"):WaitForChild("ui"))
local esp = require(game:GetService("ReplicatedStorage"):WaitForChild("ZuneshHub"):WaitForChild("esp"))
local autofarm = require(game:GetService("ReplicatedStorage"):WaitForChild("ZuneshHub"):WaitForChild("autofarm"))
local backpackCheck = require(game:GetService("ReplicatedStorage"):WaitForChild("ZuneshHub"):WaitForChild("backpackCheck"))

ui.Initialize()

local Zunesh_Hub = ui.CreateButton("Zunesh Hub", UDim2.new(0,20,0,50), UDim2.new(0, 40, 0, 40))

Zunesh_Hub.MouseButton1Click:Connect(function()
    ui.ToggleFrame()
    esp.ToggleESP()
    autofarm.ToggleAutoFarm()
    backpackCheck.ToggleBackpackCheck()
end)
