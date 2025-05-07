return function(text, pos, size, parent)
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
