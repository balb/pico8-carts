function build_screens()
  local tab = {}
  tab["00"] = build_screen()
  tab["10"] = build_screen()
  tab["20"] = build_screen()
  tab["30"] = build_screen()
  tab["40"] = build_screen()
  tab["50"] = build_screen()
  tab["60"] = build_screen()
  tab["70"] = build_screen()
  tab["01"] = build_screen()
  tab["11"] = build_screen()
  tab["21"] = build_screen()
  tab["31"] = build_screen()
  tab["41"] = build_screen()
  tab["51"] = build_screen()
  tab["61"] = build_screen()
  tab["71"] = build_screen()
  tab["02"] = build_screen()
  tab["12"] = build_screen()
  tab["22"] = build_screen()
  tab["32"] = build_screen()
  tab["42"] = build_screen()
  tab["52"] = build_screen()
  tab["62"] = build_screen()
  tab["72"] = build_screen()
  tab["03"] = build_screen()
  tab["13"] = build_screen()
  tab["23"] = build_screen()
  tab["33"] = build_screen()
  tab["43"] = build_screen()
  tab["53"] = build_screen()
  tab["63"] = build_screen()
  tab["73"] = build_screen()
  return tab
end

function build_screen()
  return {
    ents={

    },
    update=function(self)
      
    end,
    draw=function(self)
      print("i am the screen", 10, 10)
    end
  }
end