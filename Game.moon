import TableauPile, FoundationPile, TalonPile, StockPile from require "Pile"
import Card, CardSuit from require "Card"
import Deck from require "Deck"
import Animation from require "Animation"
import insert from table
tween = require "libs/tween"

export class Game
  new: =>
    @deck = Deck!
    @all_piles = {}
    @foundation_piles = {}
    @tableau_piles = {}
    @stock_pile = nil
    @talon_pile = nil
    @my_tweens = {}
    @animations = {}
    x = 50
    for i = 1, 7
      pile = TableauPile!
      pile\set_position x, 150
      insert @all_piles, pile
      insert @tableau_piles, pile
      x += 100    

    suits = { CardSuit.Hearts, CardSuit.Diamonds, CardSuit.Clubs, CardSuit.Spades }
    x = 350
    for i = 1, 4
      pile = FoundationPile suits[i]
      pile\set_position x, 40
      insert @all_piles, pile
      insert @foundation_piles, pile
      x += 100
    
    @reset_game! -- set up the game so we can give the stock pile what is left of the deck

    @stock_pile = StockPile @deck.cards
    @stock_pile\set_position 50, 40
    insert @all_piles, @stock_pile

    @talon_pile = TalonPile!
    @talon_pile\set_position 150, 40
    insert @all_piles, @talon_pile

  reset_game: =>
    @deck\reset_deck!

    for pile in *@all_piles
      pile\clear!
    
    -- place down the starting cards
    for i = 1, 7
      for j = i, 7
        pile = @tableau_piles[j]
        card = @deck\draw_card!
        if j != i
          card.flipped = true
        pile\add_card card

  activate_stock_pile: =>
    -- take one card from the stock pile and put it on the talon pile
    -- if it's empty, we have to reshuffle.
    if #@stock_pile.cards == 0
      for i = #@talon_pile.cards, 1, -1
        @stock_pile\add_card @talon_pile.cards[i]
      @talon_pile\clear!
    else
      card = @stock_pile\pop!
      @talon_pile\add_card card
  
  -- the game is not over if one of the foundation piles is not complete
  is_game_over: =>
    for pile in *@foundation_piles
      return false if not pile\is_complete!
    return true
  
  -- this function is called when there are no cards left in the stock and talon piles
  -- and when there are no cards left to be flipped over in the tableau piles
  finish_game: =>
    while not @is_game_over!
      for pile in *@tableau_piles
        continue if #pile.cards == 0
        dummy_pile = TableauPile!
        dummy_pile\add_card pile\get_last_card!
        for foundation in *@foundation_piles
          if foundation\is_valid_move(dummy_pile)
            card = pile\pop!
            animated_card = Card(card.value, card.suit) -- create a copy
            animated_card\set_position card.x, card.y -- set its position
            foundation\combine_pile(dummy_pile) -- move the original card over to the foundation
            -- set up the animation
            target = {x: foundation.x, y: foundation.y}
            the_tween = tween.new(love.math.random(1, 3), animated_card, target, tween.inQuad)
            animation = Animation(the_tween, animated_card)
            insert @animations, animation
            break
    
  update_state: =>
    -- if all the cards in the  stock and talon pile are gone, then the game is over. we can auto win for the player
    if #@stock_pile.cards == 0 and #@talon_pile.cards == 0
      autowin = true
      for pile in *@tableau_piles
        for card in *pile.cards
          autowin = false if card.flipped
      if autowin
        @finish_game!

  draw: =>
    for pile in *@all_piles
      pile\draw!
    for animation in *@animations
      animation\draw!

  update: (dt) =>
    for animation in *@animations
      animation\update  dt

{ :Game }
    