
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local module = {}

local drawings = {}
local Frame, scrollingFrame

function module.createButton(text, pos, size, parent)
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
    Button.Parent = parent
    return Button
end

function module.createLabel(text)
    local textLabel = Instance.new("TextLabel", scrollingFrame)
    textLabel.Size = UDim2.new(1, 0, 0, 1000)
    textLabel.TextWrapped = true
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    return textLabel
end

function module.findNPC(npcName)
    local NPC = workspace:WaitForChild("Enemies")
    for _, npc in ipairs(NPC:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.Position
        end
    end
    return nil
end

function module.createESP(player)
    if player == Players.LocalPlayer then return end

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

function module.removeESP(player)
    if drawings[player] then
        for _, drawing in ipairs(drawings[player]) do
            drawing:Remove()
        end
        drawings[player] = nil
    end
end

function module.init(screenui)
    Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.Position = UDim2.new(0.5, -250, 0.5, -250)
    Frame.Size = UDim2.new(0, 500, 0, 500)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.5
    Frame.Parent = screenui
    Frame.Visible = false

    scrollingFrame = Instance.new("ScrollingFrame", screenui)
    scrollingFrame.Size = UDim2.new(0, 400, 0, 300)
    scrollingFrame.Position = UDim2.new(0.5, -250, 0.5, -250)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
    scrollingFrame.ScrollBarThickness = 8
    scrollingFrame.Visible = false

    local mainButton = module.createButton("Zunesh Hub", UDim2.new(0, 20, 0, 50), UDim2.new(0, 40, 0, 40), screenui)
    local open = false

    mainButton.MouseButton1Click:Connect(function()
        open = not open
        Frame.Visible = open
    end)
end

return module
