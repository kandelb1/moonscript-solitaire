local TableauPile, FoundationPile, TalonPile, StockPile
do
  local _obj_0 = require("Pile")
  TableauPile, FoundationPile, TalonPile, StockPile = _obj_0.TableauPile, _obj_0.FoundationPile, _obj_0.TalonPile, _obj_0.StockPile
end
local Card, CardSuit
do
  local _obj_0 = require("Card")
  Card, CardSuit = _obj_0.Card, _obj_0.CardSuit
end
local Deck
Deck = require("Deck").Deck
local Animation
Animation = require("Animation").Animation
local insert
insert = table.insert
local tween = require("libs/tween")
do
  local _class_0
  local _base_0 = {
    reset_game = function(self)
      self.deck:reset_deck()
      local _list_0 = self.all_piles
      for _index_0 = 1, #_list_0 do
        local pile = _list_0[_index_0]
        pile:clear()
      end
      for i = 1, 7 do
        for j = i, 7 do
          local pile = self.tableau_piles[j]
          local card = self.deck:draw_card()
          if j ~= i then
            card.flipped = true
          end
          pile:add_card(card)
        end
      end
    end,
    activate_stock_pile = function(self)
      if #self.stock_pile.cards == 0 then
        for i = #self.talon_pile.cards, 1, -1 do
          self.stock_pile:add_card(self.talon_pile.cards[i])
        end
        return self.talon_pile:clear()
      else
        local card = self.stock_pile:pop()
        return self.talon_pile:add_card(card)
      end
    end,
    is_game_over = function(self)
      local _list_0 = self.foundation_piles
      for _index_0 = 1, #_list_0 do
        local pile = _list_0[_index_0]
        if not pile:is_complete() then
          return false
        end
      end
      return true
    end,
    finish_game = function(self)
      while not self:is_game_over() do
        local _list_0 = self.tableau_piles
        for _index_0 = 1, #_list_0 do
          local _continue_0 = false
          repeat
            local pile = _list_0[_index_0]
            if #pile.cards == 0 then
              _continue_0 = true
              break
            end
            local dummy_pile = TableauPile()
            dummy_pile:add_card(pile:get_last_card())
            local _list_1 = self.foundation_piles
            for _index_1 = 1, #_list_1 do
              local foundation = _list_1[_index_1]
              if foundation:is_valid_move(dummy_pile) then
                local card = pile:pop()
                local animated_card = Card(card.value, card.suit)
                animated_card:setPosition(card.x, card.y)
                foundation:combine_pile(dummy_pile)
                local target = {
                  x = foundation.x,
                  y = foundation.y
                }
                local the_tween = tween.new(love.math.random(1, 3), animated_card, target, tween.inQuad)
                local animation = Animation(the_tween, animated_card)
                insert(self.animations, animation)
                break
              end
            end
            _continue_0 = true
          until true
          if not _continue_0 then
            break
          end
        end
      end
    end,
    update_state = function(self)
      if #self.stock_pile.cards == 0 and #self.talon_pile.cards == 0 then
        local autowin = true
        local _list_0 = self.tableau_piles
        for _index_0 = 1, #_list_0 do
          local pile = _list_0[_index_0]
          local _list_1 = pile.cards
          for _index_1 = 1, #_list_1 do
            local card = _list_1[_index_1]
            if card.flipped then
              autowin = false
            end
          end
        end
        if autowin then
          return self:finish_game()
        end
      end
    end,
    draw = function(self)
      local _list_0 = self.all_piles
      for _index_0 = 1, #_list_0 do
        local pile = _list_0[_index_0]
        pile:draw()
      end
      local _list_1 = self.animations
      for _index_0 = 1, #_list_1 do
        local animation = _list_1[_index_0]
        animation:draw()
      end
    end,
    update = function(self, dt)
      local _list_0 = self.animations
      for _index_0 = 1, #_list_0 do
        local animation = _list_0[_index_0]
        animation:update(dt)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.deck = Deck()
      self.all_piles = { }
      self.foundation_piles = { }
      self.tableau_piles = { }
      self.stock_pile = nil
      self.talon_pile = nil
      self.my_tweens = { }
      self.animations = { }
      local x = 50
      for i = 1, 7 do
        local pile = TableauPile()
        pile:setPosition(x, 150)
        insert(self.all_piles, pile)
        insert(self.tableau_piles, pile)
        x = x + 100
      end
      local suits = {
        CardSuit.Hearts,
        CardSuit.Diamonds,
        CardSuit.Clubs,
        CardSuit.Spades
      }
      x = 350
      for i = 1, 4 do
        local pile = FoundationPile(suits[i])
        pile:setPosition(x, 40)
        insert(self.all_piles, pile)
        insert(self.foundation_piles, pile)
        x = x + 100
      end
      self:reset_game()
      self.stock_pile = StockPile(self.deck.cards)
      self.stock_pile:setPosition(50, 40)
      insert(self.all_piles, self.stock_pile)
      self.talon_pile = TalonPile()
      self.talon_pile:setPosition(150, 40)
      return insert(self.all_piles, self.talon_pile)
    end,
    __base = _base_0,
    __name = "Game"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Game = _class_0
end
return {
  Game = Game
}
