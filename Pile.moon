import Entity from require "Entity"
import CardValue from require "Card"
import CARD_WIDTH, CARD_HEIGHT, PILE_Y_OFFSET, IMAGE_CARD_BACK, is_one_more, are_opposite_colors, get_ace_image, print_centered_text from require "Util"
import insert, remove from table

export class BasePile extends Entity
  new: (cards = {}) =>
    super 0, 0
    @cards = cards

  --sometimes we overload this
  add_card: (card) => insert @cards, card

  clear: => @cards = {}

  combine_pile: (pile) =>
    for card in *pile.cards
      @add_card card

  __tostring: =>
    for card in *@cards
      print card

  draw: => error "not implemented in base class"

  is_valid_move: (pile) => error "not implemented in base class"

export class TableauPile extends BasePile
  new: (...) =>
    super ...
  
  draw: =>
    if #@cards == 0
      love.graphics.rectangle("line", @x, @y, CARD_WIDTH, CARD_HEIGHT)
      return
    index = 1
    for card in *@cards
      y_pos = @y + (PILE_Y_OFFSET * (index - 1))
      card\setPosition(@x, y_pos)
      card\draw!
      index += 1
    total_height = (PILE_Y_OFFSET * (#@cards - 1)) + CARD_HEIGHT
    love.graphics.rectangle("line", @x, @y, CARD_WIDTH, total_height)

  split_pile: (card_index) =>
    pile = TableauPile!    
    for card in *@cards[card_index, ] -- splice from the card_index to the end of the array
      pile\add_card(card)
    for i = 1, (#@cards - card_index + 1)
      remove @cards    
    return pile

  is_valid_move: (pile) =>
    top_card = @get_last_card!
    bottom_card = pile\get_top_card!
    unless top_card
      return bottom_card.value == CardValue.King
    return are_opposite_colors(top_card, bottom_card) and is_one_more(top_card, bottom_card)

  get_top_card: => @cards[1]
  
  get_last_card: => @cards[#@cards]

  pop: => remove @cards

  has_flipped_cards: =>
    for card in *@cards
      return true if card.flipped == true
    return false

export class FoundationPile extends BasePile
  new: (@type, ...) =>
    super ...
    @empty_image = get_ace_image @type

  add_card: (card) =>
    card\setPosition(@x, @y)
    super card

  split_pile: =>
    pile = TableauPile!
    pile\add_card remove @cards
    return pile

  draw: =>
    if #@cards == 0
      love.graphics.setColor(1, 1, 1, 0.3) -- make it a little transparent
      love.graphics.draw(@empty_image, @x, @y)
      love.graphics.setColor(1, 1, 1, 1)
    else
      @cards[#@cards]\draw!
    love.graphics.rectangle("line", @x, @y, CARD_WIDTH, CARD_HEIGHT)
    
  is_valid_move: (pile) =>
    if #pile.cards != 1
      return false
    card = pile.cards[1]
    if card.suit != @type
      return false
    if #@cards == 0 -- if this is the first card in the pile, it has to be an ace
      return card.value == CardValue.Ace
    -- now we just gotta check if it is one more than the current top card
    return is_one_more(card, @cards[#@cards])

  get_top_card: => @cards[#@cards]

  is_complete: =>
    return false if #@cards != 13
    prev_card = @cards[1]
    for i = 2, #@cards
      card = @cards[i]
      return false if not is_one_more(card, prev_card)
      prev_card = card
    return true

export class StockPile extends BasePile
  new: (...) =>
    super ...

  draw: =>
    if #@cards > 0
      love.graphics.draw(IMAGE_CARD_BACK, @x, @y)
    else
      print_centered_text("Click", @x + (CARD_WIDTH / 2), @y + (CARD_HEIGHT / 2) - 15)
      print_centered_text("To", @x + (CARD_WIDTH / 2), @y + (CARD_HEIGHT / 2))
      print_centered_text("Redeal", @x + (CARD_WIDTH / 2), @y + (CARD_HEIGHT / 2) + 15)
    love.graphics.rectangle("line", @x, @y, CARD_WIDTH, CARD_HEIGHT)
  
  pop: => remove @cards

  is_valid_move: (pile) => false

export class TalonPile extends BasePile
  new: (...) =>
    super ...

  add_card: (card) =>
    card\setPosition @x, @y
    super card

  split_pile: =>
    pile = TableauPile!
    pile\add_card remove @cards
    return pile

  get_top_card: => @cards[#@cards]

  draw: =>
    if #@cards > 0
      @cards[#@cards]\draw!
    love.graphics.rectangle("line", @x, @y, CARD_WIDTH, CARD_HEIGHT)

  is_valid_move: (pile) => false

{ :TableauPile, :FoundationPile, :StockPile, :TalonPile }