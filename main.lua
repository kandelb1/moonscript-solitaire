local Game
Game = require("Game").Game
local Mouse
Mouse = require("Mouse").Mouse
local game = Game()
local mouse = Mouse(game)
love.load = function()
  return print("love loaded")
end
love.draw = function()
  game:draw()
  return mouse:draw()
end
love.update = function(dt)
  game:update(dt)
  return mouse:update(dt)
end
love.mousepressed = function(x, y, button)
  return mouse:click_mouse(x, y, button)
end
