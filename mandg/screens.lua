function build_screens()
  local tab = {}
  tab["00"] = build_screen({})
  tab["10"] = build_screen({})
  tab["20"] = build_screen_desert_fuzzies()
  tab["30"] = build_screen({})
  tab["40"] = build_screen({})
  tab["50"] = build_screen({})
  tab["60"] = build_screen({})
  tab["70"] = build_screen({})
  tab["01"] = build_screen({})
  tab["11"] = build_screen({})
  tab["21"] = build_screen({ build_idiot(88, 88, 80, 112), build_idiot(56, 56, 40, 64) })
  tab["31"] = build_screen({})
  tab["41"] = build_screen({})
  tab["51"] = build_screen({})
  tab["61"] = build_screen({})
  tab["71"] = build_screen({})
  tab["02"] = build_screen({})
  tab["12"] = build_screen({})
  tab["22"] = build_screen({})
  tab["32"] = build_screen({})
  tab["42"] = build_screen({})
  tab["52"] = build_screen({})
  tab["62"] = build_screen({})
  tab["72"] = build_screen({})
  tab["03"] = build_screen({})
  tab["13"] = build_screen({})
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
    update = function(self)
      foreach(
        self.ents, function(ent)
          ent:update()
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

--
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