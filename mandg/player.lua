--dir: up=0,down=1,left=2,right=3
function build_monty()
  return {
    x = start_monty_x,
    y = start_monty_y,
    dir = 1,
    mov = false,
    box = { 4, 0, 11, 15 },
    dying = 0,
    death_count = 0,
    die = function(self)
      if self.dying == 0 then
        freeze()
        self.death_count += 1
        self.dying = 20
      end
    end,
    update = function(self)
      if self.dying > 0 then
        self.dying -= 1
        if self.dying == 0 then
          unfreeze()

          -- todo: move to start of screen
          self.y = 20
        end
      end
    end,
    draw = function(self)
      draw_monty(self)
    end
  }
end

function draw_monty(monty)
  if monty.dying > 0 then
    -- or monty.warp>0 then
    pal(3, flr(rnd(16)))
    pal(11, flr(rnd(16)))
  end

  --head
  draw_monty_row(monty, 1, 0)
  --feet
  if monty.mov then
    local offset = time_toggle(12)
    if monty.dir < 2 then
      local s1 = 5 + monty.dir + 16 * offset
      local s2 = 5 + monty.dir + 16 * abs(offset - 1)
      spr(s1, monty.x, monty.y + 8)
      spr(s2, monty.x + 8, monty.y + 8, 1, 1, true)
    else
      spr(7 + 16 * offset, monty.x, monty.y + 8, 2, 1, monty.dir == 2)
    end
  else
    --not moving
    draw_monty_row(monty, 17, 8)
  end

  pal()

  --if state.dig_sandwall or monty.dig_shoot>0 then
  -- draw spade
  --spr(54+monty.walk_step,monty.x-5,monty.y+6,1,1,false,monty.walk_step)
  --end
end

function draw_monty_row(monty, s, y_offset)
  if monty.dir < 2 then
    spr(s + monty.dir, monty.x, monty.y + y_offset)
    spr(s + monty.dir, monty.x + 8, monty.y + y_offset, 1, 1, true)
  else
    spr(s + 2, monty.x, monty.y + y_offset, 2, 1, monty.dir == 2)
  end
end