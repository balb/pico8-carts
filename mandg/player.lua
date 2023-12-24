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
    has_spade = false,
    has_machete = false,
    has_bra = false,
    has_north_key = false,
    has_simple_key = false,
    dying = 0,
    -- dead flag for del_on_death
    dead = false,
    death_count = 0,
    die = function(self)
      if self.dying == 0 then
        self.death_count += 1
        self.dying = 20
      end
    end,
    move_to_pos = nil,
    move_to_pos_dir = nil,
    old_woman_done = false,
    on_change_screen = function(self, screen_key)
      self.init_x = self.x
      self.init_y = self.y
      self.init_dir = self.dir
      if screen_key == "31" then
        -- town square
        if self.has_machete then
          g_event = "has_machete_message"
        elseif self.has_north_key then
          g_event = "has_north_key_message"
        end
      elseif screen_key == "00" and not self.old_woman_done then
        -- old woman
        g_freeze = true
        self.move_to_pos = { x = 72, y = 56 }
        music(4)
        self.old_woman_done = true
      elseif screen_key == "03" then
        -- fli boss
        g_freeze = true
        self.move_to_pos = { x = 104, y = 72 }
        --boss theme
        music(5)
      elseif screen_key == "62" then
        if self.jonathon_phase == 0 and not self.has_bra then
          self.move_to_pos = { x = 24, y = 72 }
          self.jonathon_phase += 1
          music(4)
        elseif self.jonathon_phase == 1 and self.has_bra then
          self.move_to_pos = { x = 24, y = 72 }
          self.move_to_pos_dir = 3
          self.jonathon_phase += 1
          g_event = "jonathon_with_bra"
          music(4)
        end
      elseif screen_key == "30" then
        -- enter the north dungeon
        -- boss theme
        music(5)
      elseif screen_key == "60" then
        -- final boss
        g_freeze = true
        map_add_py_wall()
        self.init_x = 16
        self.init_y = 64
        self.move_to_pos = { x = 16, y = 64 }
      end
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
    -- foliage props
    foliage_on_done = nil,
    slash_foliage = false,
    foliage_countdown = 100,
    foliage_dir = 1,
    start_slash_foliage = function(self, on_done)
      self.foliage_on_done = on_done
      self.slash_foliage = true
    end,
    -- fli props
    fli_dig_shoot = 0,
    fli_dig_sand_blob = function(self)
      if (self.fli_dig_shoot == 0) self.fli_dig_shoot = 8
    end,
    -- py props
    py_punching = 0,
    py_punch = function(self, screen)
      if (self.py_punching == 0) self.py_punching = 8
      screen:add_ent(build_monty_fist(self.x + 20, self.y))
    end,
    -- jonathon props
    jonathon_phase = 0,
    --
    warp = 0,
    do_warp = function(self)
      g_freeze = true
      self.warp = 100
    end,
    update = function(self, screen)
      -- handle death
      if self.dying > 0 then
        self.dying -= 1
        if self.dying == 0 then
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

        -- clear the sand wall map tile
        mset(16, flr((self.y + 2) / 8) + 49, 64)

        if self.sandwall_countdown == 0 then
          self.dig_sandwall = false
          self.sandwall_on_done()
        end
      end

      -- foliage
      if self.slash_foliage then
        self.foliage_countdown -= 1

        -- walk up and down
        if self.y <= 8 or self.y >= 104 then
          self.foliage_dir *= -1
        end
        self.y += self.foliage_dir * 2

        -- clear the foliage map tile
        mset(63, flr((self.y + 2) / 8) + 17, 66)

        if self.foliage_countdown == 0 then
          self.slash_foliage = false
          self.has_machete = false
          self.foliage_on_done()
        end
      end

      -- fli
      if self.fli_dig_shoot > 0 then
        self.fli_dig_shoot -= 1
      end

      -- py
      if self.py_punching > 0 then
        self.py_punching -= 1
      end

      -- events
      if g_event == "fli_dead" then
        --g_freeze
        self.move_to_pos = { x = self.x, y = 72 }
        g_event = nil
      elseif g_event == "remove_bra_icon" then
        self.has_bra = false
        g_event = "add_bra_to_snake"
      elseif g_event == "py_dead" then
        self.move_to_pos = { x = 16, y = 64 }
        g_event = nil
      elseif g_event == "final_warp" then
        self:do_warp()
        g_event = "py_defeated"
      end

      -- move_to_pos
      if self.move_to_pos then
        self.mov = false
        if self.y < self.move_to_pos.y then
          self.y += 1
          self.mov = true
        elseif self.y > self.move_to_pos.y then
          self.y -= 1
          self.mov = true
        end

        if self.x < self.move_to_pos.x then
          self.x += 1
          self.mov = true
        elseif self.x > self.move_to_pos.x then
          self.x -= 1
          self.mov = true
        end
        if not self.mov then
          self.move_to_pos = nil
          if self.move_to_pos_dir then
            self.dir = self.move_to_pos_dir
            self.move_to_pos_dir = nil
          end
        end
      end

      -- warp
      if self.warp > 0 then
        self.warp -= 1
        self.dir = g_toggle4
        if self.warp == 0 then
          self.x = start_monty_x
          self.y = start_monty_y
          self.dir = 1
          self.mov = false
          g_event = "teleport"
          music(0)
        end
      end
    end,
    draw = function(self)
      draw_monty(self)
    end
  }
end

function draw_monty(monty)
  if monty.dying > 0 or monty.warp > 0 then
    pal(3, flr(rnd(16)))
    pal(11, flr(rnd(16)))
  end

  --head
  -- blue to black for the eyes
  pal(12, 0)
  draw_monty_row(monty, 1, 0)
  pal()
  --feet
  if monty.mov then
    if monty.dir < 2 then
      local s1 = 5 + monty.dir + 16 * g_toggle2
      local s2 = 5 + monty.dir + 16 * abs(g_toggle2 - 1)
      spr(s1, monty.x, monty.y + 8)
      spr(s2, monty.x + 8, monty.y + 8, 1, 1, true)
    else
      spr(7 + 16 * g_toggle2, monty.x, monty.y + 8, 2, 1, monty.dir == 2)
    end
  else
    --not moving
    draw_monty_row(monty, 17, 8)
  end

  pal()

  -- top right icon
  if monty.has_spade then
    spr(54, 120, -1)
  elseif monty.has_machete then
    spr(14, 120, 0)
  elseif monty.has_bra then
    spr(104, 120, -1)
  elseif monty.has_north_key then
    spr(13, 120, 0)
  elseif monty.has_simple_key then
    spr(47, 120, 0)
  end

  if monty.dig_sandwall or monty.fli_dig_shoot > 0 then
    -- draw spade
    spr(54 + g_toggle2, monty.x - 5, monty.y + 6, 1, 1, false, g_toggle2)
  elseif monty.slash_foliage then
    -- draw machete
    local s = 14
    if g_toggle2 == 1 then
      s = 85
    end
    spr(s, monty.x + 12, monty.y + 6)
  end
end

function draw_monty_row(monty, s, y_offset)
  if monty.dir < 2 then
    spr(s + monty.dir, monty.x, monty.y + y_offset)
    spr(s + monty.dir, monty.x + 8, monty.y + y_offset, 1, 1, true)
  else
    spr(s + 2, monty.x, monty.y + y_offset, 2, 1, monty.dir == 2)
  end
end