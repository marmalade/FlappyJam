--ooooooooooooo-- Flappy Jam Developed by Jamie Grossman, 2014. Made with Marmalade 7.31! --ooooooooooooo-- 
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

--For Object Orientation

module(..., package.seeall)

-- OO functions
require("class")

-- Create the object
object = inheritsFrom(baseClass)

-- Creates an instance of a new object
function new(type, image)
  local o = object:create()
  object:init(o, type, image)  
  return o
end

-- Initialise the object
function object:init(o, type, image)
-- Create a sprite
  o.sprite = director:createSprite(0, 0, image)
  o.type = type
end

function object:getSprite()
  return self.sprite
end

function object:getX()
  return self.x
end

function object:getY()
  return self.y
end

function object:setPos(pX, pY)
  self.sprite.x = pX
  self.sprite.y = pY
end

function object:remove()
  self.sprite:removeFromParent()
  self.sprite = nil
end