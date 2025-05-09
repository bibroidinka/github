local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")

local LocalPlayer = game.Players.LocalPlayer

local TpNpc = loadstring(game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/Features/TpNpc.lua"))()

local module = {}
local con

local function FindNPC(npcName)
	local NPC = workspace:WaitForChild("Enemies")
	for _, npc in ipairs(NPC:GetChildren()) do
		if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
			return npc.HumanoidRootPart.Position
		end
	end
	return nil
end

function module.Setup(button)
	local isOn = false
	button.MouseButton1Click:Connect(function()
		local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
		local root = char:WaitForChild("HumanoidRootPart")
		if not isOn then
			isOn = true
			button.Text = "✓"
			con = RunService.RenderStepped:Connect(function()
				local npcPos = FindNPC("Bandit")
				if npcPos then
					TpNpc.moveCharacter(LocalPlayer.Character,npcPos)
				end
			end)
		else
			isOn = false
			button.Text = ""
			if con then con:Disconnect() con = nil end
		end
	end)
end

return module
