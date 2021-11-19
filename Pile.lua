local Entity
Entity = require("Entity").Entity
local CardValue
CardValue = require("Card").CardValue
local CARD_WIDTH, CARD_HEIGHT, PILE_Y_OFFSET, IMAGE_CARD_BACK, is_one_more, are_opposite_colors, get_ace_image, print_centered_text
do
  local _obj_0 = require("Util")
  CARD_WIDTH, CARD_HEIGHT, PILE_Y_OFFSET, IMAGE_CARD_BACK, is_one_more, are_opposite_colors, get_ace_image, print_centered_text = _obj_0.CARD_WIDTH, _obj_0.CARD_HEIGHT, _obj_0.PILE_Y_OFFSET, _obj_0.IMAGE_CARD_BACK, _obj_0.is_one_more, _obj_0.are_opposite_colors, _obj_0.get_ace_image, _obj_0.print_centered_text
end
local insert, remove
do
  local _obj_0 = table
  insert, remove = _obj_0.insert, _obj_0.remove
end
do
  local _class_0
  local _parent_0 = Entity
  local _base_0 = {
    add_card = function(self, card)
      return insert(self.cards, card)
    end,
    clear = function(self)
      self.cards = { }
    end,
    combine_pile = function(self, pile)
      local _list_0 = pile.cards
      for _index_0 = 1, #_list_0 do
        local card = _list_0[_index_0]
        self:add_card(card)
      end
    end,
    __tostring = function(self)
      local _list_0 = self.cards
      for _index_0 = 1, #_list_0 do
        local card = _list_0[_index_0]
        print(card)
      end
    end,
    draw = function(self)
      return error("not implemented in base class")
    end,
    is_valid_move = function(self, pile)
      return error("not implemented in base class")
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, cards)
      if cards == nil then
        cards = { }
      end
      _class_0.__parent.__init(self, 0, 0)
      self.cards = cards
    end,
    __base = _base_0,
    __name = "BasePile",
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
  BasePile = _class_0
end
do
  local _class_0
  local _parent_0 = BasePile
  local _base_0 = {
    draw = function(self)
      if #self.cards == 0 then
        love.graphics.rectangle("line", self.x, self.y, CARD_WIDTH, CARD_HEIGHT)
        return 
      end
      local index = 1
      local _list_0 = self.cards
      for _index_0 = 1, #_list_0 do
        local card = _list_0[_index_0]
        local y_pos = self.y + (PILE_Y_OFFSET * (index - 1))
        card:set_position(self.x, y_pos)
        card:draw()
        index = index + 1
      end
      local total_height = (PILE_Y_OFFSET * (#self.cards - 1)) + CARD_HEIGHT
      return love.graphics.rectangle("line", self.x, self.y, CARD_WIDTH, total_height)
    end,
    split_pile = function(self, card_index)
      local pile = TableauPile()
      local _list_0 = self.cards
      for _index_0 = card_index, #_list_0 do
        local card = _list_0[_index_0]
        pile:add_card(card)
      end
      for i = 1, (#self.cards - card_index + 1) do
        remove(self.cards)
      end
      return pile
    end,
    is_valid_move = function(self, pile)
      local top_card = self:get_last_card()
      local bottom_card = pile:get_top_card()
      if not (top_card) then
        return bottom_card.value == CardValue.King
      end
      return are_opposite_colors(top_card, bottom_card) and is_one_more(top_card, bottom_card)
    end,
    get_top_card = function(self)
      return self.cards[1]
    end,
    get_last_card = function(self)
      return self.cards[#self.cards]
    end,
    pop = function(self)
      return remove(self.cards)
    end,
    has_flipped_cards = function(self)
      local _list_0 = self.cards
      for _index_0 = 1, #_list_0 do
        local card = _list_0[_index_0]
        if card.flipped == true then
          return true
        end
      end
      return false
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TableauPile",
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
  TableauPile = _class_0
end
do
  local _class_0
  local _parent_0 = BasePile
  local _base_0 = {
    add_card = function(self, card)
      card:set_position(self.x, self.y)
      return _class_0.__parent.__base.add_card(self, card)
    end,
    split_pile = function(self)
      local pile = TableauPile()
      pile:add_card(remove(self.cards))
      return pile
    end,
    draw = function(self)
      if #self.cards == 0 then
        love.graphics.setColor(1, 1, 1, 0.3)
        love.graphics.draw(self.empty_image, self.x, self.y)
        love.graphics.setColor(1, 1, 1, 1)
      else
        self.cards[#self.cards]:draw()
      end
      return love.graphics.rectangle("line", self.x, self.y, CARD_WIDTH, CARD_HEIGHT)
    end,
    is_valid_move = function(self, pile)
      if #pile.cards ~= 1 then
        return false
      end
      local card = pile.cards[1]
      if card.suit ~= self.type then
        return false
      end
      if #self.cards == 0 then
        return card.value == CardValue.Ace
      end
      return is_one_more(card, self.cards[#self.cards])
    end,
    get_top_card = function(self)
      return self.cards[#self.cards]
    end,
    is_complete = function(self)
      if #self.cards ~= 13 then
        return false
      end
      local prev_card = self.cards[1]
      for i = 2, #self.cards do
        local card = self.cards[i]
        if not is_one_more(card, prev_card) then
          return false
        end
        prev_card = card
      end
      return true
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, type, ...)
      self.type = type
      _class_0.__parent.__init(self, ...)
      self.empty_image = get_ace_image(self.type)
    end,
    __base = _base_0,
    __name = "FoundationPile",
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
  FoundationPile = _class_0
end
do
  local _class_0
  local _parent_0 = BasePile
  local _base_0 = {
    draw = function(self)
      if #self.cards > 0 then
        love.graphics.draw(IMAGE_CARD_BACK, self.x, self.y)
      else
        print_centered_text("Click", self.x + (CARD_WIDTH / 2), self.y + (CARD_HEIGHT / 2) - 15)
        print_centered_text("To", self.x + (CARD_WIDTH / 2), self.y + (CARD_HEIGHT / 2))
        print_centered_text("Redeal", self.x + (CARD_WIDTH / 2), self.y + (CARD_HEIGHT / 2) + 15)
      end
      return love.graphics.rectangle("line", self.x, self.y, CARD_WIDTH, CARD_HEIGHT)
    end,
    pop = function(self)
      return remove(self.cards)
    end,
    is_valid_move = function(self, pile)
      return false
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "StockPile",
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
  StockPile = _class_0
end
do
  local _class_0
  local _parent_0 = BasePile
  local _base_0 = {
    add_card = function(self, card)
      card:set_position(self.x, self.y)
      return _class_0.__parent.__base.add_card(self, card)
    end,
    split_pile = function(self)
      local pile = TableauPile()
      pile:add_card(remove(self.cards))
      return pile
    end,
    get_top_card = function(self)
      return self.cards[#self.cards]
    end,
    draw = function(self)
      if #self.cards > 0 then
        self.cards[#self.cards]:draw()
      end
      return love.graphics.rectangle("line", self.x, self.y, CARD_WIDTH, CARD_HEIGHT)
    end,
    is_valid_move = function(self, pile)
      return false
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TalonPile",
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
  TalonPile = _class_0
end
return {
  TableauPile = TableauPile,
  FoundationPile = FoundationPile,
  StockPile = StockPile,
  TalonPile = TalonPile
}
