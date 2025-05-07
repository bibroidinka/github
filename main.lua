-- main.lua

-- Загрузка модулей с GitHub
local uiScript = game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/ui.lua")
local espScript = game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/esp.lua")
local autofarmScript = game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/autofarm.lua")
local backpackCheckScript = game:HttpGet("https://raw.githubusercontent.com/bibroidinka/github/main/backpackCheck.lua")

-- Загружаем модули
local ui = loadstring(uiScript)()
local esp = loadstring(espScript)()
local autofarm = loadstring(autofarmScript)()
local backpackCheck = loadstring(backpackCheckScript)()

-- Инициализация UI
ui.Initialize()

-- Создание кнопки для "Zunesh Hub"
local Zunesh_Hub = ui.CreateButton("Zunesh Hub", UDim2.new(0, 20, 0, 50), UDim2.new(0, 40, 0, 40))

-- Обработчик нажатия кнопки
Zunesh_Hub.MouseButton1Click:Connect(function()
    ui.ToggleFrame()
    esp.ToggleESP()
    autofarm.ToggleAutoFarm()
    backpackCheck.ToggleBackpackCheck()
end)
