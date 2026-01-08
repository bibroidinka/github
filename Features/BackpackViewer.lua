local players = game:GetService("Players")

local module = {}

function module.Setup(button, scrollFrame)
	local active = false
	local label

	button.MouseButton1Click:Connect(function()
		active = not active
		button.Text = active and "✓" or ""

		if active then
			local text = ""
			for _, player in ipairs(players:GetPlayers()) do
				text = text .. player.Name .. " Backpack\n"
				local backpack = player:FindFirstChild("Backpack") or player:WaitForChild("Backpack")
				for _, item in ipairs(backpack:GetChildren()) do
					text = text .. (item.Name or "Unknown") .. "\n"
				end
			end
			label = Instance.new("TextLabel", scrollFrame)
			label.Size = UDim2.new(1, 0, 0, 1000)
			label.TextWrapped = true
			label.TextYAlignment = Enum.TextYAlignment.Top
			label.BackgroundTransparency = 1
			label.Text = text
			scrollFrame.Visible = true

			task.delay(20, function()
				if label then
					label:Destroy()
					scrollFrame.Visible = false
				end
			end)
		else
			if label then
				label:Destroy()
				label = nil
			end
			scrollFrame.Visible = false
		end
	end)
end

return module
