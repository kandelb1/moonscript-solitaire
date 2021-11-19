do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      return self.tween:update(dt)
    end,
    draw = function(self)
      return self.drawable:draw()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, tween, drawable)
      self.tween, self.drawable = tween, drawable
    end,
    __base = _base_0,
    __name = "Animation"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Animation = _class_0
end
return {
  Animation = Animation
}
