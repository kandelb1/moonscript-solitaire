local image = love.graphics.newImage("img/Hearts 1.png")
SHUFFLE_SOUND = love.audio.newSource("sounds/cardFan1.wav", "static")
CARD_SOUND = love.audio.newSource("sounds/cardPlace2.wav", "static")
END_SOUND = love.audio.newSource("sounds/clapping.ogg", "static")
CARD_HEIGHT = image:getHeight()
CARD_WIDTH = image:getWidth()
PILE_Y_OFFSET = CARD_HEIGHT / 4
IMAGE_CARD_BACK = love.graphics.newImage("img/Back Red 1.png")
local ace_of_hearts = love.graphics.newImage("img/Hearts 1.png")
local ace_of_diamonds = love.graphics.newImage("img/Diamonds 1.png")
local ace_of_spades = love.graphics.newImage("img/Spades 1.png")
local ace_of_clubs = love.graphics.newImage("img/Clubs 1.png")
are_opposite_colors = function(card_a, card_b)
  if (card_a.suit == CardSuit.Hearts or card_a.suit == CardSuit.Diamonds) and (card_b.suit == CardSuit.Clubs or card_b.suit == CardSuit.Spades) then
    return true
  end
  if (card_a.suit == CardSuit.Clubs or card_a.suit == CardSuit.Spades) and (card_b.suit == CardSuit.Hearts or card_b.suit == CardSuit.Diamonds) then
    return true
  end
  return false
end
is_one_more = function(card_a, card_b)
  return cardval_to_number(card_a.value) == cardval_to_number(card_b.value) + 1
end
get_ace_image = function(suit)
  local _exp_0 = suit
  if CardSuit.Hearts == _exp_0 then
    return ace_of_hearts
  elseif CardSuit.Diamonds == _exp_0 then
    return ace_of_diamonds
  elseif CardSuit.Clubs == _exp_0 then
    return ace_of_clubs
  elseif CardSuit.Spades == _exp_0 then
    return ace_of_spades
  end
end
print_centered_text = function(text, x, y)
  local font = love.graphics.getFont()
  local width = font:getWidth(text)
  local height = font:getHeight()
  return love.graphics.print(text, x - (width / 2), y - (height / 2))
end
cardval_to_number = function(value)
  local _exp_0 = value
  if "Ace" == _exp_0 then
    return 1
  elseif "Two" == _exp_0 then
    return 2
  elseif "Three" == _exp_0 then
    return 3
  elseif "Four" == _exp_0 then
    return 4
  elseif "Five" == _exp_0 then
    return 5
  elseif "Six" == _exp_0 then
    return 6
  elseif "Seven" == _exp_0 then
    return 7
  elseif "Eight" == _exp_0 then
    return 8
  elseif "Nine" == _exp_0 then
    return 9
  elseif "Ten" == _exp_0 then
    return 10
  elseif "Jack" == _exp_0 then
    return 11
  elseif "Queen" == _exp_0 then
    return 12
  elseif "King" == _exp_0 then
    return 13
  end
end
return {
  CARD_HEIGHT = CARD_HEIGHT,
  CARD_WIDTH = CARD_WIDTH,
  PILE_Y_OFFSET = PILE_Y_OFFSET,
  IMAGE_CARD_BACK = IMAGE_CARD_BACK,
  are_opposite_colors = are_opposite_colors,
  is_one_more = is_one_more,
  get_ace_image = get_ace_image,
  print_centered_text = print_centered_text,
  cardval_to_number = cardval_to_number,
  CARD_SOUND = CARD_SOUND,
  SHUFFLE_SOUND = SHUFFLE_SOUND,
  END_SOUND = END_SOUND
}
