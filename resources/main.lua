--ooooooooooooo-- Flappy Jam Developed by Jamie Grossman, 2014. Made with Marmalade 7.31! --ooooooooooooo-- 
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

--imports
dofile("game.lua")
dofile("menu.lua")
director:setCurrentScene(nil)
director:moveToScene(menuScene)

-- Switch to specific scene
function switchToScene(scene_name)
  if (scene_name == "game") then
    director:moveToScene(gameScene)
  elseif (scene_name == "menu") then
  	director:moveToScene(menuScene)
  end
end

local gameData = {}

local pathS = system:getFilePath("storage", "")
-- Load the saved JSON string back
local file = io.open(pathS .. "d.txt", "r")
if file == nil then
  local gameData = {bestScore=0}
  local encoded = json.encode(gameData)
  local file = io.open(pathS .. "d.txt", "w")
  file:write(encoded)
  file:close()
  dbg.print('Failed to open file for reading - new one added')
else
  dbg.print('file found no worries')
  file:close()
end