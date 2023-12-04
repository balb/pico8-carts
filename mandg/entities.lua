function build_idiot(start_x, start_y, min_x, max_x)
  local speed = 0.75
  return {
    x = start_x, y = start_y,
    min_x = min_x, max_x = max_x,

    update = function(self)
      -- if (state.freeze) return
      self.x += speed
      if self.x < self.min_x or self.x > self.max_x then
        speed *= -1
        self.x += speed
      end
    end,
    draw = function(self)
      local s = 38 + time_toggle(10, 2)
      spr(s, self.x, self.y)
    end,
    box = { 1, 1, 6, 6 }
  }
end

function build_fuzzy(start_x, start_y, path, path_index)
  local speed_x = 0.75
  local speed_y = 0.75

  return {
    x = start_x, y = start_y,
    path = path,
    path_index = path_index,
    update = function(self)
      -- if (state.freeze) return
      local next_x = self.path[self.path_index].x
      local next_y = self.path[self.path_index].y
      if self.x < next_x then
        self.x += speed_x
      elseif self.x > next_x then
        self.x -= speed_x
      end

      if self.y < next_y then
        self.y += speed_y
      elseif self.y > next_y then
        self.y -= speed_y
      end

      if abs(self.x - next_x) < 1
          and abs(self.y - next_y) < 1 then
        --clamp
        self.x = next_x
        self.y = next_y
        self.path_index += 1
        if (self.path_index > count(self.path)) self.path_index = 1
      end
    end,
    draw = function(self)
      --if ((map_x == 4 or map_x == 6) and map_y == 0) pal(1, 5)
      local tog_4 = time_toggle(12, 4)
      spr(
        16, self.x, self.y, 1, 1,
        tog_4 > 1,
        tog_4 == 1 or tog_4 == 2
      )
      --pal()
    end,
    box = { 1, 1, 6, 6 }
  }
end

function build_firestone(x, y, dir, t, dist)
  local s = 32
  local flip_x = false
  local flip_y = false
  if (dir < 2) s = 48
  return {
    x = x, y = y,
    timer = 0,
    arrow_added = false,
    update = function(self, screen)
      self.timer = time_toggle(18, 18)
      if self.timer == t then
        if not self.arrow_added then
          local x_offset = 0
          local y_offset = 0
          if dir == 3 then
            x_offset = 8
          elseif dir == 1 then
            y_offset = 8
          end
          screen:add_ent(build_arrow(x + x_offset, y + y_offset, dir, dist))
          self.arrow_added = true
        end
      else
        self.arrow_added = false
      end
    end,
    draw = function(self)
      local s2 = s
      if self.timer == t then
        s2 += 1
      elseif self.timer == t + 1 then
        s2 += 2
      end
      spr(s2, x, y, 1, 1, flip_x, flip_y)
      -- print(self.timer, 96, 0)
    end,
    box = { 1, 1, 6, 6 }
  }
end

function build_arrow(start_x, start_y, dir, dist)
  local speed = 2.5
  return {
    x = start_x, y = start_y,
    dist = dist,
    update = function(self, screen)
      if dir == 0 then
        self.y -= speed
      elseif dir == 1 then
        self.y += speed
      elseif dir == 2 then
        self.x -= speed
      else
        self.x += speed
      end
      self.dist -= speed
      if (self.dist <= -2) screen:del_ent(self)
    end,
    draw = function(self)
      local s = 35
      if (dir < 2) s = 51
      spr(s, self.x, self.y)
    end,
    box = { 1, 1, 6, 6 }
  }
end