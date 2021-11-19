local FoundationPile, StockPile, TableauPile, TalonPile
do
  local _obj_0 = require("Pile")
  FoundationPile, StockPile, TableauPile, TalonPile = _obj_0.FoundationPile, _obj_0.StockPile, _obj_0.TableauPile, _obj_0.TalonPile
end
require("Util")
do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      local x = love.mouse.getX()
      local y = love.mouse.getY()
      if self.selected then
        return self.selected:set_position(x, y)
      end
    end,
    draw = function(self)
      if self.selected then
        return self.selected:draw()
      end
    end,
    click_mouse = function(self, x, y, button)
      if button == 1 then
        if self.selected then
          if self:did_click_pile(x, y) then
            local clicked = self:get_pile_from_click(x, y, true)
            if clicked:is_valid_move(self.selected) then
              clicked:combine_pile(self.selected)
              if self.parent.__class == TableauPile and #self.parent.cards ~= 0 then
                self.parent:get_last_card().flipped = false
              end
              self.game:update_state()
            else
              self.parent:combine_pile(self.selected)
            end
          else
            self.parent:combine_pile(self.selected)
          end
          self.parent = nil
          self.selected = nil
        elseif self:did_click_pile(x, y, true) then
          if self.selected then
            self.selected = nil
          else
            local pile = self:get_pile_from_click(x, y, true)
            if pile.__class == TableauPile then
              if not (#pile.cards == 0) then
                self.parent = pile
                self.selected = self:get_pile_from_click(x, y)
              end
            elseif pile.__class == FoundationPile then
              if not (#pile.cards == 0) then
                self.parent = pile
                self.selected = self:get_pile_from_click(x, y)
              end
            elseif pile.__class == TalonPile then
              if not (#pile.cards == 0) then
                self.parent = pile
                self.selected = pile:split_pile()
              end
            elseif pile.__class == StockPile then
              return self.game:activate_stock_pile()
            end
          end
        end
      end
    end,
    did_click_pile = function(self, x, y, check_for_flipped)
      if check_for_flipped == nil then
        check_for_flipped = false
      end
      local _list_0 = self.game.tableau_piles
      for _index_0 = 1, #_list_0 do
        local pile = _list_0[_index_0]
        local total_height = pile.y + (PILE_Y_OFFSET * (#pile.cards - 1)) + CARD_HEIGHT
        if x >= pile.x and x <= pile.x + CARD_WIDTH and y >= pile.y and y <= total_height then
          local result = true
          if check_for_flipped then
            local dummy_pile = self:get_pile_from_click(x, y)
            pile:combine_pile(dummy_pile)
            if dummy_pile:has_flipped_cards() then
              result = false
            end
          end
          return result
        end
      end
      local _list_1 = self.game.foundation_piles
      for _index_0 = 1, #_list_1 do
        local pile = _list_1[_index_0]
        if x >= pile.x and x <= pile.x + CARD_WIDTH and y >= pile.y and y <= pile.y + CARD_HEIGHT then
          return true
        end
      end
      if x >= self.game.stock_pile.x and x <= self.game.stock_pile.x + CARD_WIDTH and y >= self.game.stock_pile.y and y <= self.game.stock_pile.y + CARD_HEIGHT then
        return true
      end
      if x >= self.game.talon_pile.x and x <= self.game.talon_pile.x + CARD_WIDTH and y >= self.game.talon_pile.y and y <= self.game.talon_pile.y + CARD_HEIGHT then
        return true
      end
      return false
    end,
    get_pile_from_click = function(self, x, y, get_whole_pile)
      if get_whole_pile == nil then
        get_whole_pile = false
      end
      local _list_0 = self.game.tableau_piles
      for _index_0 = 1, #_list_0 do
        local pile = _list_0[_index_0]
        local total_height = pile.y + (PILE_Y_OFFSET * (#pile.cards - 1)) + CARD_HEIGHT
        if x >= pile.x and x <= pile.x + CARD_WIDTH and y >= pile.y and y <= total_height then
          if get_whole_pile then
            return pile
          end
          for card_index = 1, #pile.cards do
            local card = pile.cards[card_index]
            if card_index == #pile.cards then
              if y >= card.y and y <= card.y + CARD_HEIGHT then
                return pile:split_pile(card_index)
              end
            end
            if y >= card.y and y <= card.y + PILE_Y_OFFSET then
              return pile:split_pile(card_index)
            end
          end
        end
      end
      local _list_1 = self.game.foundation_piles
      for _index_0 = 1, #_list_1 do
        local pile = _list_1[_index_0]
        if x >= pile.x and x <= pile.x + CARD_WIDTH and y >= pile.y and y <= pile.y + CARD_HEIGHT then
          if get_whole_pile then
            return pile
          end
          return pile:split_pile()
        end
      end
      if x >= self.game.stock_pile.x and x <= self.game.stock_pile.x + CARD_WIDTH and y >= self.game.stock_pile.y and y <= self.game.stock_pile.y + CARD_HEIGHT then
        return self.game.stock_pile
      end
      if x >= self.game.talon_pile.x and self.game.talon_pile.x + CARD_WIDTH and y >= self.game.talon_pile.y and y <= self.game.talon_pile.y + CARD_HEIGHT then
        return self.game.talon_pile
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, game)
      self.game = game
      self.parent = nil
      self.selected = nil
    end,
    __base = _base_0,
    __name = "Mouse"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Mouse = _class_0
end
return {
  Mouse = Mouse
}
