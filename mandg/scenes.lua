function build_scenes()
  local tab = {}
  tab["title"] = build_scene_title()
  tab["main"] = build_scene_main()
  return tab
end

function build_scene_title()
  return {
    init=function()
    end,
    update=function()
      if btnp(❎) or btnp(🅾️) then
        switch_scene("main")
      end
    end,
    draw=function()
      print("I am the title", 10, 10)
    end
  }
end

function build_scene_main()
  return {
    map_x=4,
    map_y=2,
    init=function()
    end,
    update=function(self)
      if btnp(⬆️) then
        self.map_y-=1
      elseif btnp(⬇️) then
        self.map_y+=1
      elseif btnp(⬅️) then
        self.map_x-=1
      elseif btnp(➡️) then
        self.map_x+=1
      end
    end,
    draw=function(self)
      map(self.map_x*16,self.map_y*16,0,0)
    end
  }
end