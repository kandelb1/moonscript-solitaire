export enum = (values) ->
  setmetatable {v,v for v in *values}, __index: (k) =>
    error "don't know what #{k} is."

{ :enum }