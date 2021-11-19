export class Animation
  new: (@tween, @drawable) =>
  
  update: (dt) => @tween\update dt

  draw: => @drawable\draw!

{ :Animation }