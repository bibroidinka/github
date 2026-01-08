return function(text, pos, parent)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 100, 0, 20)
	label.TextWrapped = true
	label.TextScaled = true
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.BackgroundTransparency = 0.5
	label.Position = pos
	label.Text = text
	label.Parent = parent
	return label
end
