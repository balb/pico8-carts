function build_scenes()
  local tab = {}
  tab["title"] = build_scene_title()
  tab["main"] = build_scene_main()
  return tab
end

function build_scene_title()
  local monty_txt = [[
8""8""8
8  8  8 eeeee eeeee eeeee e    e
8e 8  8 8  88 8   8   8   8    8
88 8  8 8   8 8e  8   8e  8eeee8
88 8  8 8   8 88  8   88    88
88 8  8 8eee8 88  8   88    88
  ]]
  local and_txt = [[
        eeeee eeeee eeeee
        8   8 8   8 8   8
        8eee8 8e  8 8e  8
        88  8 88  8 88  8
        88  8 88  8 88ee8
  ]]
  local gerts_txt = [[
  8""""8
  8    " eeee eeeee eeeee eeeee
  8e     8    8   8   8   8   "
  88  ee 8eee 8eee8e  8e  8eeee
  88   8 88   88   8  88     88
  88eee8 88ee 88   8  88  8ee88
  ]]

  local init_count = 36
  local init_monty_y = 54

  return {
    count = init_count,
    init = function()
    end,
    start_text_x = 27,
    start_text_y = 42,
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
        switch_scene("main")
      end

      if self.mode >= 3 then
        self.start_text_x += 1
        if self.start_text_x > 127 then
          self.start_text_x = -80
          if self.start_text_y == 81 then
            self.start_text_y = 42
          else
            self.start_text_y = 81
          end
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

      if self.mode == 4 then
        self.py.y += 2
      end

      local y_offset = time_toggle(12, 2)
      if self.py.y < 64 then
        self.gerts.y = init_monty_y + y_offset
      else
        self.gerts.y += 2
      end

      self.gerts:update()
      self.py:update()
    end,
    draw = function(self)
      local col = 11

      if self.mode == 0 or self.mode >= 3 then
        print(monty_txt, 0, 4, col)
      end

      if self.mode == 1 or self.mode >= 3 then
        print(and_txt, 0, 50, col)
      end

      if self.mode == 2 or self.mode >= 3 then
        print(gerts_txt, 0, 88, col)
      end

      for x = 0, 127 do
        for y = 0, 127 do
          local p = pget(x, y)
          if p == 0 then
            if pget(x - 1, y) == col
                and pget(x + 1, y) == col then
              pset(x, y, col)
            elseif pget(x, y - 1) == col
                and pget(x, y + 1) == col then
              pset(x, y, col)
            end
          end
        end
      end

      local y_offset = time_toggle(12, 2)
      if self.mode == 0 or self.mode >= 3 then
        -- monty
        spr(2, 2, init_monty_y + y_offset)
        spr(2, 10, init_monty_y + y_offset, 1, 1, true)
        spr(18, 2, init_monty_y + 8 + y_offset)
        spr(18, 10, init_monty_y + 8 + y_offset, 1, 1, true)
      end

      if self.mode == 3 then
        print("hit ❎ or 🅾️ to start", self.start_text_x, self.start_text_y, flr(rnd(16)))
      end

      if self.mode == 2 or self.mode >= 3 then
        self.gerts:draw()
      end
      self.py:draw()
      if self.py.y > 64 then
        local help_x = self.gerts.x - 30
        local help_y = self.gerts.y - 10
        local help_width = 32
        local help_height = 16
        -- speach bubble
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

      local next_x = self.monty.x
      local next_y = self.monty.y

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
          if (btnp(❎) or btnp(🅾️)) and self.screen.sand_blob_choke == 0 then
            self.monty:fli_dig_sand_blob()
            self.screen:add_ent(build_sand_blob(self.monty.x - 4, self.monty.y + 6))
            self.screen.sand_blob_choke = 12
          end
          if (self.screen.sand_blob_choke > 0) self.screen.sand_blob_choke -= 1
        end

        -- end freeze
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

      if not map_collide(scene, next_x, next_y) then
        --screen wrap
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

      print("웃", 0, 0, 3)
      print(self.monty.death_count, 8, 0, 7)
    end
  }
end

function check_collision(monty, ent)
  if (ent.box == nil) return false
  local ex0 = ent.x + ent.box[1]
  local ey0 = ent.y + ent.box[2]
  local ew = ent.box[3]
  local eh = ent.box[4]

  local mx0 = monty.x + monty.box[1]
  local my0 = monty.y + monty.box[2]
  local mw = monty.box[3]
  local mh = monty.box[4]

  return ex0 < mx0 + mw and ex0 + ew > mx0
      and ey0 < my0 + mh and eh + ey0 > my0
end

-- todo: try not to use 'scene'
function map_collide(scene, next_x, next_y)
  local x = flr((next_x + 3) / 8)
  local y = flr(next_y / 8)
  local check_6 = next_y % 8 != 0

  local result = tile_collide(scene, x, y)
      or tile_collide(scene, x + 1, y)
      or tile_collide(scene, x, y + 1)
      or tile_collide(scene, x + 1, y + 1)
      or check_6
      and (tile_collide(scene, x, y + 2)
        or tile_collide(scene, x + 1, y + 2))

  return result
end

-- todo: try not to use 'scene'
function tile_collide(scene, x, y)
  return fget(mget(scene.map_x * 16 + x, scene.map_y * 16 + y), 0)
end