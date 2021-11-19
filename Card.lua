local enum
enum = require("Enum").enum
local Entity
Entity = require("Entity").Entity
local cardval_to_number, IMAGE_CARD_BACK
do
  local _obj_0 = require("Util")
  cardval_to_number, IMAGE_CARD_BACK = _obj_0.cardval_to_number, _obj_0.IMAGE_CARD_BACK
end
CardSuit = enum({
  "Hearts",
  "Diamonds",
  "Spades",
  "Clubs"
})
CardValue = enum({
  "Ace",
  "Two",
  "Three",
  "Four",
  "Five",
  "Six",
  "Seven",
  "Eight",
  "Nine",
  "Ten",
  "Jack",
  "Queen",
  "King"
})
do
  local _class_0
  local _parent_0 = Entity
  local _base_0 = {
    __tostring = function(self)
      return tostring(self.value) .. " of " .. tostring(self.suit) .. ", flipped? " .. tostring(self.flipped)
    end,
    draw = function(self)
      if self.flipped then
        return love.graphics.draw(IMAGE_CARD_BACK, self.x, self.y)
      else
        return love.graphics.draw(self.image, self.x, self.y)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, value, suit)
      _class_0.__parent.__init(self, 0, 0)
      self.value = value
      self.suit = suit
      self.image = love.graphics.newImage("img/" .. tostring(self.suit) .. " " .. tostring(cardval_to_number(self.value)) .. ".png")
      self.flipped = false
    end,
    __base = _base_0,
    __name = "Card",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Card = _class_0
end
return {
  Card = Card,
  CardSuit = CardSuit,
  CardValue = CardValue
}
