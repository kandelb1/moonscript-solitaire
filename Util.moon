-- circular dependency issues...but it's fine
-- import CardSuit from require "Card"
image = love.graphics.newImage("img/Hearts 1.png") -- all the card images are the same, so we can use any one of them tp get things like width/height

export SHUFFLE_SOUND = love.audio.newSource("sounds/cardFan1.wav", "static")
export CARD_SOUND = love.audio.newSource("sounds/cardPlace2.wav", "static")
export END_SOUND = love.audio.newSource("sounds/clapping.ogg", "static")

export CARD_HEIGHT = image\getHeight!
export CARD_WIDTH = image\getWidth!
export PILE_Y_OFFSET = CARD_HEIGHT / 4
export IMAGE_CARD_BACK = love.graphics.newImage("img/Back Red 1.png")

ace_of_hearts = love.graphics.newImage("img/Hearts 1.png")
ace_of_diamonds = love.graphics.newImage("img/Diamonds 1.png")
ace_of_spades = love.graphics.newImage("img/Spades 1.png")
ace_of_clubs = love.graphics.newImage("img/Clubs 1.png")

-- returns true if card_a and card_b are opposite color suits
export are_opposite_colors = (card_a, card_b) ->
  if (card_a.suit == CardSuit.Hearts or card_a.suit == CardSuit.Diamonds) and (card_b.suit == CardSuit.Clubs or card_b.suit == CardSuit.Spades)
    return true
  if (card_a.suit == CardSuit.Clubs or card_a.suit == CardSuit.Spades) and (card_b.suit == CardSuit.Hearts or card_b.suit == CardSuit.Diamonds)
    return true
  return false

-- returns true if card_a is one more than card_b
export is_one_more = (card_a, card_b) ->  
  cardval_to_number(card_a.value) == cardval_to_number(card_b.value) + 1

-- get an image of the ace card based on the provided suit
export get_ace_image = (suit) ->
  switch suit
    when CardSuit.Hearts
      ace_of_hearts
    when CardSuit.Diamonds
      ace_of_diamonds
    when CardSuit.Clubs
      ace_of_clubs
    when CardSuit.Spades
      ace_of_spades

-- try to print text that centers around the provided x,y coordinates
export print_centered_text = (text, x, y)->
  font = love.graphics.getFont!
  width = font\getWidth text
  height = font\getHeight!
  love.graphics.print(text, x - (width / 2), y - (height / 2))

-- turn a CardValue into a number
export cardval_to_number = (value) ->
  switch value
    when "Ace"
      1
    when "Two"
      2
    when "Three"
      3
    when "Four"
      4
    when "Five"
      5
    when "Six"
      6
    when "Seven"
      7
    when "Eight"
      8
    when "Nine"
      9
    when "Ten"
      10
    when "Jack"
      11
    when "Queen"
      12
    when "King"
      13

{ :CARD_HEIGHT, :CARD_WIDTH, :PILE_Y_OFFSET, :IMAGE_CARD_BACK, :are_opposite_colors, :is_one_more, :get_ace_image, :print_centered_text, :cardval_to_number, :CARD_SOUND, :SHUFFLE_SOUND, :END_SOUND }