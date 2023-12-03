function build_idiot(start_x, start_y, min_x, max_x)
  return {
    x = start_x, y = start_y,
    min_x = min_x, max_x = max_x,
    speed = 0.75,
    cntr = 0,
    update = function(self)
      -- if (state.freeze) return
      self.x += self.speed
      if self.x < self.min_x or self.x > self.max_x then
        self.speed *= -1
        self.x += self.speed
      end
      self.cntr += 1
      if (self.cntr == 9) self.cntr = 0
    end,
    draw = function(self)
      local s = 38
      if (self.cntr < 5) s = 39
      spr(s, self.x, self.y)
    end,
    box = { 1, 1, 6, 6 }
  }
end