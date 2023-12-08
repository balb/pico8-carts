function build_screens()
  local tab = {}
  tab["00"] = build_screen_desert_old_woman()
  tab["10"] = build_screen_desert_top_firestones()
  tab["20"] = build_screen_desert_fuzzies()
  tab["30"] = build_screen({})
  tab["40"] = build_screen({})
  tab["50"] = build_screen({})
  tab["60"] = build_screen({})
  tab["70"] = build_screen({})
  tab["01"] = build_screen({})
  tab["11"] = build_screen_desert_5_idiots()
  tab["21"] = build_screen({ build_idiot(88, 88, 80, 112), build_idiot(56, 56, 40, 64) })
  tab["31"] = build_screen({})
  tab["41"] = build_screen({})
  tab["51"] = build_screen({})
  tab["61"] = build_screen({})
  tab["71"] = build_screen({})
  tab["02"] = build_screen({})
  tab["12"] = build_screen_desert_dead_end()
  tab["22"] = build_screen({})
  tab["32"] = build_screen({})
  tab["42"] = build_screen({})
  tab["52"] = build_screen({})
  tab["62"] = build_screen({})
  tab["72"] = build_screen({})
  tab["03"] = build_screen({})
  tab["13"] = build_screen_desert_sand_wall()
  tab["23"] = build_screen({})
  tab["33"] = build_screen({})
  tab["43"] = build_screen({})
  tab["53"] = build_screen({})
  tab["63"] = build_screen({})
  tab["73"] = build_screen({})
  return tab
end

function build_screen(ents)
  return {
    ents = ents,
    add_ent = function(self, ent)
      add(self.ents, ent)
    end,
    del_ent = function(self, ent)
      del(self.ents, ent)
    end,
    scene_update_handler = nil,
    update = function(self)
      foreach(
        self.ents, function(ent)
          ent:update(self)
        end
      )
    end,
    draw = function(self)
      foreach(
        self.ents, function(ent)
          ent:draw()
        end
      )
    end
  }
end

function build_screen_desert_old_woman()
  local screen = build_screen({ build_old_woman() })
  screen.scene_update_handler = function(self, monty)
    if (monty.x > 72) monty.x -= 1
    if (monty.y < 56) monty.y += 1
    if (monty.x == 72 and monty.y == 56) monty.mov = false
  end
  return screen
end

function build_screen_desert_top_firestones()
  local ents = {
    build_firestone(8, 40, 3, 8, 32),
    build_firestone(8, 72, 3, 12, 40),
    build_firestone(8, 96, 3, 16, 24),
    build_firestone(48, 16, 1, 2, 64),
    build_firestone(72, 16, 1, 14, 64)
  }
  return build_screen(ents)
end

function build_screen_desert_fuzzies()
  local ents = {}
  local path = {
    { x = 24, y = 24 },
    { x = 88, y = 24 },
    { x = 88, y = 56 },
    { x = 24, y = 56 }
  }
  add(ents, build_fuzzy(24, 24, path, 2))
  add(ents, build_fuzzy(56, 24, path, 2))
  add(ents, build_fuzzy(88, 24, path, 3))
  add(ents, build_fuzzy(88, 56, path, 4))
  add(ents, build_fuzzy(56, 56, path, 4))
  add(ents, build_fuzzy(24, 56, path, 1))
  path = {
    { x = 80, y = 72 },
    { x = 24, y = 72 },
    { x = 24, y = 96 },
    { x = 80, y = 96 }
  }
  add(ents, build_fuzzy(24, 72, path, 3))
  add(ents, build_fuzzy(32, 96, path, 4))
  add(ents, build_fuzzy(64, 96, path, 4))
  add(ents, build_fuzzy(80, 80, path, 1))
  add(ents, build_fuzzy(56, 72, path, 2))
  return build_screen(ents)
end

function build_screen_desert_5_idiots()
  return build_screen({
    build_idiot(16, 72, 8, 48),
    build_idiot(40, 88, 8, 48),
    build_idiot(72, 64, 72, 112),
    build_idiot(88, 80, 72, 112),
    build_idiot(104, 96, 72, 112)
  })
end

function build_screen_desert_dead_end()
  local path = {
    { x = 80, y = 40 },
    { x = 104, y = 40 },
    { x = 104, y = 64 },
    { x = 80, y = 64 }
  }
  return build_screen({
    build_fuzzy(80, 40, path, 1),
    build_fuzzy(104, 64, path, 3),
    build_firestone(56, 64, 1, 8, 24),
    build_firestone(64, 64, 1, 8, 24)
  })
end

-- todo: pause ents
-- todo: move scene_update_handler stuff to ent
function build_screen_desert_sand_wall()
  local path1 = {
    { x = 24, y = 24 },
    { x = 40, y = 24 },
    { x = 40, y = 48 },
    { x = 24, y = 48 }
  }
  local path2 = {
    { x = 24, y = 80 },
    { x = 40, y = 80 },
    { x = 40, y = 104 },
    { x = 24, y = 104 }
  }
  local screen = build_screen({
    build_idiot(112, 48, 72, 112),
    build_idiot(72, 80, 72, 112),
    build_fuzzy(24, 24, path1, 1),
    build_fuzzy(40, 104, path2, 3),
    build_sandwall()
  })

  screen.text_ticker = nil
  screen.on_collide_with_sandwall = function(self, monty)
    self.text_ticker = build_text_ticker("if only i had a spade\nto dig my way through...")
    self:add_ent(self.text_ticker)
    monty.mov = false
    self.scene_update_handler = function(self)
      if self.text_ticker.ready and (btnp(❎) or btnp(🅾️)) then
        self:del_ent(self.text_ticker)
        self.scene_update_handler = nil
      end
    end
  end

  return screen
end