local insert, remove
do
  local _obj_0 = table
  insert, remove = _obj_0.insert, _obj_0.remove
end
local Card, CardValue, CardSuit
do
  local _obj_0 = require("Card")
  Card, CardValue, CardSuit = _obj_0.Card, _obj_0.CardValue, _obj_0.CardSuit
end
do
  local _class_0
  local _base_0 = {
    shuffle_cards = function(self)
      local length = #self.cards
      local r, tmp = nil
      for i = 1, length do
        r = love.math.random(i, length)
        tmp = self.cards[i]
        self.cards[i] = self.cards[r]
        self.cards[r] = tmp
      end
    end,
    reset_deck = function(self)
      self.cards = { }
      for value in pairs(CardValue) do
        for suit in pairs(CardSuit) do
          insert(self.cards, Card(value, suit))
        end
      end
      return self:shuffle_cards()
    end,
    draw_card = function(self)
      return remove(self.cards)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.cards = { }
      return self:reset_deck()
    end,
    __base = _base_0,
    __name = "Deck"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Deck = _class_0
end
return {
  Deck = Deck
}
