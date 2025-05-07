local uiModule = require(script.Parent.ui)  -- Получаем модуль с интерфейсом
local screenui = uiModule.ui  -- Доступ к объекту ScreenGui через module.ui

local guiLogic = require(script.Parent.init)  -- Подключаем логику
guiLogic.init(screenui)  -- Передаем screenui в логику интерфейса
