--dir: up=0,down=1,left=2,right=3
function build_monty()
  return {
    x = start_monty_x,
    y = start_monty_y,
    dir = 1,
    init_x = start_monty_x,
    init_y = start_monty_y,
    init_dir = 1,
    mov = false,
    box = { 4, 0, 11, 15 },

    has_spade = true,

    frozen = false,

    dying = 0,

    -- dead flag for del_on_death
    dead = false,
    death_count = 0,
    die = function(self)
      if self.dying == 0 then
        self.frozen = true
        self.death_count += 1
        self.dying = 20
      end
    end,
    stash_pos = function(self)
      self.init_x = self.x
      self.init_y = self.y
      self.init_dir = self.dir
    end,
    -- sandwall props
    sandwall_on_done = nil,
    dig_sandwall = false,
    sandwall_countdown = 100,
    sandwall_dir = 1,
    start_dig_sandwall = function(self, on_done)
      self.sandwall_on_done = on_done
      self.dig_sandwall = true
    end,
    update = function(self)
      -- handle death
      if self.dying > 0 then
        self.dying -= 1
        if self.dying == 0 then
          self.frozen = false
          self.dead = true
          -- reset position
          self.x = self.init_x
          self.y = self.init_y
          self.dir = self.init_dir
        end
      end

      -- sandwall
      if self.dig_sandwall then
        self.sandwall_countdown -= 1

        -- walk up and down
        if self.y <= 8 or self.y >= 104 then
          self.sandwall_dir *= -1
        end
        self.y += self.sandwall_dir * 2

        if self.sandwall_countdown == 0 then
          self.dig_sandwall = false
          self.sandwall_on_done()
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
    local offset = time_toggle(12, 2)
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

  -- top right icon
  if monty.has_spade then
    spr(54, 120, -1)
    --[[ elseif state.has_north_key then
  spr(13,120,0)
 elseif state.has_simple_key then
  spr(47,120,0)
 elseif state.has_bra then
  spr(104,120,-1)   ]]
  end

  -- sandwall
  if monty.dig_sandwall then
    -- clear the sand wall
    mset(16, flr((monty.y + 2) / 8) + 49, 64)

    -- draw spade
    local cntr_m2 = time_toggle(12, 2)
    spr(54 + cntr_m2, monty.x - 5, monty.y + 6, 1, 1, false, cntr_m2)
  end

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