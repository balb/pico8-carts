function build_scenes()
  local tab = {}
  tab["title"] = build_scene_title()
  tab["main"] = build_scene_main()
  tab["credits"] = {
    init = empty_func,
    update = empty_func,
    draw = function()
      print [[


thanks for playing 

monty and gerts 
by the walteezers, 2023

staff
-----

bertie: production and design
isaac:  direction and vibes
nikki:  tea and biscuits
mark:   programming

      ]]
    end
  }
  return tab
end

function build_scene_title()
  local init_count, init_monty_y = 36, 54
  return {
    count = init_count,
    init = empty_func,
    start_text_x = 27,
    -- modes
    -- 0: show monty
    -- 1: show 'and'
    -- 2: show gerts
    -- 3: show both and start text
    -- 4: in comes py
    mode = 0,
    gerts = build_gerts(108, init_monty_y),
    py = build_py(96, -32),
    update = function(self)
      if btnp(❎) or btnp(🅾️) then
        self.mode = 4
      end
      if self.mode == 4 and self.py.y > 128 then
        switch_scene "main"
      end

      if self.mode >= 3 then
        self.start_text_x += 1
        if self.start_text_x > 127 then
          self.start_text_x = -80
        end
      end

      if self.mode < 3 then
        if self.count > 0 then
          self.count -= 1
        else
          self.count = init_count
          self.mode += 1
        end
      end

      if (self.mode == 4) self.py.y += 2
      if self.py.y < 64 then
        self.gerts.y = init_monty_y + g_toggle2
      else
        self.gerts.y += 2
      end

      self.gerts:update()
      self.py:update()
    end,
    draw = function(self)
      map(0, 16, 0, 0)

      if (self.mode == 0) rectfill(0, 40, 120, 120, 0)
      if self.mode == 1 then
        rectfill(0, 8, 120, 40, 0)
        rectfill(0, 80, 120, 120, 0)
      end
      if (self.mode == 2) rectfill(0, 8, 120, 80, 0)
      if self.mode == 0 or self.mode >= 3 then
        -- monty
        spr(2, 2, init_monty_y + g_toggle2)
        spr(2, 10, init_monty_y + g_toggle2, 1, 1, true)
        spr(18, 2, init_monty_y + 8 + g_toggle2)
        spr(18, 10, init_monty_y + 8 + g_toggle2, 1, 1, true)
      end

      if (self.mode == 3) print("hit ❎ or 🅾️ to start", self.start_text_x, 116, flr(rnd(16)))
      if self.mode == 2 or self.mode >= 3 then
        self.gerts:draw()
      end
      self.py:draw()
      if self.py.y > 64 then
        -- speach bubble
        local help_x, help_y, help_width, help_height = self.gerts.x - 30, self.gerts.y - 10, 32, 16
        rectfill(help_x, help_y, help_x + help_width, help_y + help_height, 7)
        -- top left
        pset(help_x, help_y, 0)
        pset(help_x, help_y + 1, 0)
        pset(help_x + 1, help_y, 0)
        -- top right
        pset(help_x + help_width, help_y, 0)
        pset(help_x + help_width, help_y + 1, 0)
        pset(help_x + help_width - 1, help_y, 0)
        -- bottom left
        pset(help_x, help_y + help_height, 0)
        pset(help_x + 1, help_y + help_height, 0)
        pset(help_x, help_y + help_height - 1, 0)

        print("help!!!", help_x + 3, help_y + 6)
      end
    end
  }
end

function build_scene_main()
  return {
    map_x = start_map_x,
    map_y = start_map_y,
    screens = build_screens(),
    screen = nil,
    monty = build_monty(),
    init = function(self)
      self:set_screen()
    end,
    set_screen = function(self)
      self.screen = self.screens[self.map_x .. self.map_y]
    end,
    update_handler = nil,
    update = function(self)
      -- teleport back to town sq
      if g_event == "teleport" then
        g_event = nil
        self.map_x = start_map_x
        self.map_y = start_map_y
        self.monty:on_change_screen(self.map_x .. self.map_y)
        self:set_screen()
        g_freeze = false
        return
      end

      -- handle dying
      if self.monty.dying > 0 then
        -- need to update monty to do death etc.
        self.monty:update()
        if self.monty.dead then
          foreach(
            self.screen.ents, function(ent)
              if (ent.del_on_death) self.screen:del_ent(ent)
            end
          )

          self.monty.dead = false
        end
        return
      end

      local next_x, next_y = self.monty.x, self.monty.y
      if g_freeze then
        self.monty.mov = false
      else
        self.monty.mov = true
        if btn(⬆️) then
          self.monty.dir = 0
          next_y -= 1
        elseif btn(⬇️) then
          self.monty.dir = 1
          next_y += 1
        elseif btn(⬅️) then
          self.monty.dir = 2
          next_x -= 1
        elseif btn(➡️) then
          self.monty.dir = 3
          next_x += 1
        else
          self.monty.mov = false
        end

        -- fli boss
        if self.screen.boss_fli then
          -- stay put on death
          self.monty.init_x = self.monty.x
          self.monty.init_y = self.monty.y
          -- face fli and lock x pos
          self.monty.dir = 2
          next_x = self.monty.x
          -- fire!
          if (btnp(❎) or btnp(🅾️)) and self.screen.fire_button_choke == 0 then
            self.monty:fli_dig_sand_blob()
            self.screen:add_ent(build_sand_blob(self.monty.x - 4, self.monty.y + 6))
            self.screen.fire_button_choke = 12
          end
          if (self.screen.fire_button_choke > 0) self.screen.fire_button_choke -= 1
        elseif self.screen.boss_py then
          -- punch!
          if (btnp(❎) or btnp(🅾️)) and self.screen.fire_button_choke == 0 then
            self.monty:py_punch(self.screen)
            self.screen.fire_button_choke = 20
          end
          if (self.screen.fire_button_choke > 0) self.screen.fire_button_choke -= 1
        end

        -- end freeze check
      end

      local collision = false
      foreach(
        self.screen.ents, function(ent)
          local ent_collision = check_collision(self.monty, ent)
          if ent_collision and ent.on_collide then
            ent:on_collide(self.monty, self.screen)
          else
            collision = collision or ent_collision
          end
        end
      )

      if collision then
        self.monty:die()
      end

      if not map_collide(next_x, next_y) then
        local change_screen = false
        if next_x == -5 then
          next_x = 116
          self.map_x -= 1
          change_screen = true
        elseif next_x == 117 then
          next_x = -4
          self.map_x += 1
          change_screen = true
        end

        if next_y == 5 then
          next_y = 116
          self.map_y -= 1
          change_screen = true
        elseif next_y == 117 then
          next_y = 6
          self.map_y += 1
          change_screen = true
        end

        self.monty.x = next_x
        self.monty.y = next_y

        if change_screen then
          self.monty:on_change_screen(self.map_x .. self.map_y)
          self:set_screen()
        end
      end

      self.screen:update()
      self.monty:update()
    end,
    draw = function(self)
      map(self.map_x * 16, self.map_y * 16, 0, 0)
      -- print(self.map_x .. "," .. self.map_y, 64, 0)
      self.screen:draw()
      self.monty:draw()

      --print("웃", 0, 0, 3)

      spr(79, 0, 0)
      print(self.monty.death_count, 10, 1, iif(self.monty.dying == 0, 7, 8))
      --color(7)
    end
  }
end

function check_collision(monty, ent)
  if (ent.box == nil) return false
  local ex0, ey0, ew, eh = ent.x + ent.box[1], ent.y + ent.box[2], ent.box[3], ent.box[4]
  local mx0, my0, mw, mh = monty.x + monty.box[1], monty.y + monty.box[2], monty.box[3], monty.box[4]
  return ex0 < mx0 + mw and ex0 + ew > mx0
      and ey0 < my0 + mh and eh + ey0 > my0
end

function map_collide(next_x, next_y)
  local x, y, check_6 = flr((next_x + 3) / 8), flr(next_y / 8), next_y % 8 ~= 0
  local result = tile_collide(x, y)
      or tile_collide(x + 1, y)
      or tile_collide(x, y + 1)
      or tile_collide(x + 1, y + 1)
      or check_6
      and (tile_collide(x, y + 2)
        or tile_collide(x + 1, y + 2))

  return result
end

function tile_collide(x, y)
  return fget(mget(g_scene.map_x * 16 + x, g_scene.map_y * 16 + y), 0)
end