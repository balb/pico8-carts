function build_screens()
  local tab = {}
  tab["00"] = build_screen({})
  tab["10"] = build_screen({})
  tab["20"] = build_screen({})
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