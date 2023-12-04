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
    update = function(ent)
      -- if (state.freeze) return
      local next_x = ent.path[ent.path_index].x
      local next_y = ent.path[ent.path_index].y
      if ent.x < next_x then
        ent.x += speed_x
      elseif ent.x > next_x then
        ent.x -= speed_x
      end

      if ent.y < next_y then
        ent.y += speed_y
      elseif ent.y > next_y then
        ent.y -= speed_y
      end

      if abs(ent.x - next_x) < 1
          and abs(ent.y - next_y) < 1 then
        --clamp
        ent.x = next_x
        ent.y = next_y
        ent.path_index += 1
        if (ent.path_index > count(ent.path)) ent.path_index = 1
      end
    end,
    draw = function(ent)
      --if ((map_x == 4 or map_x == 6) and map_y == 0) pal(1, 5)
      local tog_4 = time_toggle(12, 4)
      spr(
        16, ent.x, ent.y, 1, 1,
        tog_4 > 1,
        tog_4 == 1 or tog_4 == 2
      )
      --pal()
    end,
    box = { 1, 1, 6, 6 }
  }
end