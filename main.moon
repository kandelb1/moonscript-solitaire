import Game from require "Game"
import Mouse from require "Mouse"

game = Game!
mouse = Mouse(game)

love.load = -> print "love loaded"
  
love.draw = ->
  game\draw!
  mouse\draw!

love.update = (dt) ->
  game\update(dt)
  mouse\update(dt)

love.mousepressed = (x, y, button) ->
  mouse\click_mouse(x, y, button)