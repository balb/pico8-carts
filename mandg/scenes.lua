function build_scenes()
  local tab = {}
  tab["title"] = build_scene_title()
  tab["main"] = build_scene_main()
  return tab
end

function build_scene_title()
  return {
    init = function()
    end,

    start_text_x = 27,
    start_text_x_inc = 1,
    start_text_y = 69,
    start_text_y_inc = 1,

    update = function(self)
      if btnp(❎) or btnp(🅾️) then
        switch_scene("main")
      end

      self.start_text_x += self.start_text_x_inc
      self.start_text_y += self.start_text_y_inc
      if (self.start_text_x == 39 or self.start_text_x == 0) self.start_text_x_inc *= -1
      if (self.start_text_y == 120 or self.start_text_y == 0) self.start_text_y_inc *= -1
    end,
    title_txt = [[
8""8""8
8  8  8 eeeee eeeee eeeee e    e
8e 8  8 8  88 8   8   8   8    8
88 8  8 8   8 8e  8   8e  8eeee8
88 8  8 8   8 88  8   88    88
88 8  8 8eee8 88  8   88    88

       eeeee eeeee eeeee
       8   8 8   8 8   8
       8eee8 8e  8 8e  8
       88  8 88  8 88  8
       88  8 88  8 88ee8

 8""""8
 8    " eeee eeeee eeeee eeeee
 8e     8    8   8   8   8   "
 88  ee 8eee 8eee8e  8e  8eeee
 88   8 88   88   8  88     88
 88eee8 88ee 88   8  88  8ee88
]],
    draw = function(self)
      local col = 11
      print(self.title_txt, 0, 4, col)
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

      spr(2, 2, 50)
      spr(2, 10, 50, 1, 1, true)
      spr(18, 2, 58)
      spr(18, 10, 58, 1, 1, true)

      print("hit ❎ or 🅾️ to start", self.start_text_x, self.start_text_y, flr(rnd(16)))
      color(7)
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

      if self.screen.scene_update_handler then
        self.screen:scene_update_handler(self.monty)
        self.screen:update()
        self.monty:update()
        return
      end

      local next_x = self.monty.x
      local next_y = self.monty.y

      if freeze_enemies then
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
          self.monty:stash_pos()
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
  --if ent.on_collide != nil then
  --  ent.on_collide(ent)
  --else
  --normal enemy
  --  return true
  --end
end

function map_collide(scene, next_x, next_y)
  local x = flr((next_x + 3) / 8)
  local y = flr(next_y / 8)
  local check_6 = next_y % 8 != 0
  --collide_sandwall=false

  local result = tile_collide(scene, x, y)
      or tile_collide(scene, x + 1, y)
      or tile_collide(scene, x, y + 1)
      or tile_collide(scene, x + 1, y + 1)
      or check_6
      and (tile_collide(scene, x, y + 2)
        or tile_collide(scene, x + 1, y + 2))

  --if(collide_sandwall)add_ent(build_sandwall())
  return result
end

function tile_collide(scene, x, y)
  --if fget(mget((scene.map_x*16)+x,(scene.map_y*16)+y),1) then
  --  collide_sandwall=true
  --end
  return fget(mget(scene.map_x * 16 + x, scene.map_y * 16 + y), 0)
end