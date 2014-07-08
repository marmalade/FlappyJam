--ooooooooooooo-- Flappy Jam Developed by Jamie Grossman, 2014. Made with Marmalade 7.31! --ooooooooooooo-- 
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

----Imports
require("class")
require("object")
----

----Scene
gameScene = director:createScene()
----

----Variables
--Values
local maxEnemies
local heightAdder
local widthAdder
local scoreValue
local gameTaps
local fontScaleSmall = director.displayWidth / 320
--Sprites
local background
local resetButton
local menuButton
local player
local startGameHelp
--Text
local scoreText
local bestScoreText
--Tables
local enemyBool = {}
local enemyArray = {}
----

-- Event listener: touch
function systemEvents(event)
  if event.phase == "began" then
    if gameTaps == 2 then
      init()
    end
    
    if player.physics and gamePlaying == true then
      jump()
    end
  elseif event.phase == "ended" then
    gameTaps = gameTaps + 1
    dbg.print('Taps: ' .. gameTaps)
  end
end

function init() --Game Start
  physics:setGravity(0, -980*1.5)
  enemyBool[1] = true
  enemyBool[2] = true
  enemyBool[3] = true --No enemies have been crossed yet
  startGameHelp.alpha = 0
  physics:addNode(player, {radius = 21})
  for i=1,maxEnemies
    do 
    enemyArray[i]:getSprite().physics:setLinearVelocity(-160, 0) -- Move the enemies
  end
  gamePlaying = true
end

function gameover() --Game lost!
  local data ={}
  local pathS = system:getFilePath("storage", "")
  local file = io.open(pathS .. "d.txt", "r")
  local a = file:read("*a")
  data = json.decode(a)

  local bestScore = data.bestScore
  file:close()

  if scoreValue > bestScore then 
    dbg.print('new hi score!')
    bestScore = scoreValue 
    data.bestScore = bestScore -- Save new hi score
  end

  local newData = json.encode(data)
  local file = io.open(pathS .. "d.txt", "w")
  file:write(newData)
  file:close()

  bestScoreText.text = "BEST: " .. bestScore
  bestScoreText.alpha = 1
  startGameHelp.text = "You lost man. You lost."
  startGameHelp.color = color.white
  startGameHelp.alpha = 1
  background.color = color.red
  gamePlaying = false

  for i=1,maxEnemies
    do 
    enemyArray[i]:getSprite().physics:setLinearVelocity(0, 0) --Stop moving enemies
  end

  menuButton.alpha = 1
  resetButton.alpha = 1
end

function pressReset(event) --Reset pressed from event listener
  if event.phase == 'ended' and resetButton.alpha == 1 then
    reset()
  end
end

function resetEnemies()
  for i=1,maxEnemies
    do 
    enemyArray[i]:getSprite().x = director.displayCenterX -- Move enemies back to start pos
  end

  local yx = math.random(director.displayCenterY - 350, director.displayCenterY - 100)
  local yy = math.random(director.displayCenterY - 350, director.displayCenterY - 100)   
  local yz = math.random(director.displayCenterY - 350, director.displayCenterY - 100) 

  local a = enemyArray[1]:getSprite().x
  local b = enemyArray[2]:getSprite().x
  local c = enemyArray[3]:getSprite().x - ((director.displayCenterX / 2)*2)
  local d = enemyArray[4]:getSprite().x - ((director.displayCenterX / 2)*2)
  local e = enemyArray[5]:getSprite().x + ((director.displayCenterX / 2)*2)
  local f = enemyArray[6]:getSprite().x + ((director.displayCenterX / 2)*2)

  enemyArray[1]:getSprite().physics:setTransform(a + widthAdder, yx, 0)
  enemyArray[2]:getSprite().physics:setTransform(b + widthAdder, yx+heightAdder, 0)
  enemyArray[3]:getSprite().physics:setTransform(c + widthAdder, yy, 0)
  enemyArray[4]:getSprite().physics:setTransform(d + widthAdder, yy+heightAdder, 0)
  enemyArray[5]:getSprite().physics:setTransform(e + widthAdder, yz, 0)
  enemyArray[6]:getSprite().physics:setTransform(f + widthAdder, yz+heightAdder, 0)
end

function reset() --Game reset
  scoreValue = 0
  bestScoreText.alpha = 0
  scoreText.text = 'SCORE: ' .. scoreValue
  physics:removeNode(player)
  player.x = director.displayCenterX/2
  player.y = director.displayCenterY + (director.displayCenterY/2)
  background.color = color.white
  startGameHelp.alpha = 1
  startGameHelp.color = color.red
  startGameHelp.text = "Tap to start!"
  gameTaps = 0
  resetButton.alpha = 0
  menuButton.alpha = 0
  resetEnemies()
end

function jump()
  if player.y < director.displayHeight then
    player.physics:setLinearVelocity(0,0)
    player.physics:applyLinearImpulse(0, 60)
  end
end

function pointGiver(pEnemyBool)
  if enemyBool[pEnemyBool] == true then
    enemyBool[pEnemyBool] = false --Stop multiple points from being given
    dbg.print('ENEMY PASSED 2')
    scoreValue = scoreValue + 1
    scoreText.text = 'SCORE: ' .. scoreValue
  end
end

function enemyRelocator(enemy1, enemy2)
  local y = math.random(director.displayCenterY - 350, director.displayCenterY - 100) -- Give it a new Y (and it's pair)
  enemyArray[enemy1]:getSprite().physics:setTransform(director.displayWidth + enemyArray[enemy1]:getSprite().w, y, 0)
  enemyArray[enemy2]:getSprite().physics:setTransform(director.displayWidth + enemyArray[enemy2]:getSprite().w, y+heightAdder, 0)
end

function updater()
  if gamePlaying == true then
   if player.y < 0 then --if fallen off the screen
     gameover() 
   end

   if (enemyArray[1]:getSprite().x + enemyArray[1]:getSprite().w) + 30 < 0 then -- If the enemy has gone off the screen
      enemyRelocator(1, 2)
    end

    if (enemyArray[3]:getSprite().x + enemyArray[3]:getSprite().w) + 30 < 0 then
     enemyRelocator(3, 4)
   end

   if (enemyArray[5]:getSprite().x + enemyArray[5]:getSprite().w) + 30 < 0 then
     enemyRelocator(5, 6)
   end

   if enemyArray[1]:getSprite().x < director.displayWidth and enemyArray[1]:getSprite().x > director.displayCenterX and enemyBool[1] == false then --If the enemy has been relocated, get it ready for points
      enemyBool[1] = true
  end

  if enemyArray[3]:getSprite().x < director.displayWidth and enemyArray[3]:getSprite().x > director.displayCenterX and enemyBool[2] == false then
      enemyBool[2] = true
  end

  if enemyArray[5]:getSprite().x < director.displayWidth and enemyArray[5]:getSprite().x > director.displayCenterX and enemyBool[3] == false then
    enemyBool[3] = true
  end

  if enemyArray[1]:getSprite().x < player.x and enemyBool[1] == true then --If the player has passed an enemy, give them a point
    pointGiver(1)
  end

  if enemyArray[3]:getSprite().x < player.x then
    pointGiver(2)
  end

  if enemyArray[5]:getSprite().x < player.x then
    pointGiver(3)
  end
 end
end

function hit(event)
  if event.phase == "began" then    
    if event.nodeA.name == "player" then
      if event.nodeB.name == "enemy" then -- IF there is a collision!
        gameover()
      end
    elseif event.nodeB.name == "player" then
      if event.nodeA.name == "enemy" then -- Don't forget to check the other way!
        gameover()
      end
    end      
  end 
end

function goToMenu(event)
  if event.phase == 'ended' and menuButton.alpha == 1 then
    switchToScene("menu")
  end
end

function gameScene:setUp(event)
  gameTaps = 0
  
  background = director:createSprite(director.displayCenterX, director.displayCenterY, "gfx/background.png")
  background.xAnchor = 0.5
  background.yAnchor = 0.5
  background.rotation = 180

  player = director:createSprite(director.displayCenterX/2,director.displayCenterY + (director.displayCenterY/2), "gfx/player.png")
  player.xAnchor = 0.5
  player.yAnchor = 0.5
  player.name ='player'

  startGameHelp = director:createLabel(0, director.displayCenterY, 'Tap to start!')
  startGameHelp.color = color.red

  maxEnemies = 6
  heightAdder = 750
  widthAdder = 600

  enemyArray = {}

  for i=1,maxEnemies --Sets up enemy columns
    do
    enemyArray[i] = object.new(i, "gfx/enemy.png") 
    enemyArray[i]:getSprite().xAnchor = 0.5
    enemyArray[i]:getSprite().yAnchor = 0.5
    enemyArray[i]:getSprite().name ='enemy'
    enemyArray[i]:getSprite().x = director.displayCenterX
    physics:addNode(enemyArray[i]:getSprite(), {type="kinematic"})
  end

  scoreValue = 0
  scoreText = director:createLabel( {
    x = 0, y = director.displayCenterY/2, hAlignment="centre", vAlignment="middle",
    text="SCORE: " .. scoreValue, color = color.blue, textXScale = fontScaleSmall, textYScale = fontScaleSmall
    })

  bestScoreText = director:createLabel( {
    x = 0, y = (director.displayCenterY/2) - 50, hAlignment="centre", vAlignment="middle",
    text="" .. scoreValue, color = color.blue, textXScale = fontScaleSmall, textYScale = fontScaleSmall
    })
  bestScoreText.alpha = 0

  menuButton = director:createLabel( {
      x = 0, y = -90, hAlignment="centre", vAlignment="middle",
      text="MENU"
      })
  menuButton.color = color.blue
  menuButton.alpha = 0

  resetButton = director:createLabel( {
      x = 0, y = -50, hAlignment="centre", vAlignment="middle",
      text="RESET"
      })
  resetButton.color = color.blue
  resetButton.alpha = 0

  menuButton:addEventListener("touch", goToMenu)
  resetButton:addEventListener("touch", pressReset)
  resetEnemies()

  system:addEventListener("touch", systemEvents)
  system:addEventListener("update", updater)

  for i=1,maxEnemies
    do 
    enemyArray[i]:getSprite():addEventListener("collision", hit)
  end
  dbg.print('game scene set up')
end

function gameScene:tearDown(event) --Remove everything!
  dbg.print('game scene tear down')
  
  background = background:removeFromParent()

  player = player:removeFromParent() 

  startGameHelp = startGameHelp:removeFromParent()
  
  heightAdder = nil
  widthAdder = nil

  for i=1,maxEnemies
  do
    enemyArray[i]:remove()
  end

  system:removeEventListener("touch", systemEvents)
  system:removeEventListener("update", updater)

  enemyArray = {}
  maxEnemies = nil
end

gameScene:addEventListener({"setUp", "tearDown"}, gameScene) --Called at start and end of scene

