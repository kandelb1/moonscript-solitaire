enum = function(values)
  return setmetatable((function()
    local _tbl_0 = { }
    for _index_0 = 1, #values do
      local v = values[_index_0]
      _tbl_0[v] = v
    end
    return _tbl_0
  end)(), {
    __index = function(self, k)
      return error("don't know what " .. tostring(k) .. " is.")
    end
  })
end
return {
  enum = enum
}
