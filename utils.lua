-- utils.lua
function CreateLabel(text)
    local textLabel = Instance.new("TextLabel", scrollingFrame)
    textLabel.Size = UDim2.new(1, 0, 0, 1000)
    textLabel.TextWrapped = true
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    return textLabel
end
