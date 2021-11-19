import insert, remove from table
import Card, CardValue, CardSuit from require "Card"

export class Deck
  new: =>
    @cards = {}
    @reset_deck!
  
  -- https://love2d.org/forums/viewtopic.php?t=326  
  shuffle_cards: =>
    length = #@cards
    r, tmp = nil
    for i = 1, length
      r = love.math.random(i, length)
      tmp = @cards[i]
      @cards[i] = @cards[r]
      @cards[r] = tmp

  reset_deck: =>
    @cards = {}
    for value in pairs CardValue
      for suit in pairs CardSuit
        insert @cards, Card(value, suit)
    @shuffle_cards!

  draw_card: => remove @cards

{ :Deck }