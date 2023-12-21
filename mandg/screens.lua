function build_screens()
  local tab = {}
  tab["00"] = build_screen({ build_old_woman() })
  tab["10"] = build_screen_desert_top_firestones()
  tab["20"] = build_screen_desert_fuzzies()
  --tab["30"] = build_screen({})
  --tab["40"] = build_screen({})
  --tab["50"] = build_screen({})
  --tab["60"] = build_screen({})
  --tab["70"] = build_screen({})
  --tab["01"] = build_screen({})
  tab["11"] = build_screen_desert_5_idiots()
  tab["21"] = build_screen({ build_idiot(88, 88, 80, 112), build_idiot(56, 56, 40, 64) })
  tab["31"] = build_screen_town_square()
  tab["41"] = build_screen({
    -- forest 1
    build_jazzer(32, 88, 72, 112),
    build_idiot(96, 64, 64, 112),
    build_idiot(96, 80, 72, 112)
  })
  --tab["51"] = build_screen({})
  --tab["61"] = build_screen({})
  tab["71"] = build_screen({
    -- forest firestone walk
    build_firestone(16, 32, 3, 0, 88),
    build_firestone(8, 48, 3, 8, 96),
    build_firestone(16, 64, 3, 0, 88),
    build_firestone(8, 80, 3, 8, 96),
    build_firestone(16, 96, 3, 0, 88)
  })
  --tab["02"] = build_screen({})
  tab["12"] = build_screen_desert_dead_end()
  --tab["22"] = build_screen({})
  --tab["32"] = build_screen({})
  tab["42"] = build_screen_forest_2()
  tab["52"] = build_screen_forest_lake_fuzzies()
  tab["62"] = build_screen_forest_jonathon()
  --tab["72"] = build_screen({})
  tab["03"] = build_screen_desert_fli_boss()
  tab["13"] = build_screen_desert_sand_wall()
  tab["23"] = build_screen_desert_cactus_and_spade()
  --tab["33"] = build_screen({})
  --tab["43"] = build_screen({})
  --tab["53"] = build_screen({})

  -- todo
  tab["63"] = build_screen({})
  tab["73"] = build_screen_forest_monkey()
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

function build_screen_town_square()
  return build_screen({
    build_gerts(56, 64),
    build_textbox2({
      "help me monty!",
      "i was kidnapped by an evil pie\nand imprisoned in this cage...",
      "you must find his whereabouts\nif i am to be freed.",
      "head west into the desert and\nsearch there for clues.",
      "good luck!"
    }),
    build_door(56, 0, "north_key"),
    build_foliage()
  })
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

function build_screen_desert_sand_wall()
  local path1 = {
    { x = 24, y = 32 },
    { x = 40, y = 32 },
    { x = 40, y = 56 },
    { x = 24, y = 56 }
  }
  local path2 = {
    { x = 24, y = 80 },
    { x = 40, y = 80 },
    { x = 40, y = 104 },
    { x = 24, y = 104 }
  }
  return build_screen({
    build_idiot(112, 48, 72, 112),
    build_idiot(72, 80, 72, 112),
    build_fuzzy(24, 32, path1, 1),
    build_fuzzy(40, 104, path2, 3),
    build_sandwall()
  })
end

function build_screen_desert_cactus_and_spade()
  local path = {
    { x = 24, y = 24 },
    { x = 88, y = 24 },
    { x = 88, y = 96 },
    { x = 24, y = 96 }
  }
  return build_screen({
    build_cactus(88, 24, path, 2),
    build_spade(96, 24)
  })
end

function build_screen_desert_fli_boss()
  local fli = build_fli()
  local screen = build_screen({ fli })
  screen.boss_fli = fli
  screen:add_ent(build_textbox2(
    {
      "i am the mighty fli!...",
      "how dare you enter my lair!...",
      "you will now pay for this\nfoolhardy intrusion!"
    }, function()
      fli:start_fight()
    end
  ))

  screen.sand_blob_choke = 0
  return screen
end

function build_screen_forest_2()
  local path1 = {
    { x = 72, y = 48 },
    { x = 96, y = 48 },
    { x = 96, y = 72 },
    { x = 72, y = 72 }
  }
  return build_screen({
    build_firestone(56, 40, 2, 14, 40),
    build_firestone(64, 80, 1, 2, 24),
    build_idiot(96, 40, 72, 104),
    build_fuzzy(72, 48, path1, 1),
    build_idiot(32, 48, 8, 48),
    build_jazzer(56, 88, 88, 112)
  })
end

function build_screen_forest_lake_fuzzies()
  local path1 = {
    { x = 48, y = 64 },
    { x = 72, y = 64 },
    { x = 72, y = 80 },
    { x = 80, y = 80 },
    { x = 80, y = 104 },
    { x = 40, y = 104 },
    { x = 40, y = 96 },
    { x = 32, y = 96 },
    { x = 32, y = 80 },
    { x = 40, y = 80 },
    { x = 40, y = 72 },
    { x = 48, y = 72 }
  }

  local screen = build_screen({})
  foreach(
    { 3, 5, 7, 9, 11 },
    function(i)
      screen:add_ent(build_fuzzy(path1[i].x, path1[i].y, path1, i))
    end
  )

  return screen
end

function build_screen_forest_jonathon()
  local jonathon = build_jonathon(84, 72)
  local screen = build_screen({
    jonathon,
    build_textbox2(
      {
        "greetings...",
        "my name is jon-a-thon...",
        "i live in the am-a-zon...",
        "i have a snake..."
      }, function()
        jonathon.phase = 1
      end
    )
  })
  return screen
end

function build_screen_forest_monkey()
  local path = {
    { x = 24, y = 32 },
    { x = 88, y = 32 },
    { x = 88, y = 96 },
    { x = 24, y = 96 }
  }
  return build_screen({
    build_monkey(88, 24, path, 2),
    build_bra(96, 24)
  })
end