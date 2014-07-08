--ooooooooooooo-- Flappy Jam Developed by Jamie Grossman, 2014. Made with Marmalade 7.31! --ooooooooooooo-- 
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- Creates scene
menuScene = director:createScene()

-- Create background:
local background
local gameTitle
local playButton
local facebookButton
local twitterButton

function newGame(event)
  if event.phase == 'ended' then
  -- Switch to game scene
    switchToScene("game")
  end
end

function menuScene:setUp(event)
  dbg.print("Menu set up")
  background = director:createSprite(director.displayCenterX, director.displayCenterY, "gfx/background.png")
  background.xAnchor = 0.5
  background.yAnchor = 0.5

  gameTitle = director:createLabel(0, director.displayCenterY+(director.displayCenterY/2), 'Flappy Jam\nBy Jamie Grossman')
  gameTitle.color = color.red

  playButton = director:createSprite(director.displayCenterX, director.displayCenterY, "gfx/start.png")
  playButton.xAnchor = 0.5
  playButton.yAnchor = 0.5

  facebookButton = director:createLabel(0, 0, 'FACEBOOK')
  facebookButton.color = color.blue

  twitterButton = director:createLabel(250, 0, 'TWITTER')
  twitterButton.color = color.blue

  twitterButton:addEventListener("touch", twitterButtonPressed)
  facebookButton:addEventListener("touch", facebookButtonPressed)

  playButton:addEventListener("touch", newGame)
end

function menuScene:tearDown(event)
  dbg.print("Menu torn down")
  
  playButton:removeEventListener("touch", newGame)

  background = background:removeFromParent()
  gameTitle = gameTitle:removeFromParent()
  playButton = playButton:removeFromParent()
end

function facebookButtonPressed(event)
  if event.phase == 'began' then
    if browser:isAvailable() == true then
      browser:launchURL("http://www.facebook.com")
    end
  end
end

function twitterButtonPressed(event)
  if event.phase == 'began' then
    if browser:isAvailable() == true then
      browser:launchURL("http://twitter.com/share?text=I managed to recreate Flappy Bird in Marmalade Quick!&url=https://www.madewithmarmalade.com/&hashtags=madewithmarmalade, flappybird, gamedev")
    end
  end
end

menuScene:addEventListener({"setUp", "tearDown"}, menuScene)

