-- ui.lua
local ui = {}

local screenui = Instance.new("ScreenGui")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

screenui.Name = "Zunesh Hub"
screenui.Parent = localPlayer:WaitForChild("PlayerGui")

local Frame
local ESP
local ForPlayer
local AutoFarm
local Zunesh_hub_click = false

function ui.Initialize()
    Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.Position = UDim2.new(0.5, -250, 0.5, -250)
    Frame.Size = UDim2.new(0, 500, 0, 500)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.5
    Frame.Parent = screenui
    Frame.Visible = false
end

function ui.CreateButton(text, pos, size, parent)
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

function ui.ToggleFrame()
    if Zunesh_hub_click == false then
        Zunesh_hub_click = true
        Frame.Visible = true
        ESP = ui.CreateButton("ESP", UDim2.new(0, 20, 0, 100), UDim2.new(0, 150, 0, 40), Frame)
        ForPlayer = ui.CreateButton("Backpack Check", UDim2.new(0, 20, 0, 150), UDim2.new(0, 150, 0, 40), Frame)
        AutoFarm = ui.CreateButton("", UDim2.new(0, 20, 0, 200), UDim2.new(0, 40, 0, 40), Frame)
    else
        Zunesh_hub_click = false
        ESP:Destroy()
        ForPlayer:Destroy()
        AutoFarm:Destroy()
        ESP = nil
        ForPlayer = nil
        AutoFarm = nil
        Frame.Visible = false
    end
end

return ui
