export class Entity
  new: (x = 0, y = 0) =>
    @x = x
    @y = y
  
  set_position: (x, y) =>
    @x = x
    @y = y

{ :Entity }