import enum from require "Enum"
import Entity from require "Entity"
import cardval_to_number, IMAGE_CARD_BACK from require "Util"

export CardSuit = enum {"Hearts", "Diamonds", "Spades", "Clubs"}
export CardValue = enum {"Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"}

export class Card extends Entity
  new: (value, suit) =>
    super(0, 0)
    @value = value
    @suit = suit
    @image = love.graphics.newImage("img/#{@suit} #{cardval_to_number @value}.png")
    @flipped = false

  __tostring: =>
    "#{@value} of #{@suit}, flipped? #{@flipped}"

  draw: =>
    if @flipped
      love.graphics.draw(IMAGE_CARD_BACK, @x, @y)
    else
      love.graphics.draw(@image, @x, @y)
      
{ :Card, :CardSuit, :CardValue }