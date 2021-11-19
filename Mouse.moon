import FoundationPile, StockPile, TableauPile, TalonPile from require "Pile"
require "Util"

export class Mouse
  new: (@game) =>
    @parent = nil
    @selected = nil

  update: (dt) =>
    x = love.mouse.getX!
    y = love.mouse.getY!
    if @selected
      @selected\set_position x, y
  
  draw: =>
    @selected\draw! if @selected
  
  -- try to select a pile if we haven't already selected one. if we're already holding a pile, try to place it down
  -- on the pile that we clicked on
  click_mouse: (x, y, button) =>
    if button == 1
      if @selected
        -- put it down
        if @did_click_pile(x, y)
          -- try to combine it with the pile we clicked
          clicked = @get_pile_from_click(x, y, true)
          if clicked\is_valid_move(@selected)
            clicked\combine_pile(@selected)
            if @parent.__class == TableauPile and #@parent.cards != 0
              @parent\get_last_card!.flipped = false
            @game\update_state!
          else
            @parent\combine_pile @selected
        else
          @parent\combine_pile @selected
        @parent = nil
        @selected = nil
      elseif @did_click_pile(x, y, true)
        if @selected -- put down the pile
          @selected = nil
        else -- try to pick up the pile
          pile = @get_pile_from_click(x, y, true)
          if pile.__class == TableauPile
            unless #pile.cards == 0
              @parent = pile
              @selected = @get_pile_from_click(x, y)
          elseif pile.__class == FoundationPile
            unless #pile.cards == 0
              @parent = pile
              @selected = @get_pile_from_click(x, y)
          elseif pile.__class == TalonPile
            unless #pile.cards == 0
              @parent = pile
              @selected = pile\split_pile!
          elseif pile.__class == StockPile
            @game\activate_stock_pile!
  
  -- do math to determine if the x y coordinates fall within any of the piles
  did_click_pile: (x, y, check_for_flipped = false) =>
    for pile in *@game.tableau_piles
      total_height = pile.y + (PILE_Y_OFFSET * (#pile.cards - 1)) + CARD_HEIGHT
      if x >= pile.x and x <= pile.x + CARD_WIDTH and y >= pile.y and y <= total_height
        result = true
        -- we definitely clicked on a tableau pile. let's check to see if we clicked on any flipped cards.
        if check_for_flipped
          -- get a dummy pile and combine it back with the parent so nothing changes about the game
          dummy_pile = @get_pile_from_click(x, y)
          pile\combine_pile dummy_pile
          result = false if dummy_pile\has_flipped_cards!
        return result

    for pile in *@game.foundation_piles
      if x >= pile.x and x <= pile.x + CARD_WIDTH and y >= pile.y and y <= pile.y + CARD_HEIGHT
        return true

    if x >= @game.stock_pile.x and x <= @game.stock_pile.x + CARD_WIDTH and y >= @game.stock_pile.y and y <= @game.stock_pile.y + CARD_HEIGHT    
      return true

    if x >= @game.talon_pile.x and x <= @game.talon_pile.x + CARD_WIDTH and y >= @game.talon_pile.y and y <= @game.talon_pile.y + CARD_HEIGHT    
      return true

    return false

  get_pile_from_click: (x, y, get_whole_pile = false) =>
    for pile in *@game.tableau_piles
      total_height = pile.y + (PILE_Y_OFFSET * (#pile.cards - 1)) + CARD_HEIGHT
      if x >= pile.x and x <= pile.x + CARD_WIDTH and y >= pile.y and y <= total_height
        -- we know we clicked on a pile of cards. now lets find out exactly which card we clicked on
        if get_whole_pile
          return pile
        for card_index = 1, #pile.cards
          card = pile.cards[card_index]
          if card_index == #pile.cards
            if y >= card.y and y <= card.y + CARD_HEIGHT
              return pile\split_pile card_index
          if y >= card.y and y <= card.y + PILE_Y_OFFSET
            return pile\split_pile card_index
    
    -- it wasn't a tableau pile, check the other piles
    for pile in *@game.foundation_piles
      if x >= pile.x and x <= pile.x + CARD_WIDTH and y >= pile.y and y <= pile.y + CARD_HEIGHT
        if get_whole_pile
          return pile
        return pile\split_pile!
    
    if x >= @game.stock_pile.x and x <= @game.stock_pile.x + CARD_WIDTH and y >= @game.stock_pile.y and y <= @game.stock_pile.y + CARD_HEIGHT
      return @game.stock_pile

    if x >= @game.talon_pile.x and @game.talon_pile.x + CARD_WIDTH and y >= @game.talon_pile.y and y <= @game.talon_pile.y + CARD_HEIGHT
      return @game.talon_pile
  
{ :Mouse }
    

  