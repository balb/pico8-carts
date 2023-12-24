function build_screens()
  local tab = {}
  tab["00"] = build_screen { build_old_woman() }
  tab["10"] = build_screen_desert_top_firestones()
  tab["20"] = build_screen_desert_fuzzies()
  tab["30"] =
    -- enter the north dungeon
    build_screen {
      build_firestone(24, 88, 3, 8, 32),
      build_jazzer(72, 64, 48, 81),
      build_jazzer(96, 56, 48, 81)
    }
  tab["40"] = build_screen_north_dungeon_fuzzies()
  tab["50"] =
    -- north dungeon locked door
    build_screen {
      build_door(113, 56, "simple_key"),
      build_firestone(72, 40, 3, 8, 24),
      build_firestone(64, 80, 3, 16, 32),
      build_idiot(24, 96, 8, 88)
    }

  tab["60"] = build_screen_final_boss()
  tab["11"] = build_screen_desert_5_idiots()
  tab["21"] = build_screen {
    build_idiot(88, 88, 80, 112),
    build_idiot(56, 56, 40, 64)
  }
  tab["31"] = build_screen_town_square()
  tab["41"] =
    -- jungle 1
    build_screen {
      build_jazzer(32, 88, 72, 112),
      build_idiot(96, 64, 64, 112),
      build_idiot(96, 80, 72, 112)
    }
  tab["51"] = build_screen_north_dungeon_skellington()
  tab["12"] = build_screen_desert_dead_end()
  tab["42"] = build_screen_jungle_2()
  tab["52"] = build_screen_jungle_lake_fuzzies()
  tab["62"] = build_screen_jungle_jonathon()
  tab["03"] = build_screen_desert_fli_boss()
  tab["13"] = build_screen_desert_sand_wall()
  tab["23"] = build_screen_desert_cactus_and_spade()
  tab["63"] =
    -- jungle firestone walk
    build_screen {
      build_firestone(102, 32, 2, 0, 88),
      build_firestone(96, 48, 2, 8, 80),
      build_firestone(64, 64, 2, 3, 48),
      build_firestone(96, 80, 2, 8, 80),
      build_firestone(102, 96, 2, 0, 88)
    }
  tab["73"] = build_screen_jungle_monkey()
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
  return build_screen {
    build_gerts(56, 64),
    build_textbox2(
      {
        "help me monty!",
        "i was kidnapped by an evil pie\nand imprisoned in this cage...",
        "you must find his whereabouts\nif i am to be freed.",
        "head west into the desert and\nsearch there for clues.",
        "good luck!"
      }, function()
        music(0)
      end
    ),
    build_door(56, 0, "north_key"),
    build_foliage()
  }
end

function build_screen_desert_top_firestones()
  return build_screen {
    build_firestone(8, 40, 3, 8, 32),
    build_firestone(8, 72, 3, 12, 40),
    build_firestone(8, 96, 3, 16, 24),
    build_firestone(48, 16, 1, 2, 64),
    build_firestone(72, 16, 1, 14, 64)
  }
end

function build_screen_desert_fuzzies()
  local path1, path2 = split_path "24,24 88,24 88,56 24,56", split_path "80,72 24,72 24,96 80,96"
  return build_screen {
    build_fuzzy(24, 24, path1, 2),
    build_fuzzy(56, 24, path1, 2),
    build_fuzzy(88, 24, path1, 3),
    build_fuzzy(88, 56, path1, 4),
    build_fuzzy(56, 56, path1, 4),
    build_fuzzy(24, 56, path1, 1),
    build_fuzzy(24, 72, path2, 3),
    build_fuzzy(32, 96, path2, 4),
    build_fuzzy(64, 96, path2, 4),
    build_fuzzy(80, 80, path2, 1),
    build_fuzzy(56, 72, path2, 2)
  }
end

function build_screen_desert_5_idiots()
  return build_screen {
    build_idiot(16, 72, 8, 48),
    build_idiot(40, 88, 8, 48),
    build_idiot(72, 64, 72, 112),
    build_idiot(88, 80, 72, 112),
    build_idiot(104, 96, 72, 112)
  }
end

function build_screen_desert_dead_end()
  local path = split_path "80,40 104,40 104,64 80,64"
  return build_screen {
    build_fuzzy(80, 40, path, 1),
    build_fuzzy(104, 64, path, 3),
    build_firestone(56, 64, 1, 8, 24),
    build_firestone(64, 64, 1, 8, 24)
  }
end

function build_screen_desert_sand_wall()
  return build_screen {
    build_idiot(112, 48, 72, 112),
    build_idiot(72, 80, 72, 112),
    build_fuzzy(24, 32, split_path "24,32, 40,32 40,56 24,56", 1),
    build_fuzzy(40, 104, split_path "24,80, 40,80 40,104 24,104", 3),
    build_sandwall()
  }
end

function build_screen_desert_cactus_and_spade()
  return build_screen {
    build_thrower("cactus", 88, 24, split_path "24,24 88,24 88,96 24,96", 2),
    build_spade(96, 24)
  }
end

function build_screen_desert_fli_boss()
  local fli = build_fli()
  local screen = build_screen { fli }
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

  screen.fire_button_choke = 0
  return screen
end

function build_screen_jungle_2()
  return build_screen {
    build_firestone(56, 40, 2, 14, 40),
    build_firestone(64, 80, 1, 2, 24),
    build_idiot(96, 40, 72, 104),
    build_fuzzy(72, 48, split_path "72,48 96,48 96,72 72,72", 1),
    build_idiot(32, 48, 8, 48),
    build_jazzer(56, 88, 88, 112)
  }
end

function build_screen_jungle_lake_fuzzies()
  local path1, screen = split_path "48,64 72,64 72,80 80,80 80,104 40,104 40,96 32,96 32,80 40,80 40,72 48,72", build_screen {}
  foreach(
    { 3, 5, 7, 9, 11 },
    function(i)
      screen:add_ent(build_fuzzy(path1[i].x, path1[i].y, path1, i))
    end
  )

  return screen
end

function build_screen_jungle_jonathon()
  local jonathon = build_jonathon(84, 72)
  local screen = build_screen {
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
  }
  return screen
end

function build_screen_jungle_monkey()
  return build_screen {
    build_thrower("monkey", 88, 24, split_path "24,32 88,32 88,96 24,96", 2),
    build_bra(96, 24)
  }
end

function build_screen_north_dungeon_fuzzies()
  local path1, path2 = split_path "88,72 32,72 32,104 88,104", split_path "88,24 32,24 32,56 88,56"
  return build_screen {
    build_fuzzy(32, 72, path1, 3, true),
    build_fuzzy(88, 104, path1, 1, true),
    build_fuzzy(32, 24, path2, 3, true),
    build_fuzzy(88, 56, path2, 1, true)
  }
end

function build_screen_north_dungeon_skellington()
  return build_screen {
    build_thrower("skellington", 88, 32, split_path "24,32 88,32 88,100 24,100", 2),
    build_simple_key()
  }
end

function build_screen_final_boss()
  local py = build_py(80, 56)
  local screen = build_screen {
    py,
    build_textbox2(
      {
        "ha ha ha, hee hee hee...",
        "i am the mighty py!\nyou have done well monty.",
        "your chum gerts was kidnapped\nas part of an elaborate\nruse by me to lure you here!",
        "i wanted to test your mettle.\nand you have proven yourself\nworthy.",
        "i will free gerts if you can\ncomplete one more challenge...",
        "to defeat me in a bout of\nfisticuffs!!!"
      }, function()
        py:start_fight()
      end
    )
  }
  screen.boss_py = py
  screen.fire_button_choke = 0
  return screen
end