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
    map_x=0,
    map_y=0,
    screens=nil,
    screen=nil,
    monty=nil,
    init=function(self)
      self.map_x=start_map_x
      self.map_y=start_map_y
      self.screens=build_screens()
      self.screen=self.screens[self.map_x..self.map_y]
      self.monty=build_monty()
      self.monty:init()
    end,
    update=function(self)
      self.monty.mov=true
      if btn(⬆️) then
        self.monty.dir=0
        --next_y-=1
      elseif btn(⬇️) then
        self.monty.dir=1
        --next_y+=1
      elseif btn(⬅️) then
        self.monty.dir=2
        --next_x-=1
      elseif btn(➡️) then
        self.monty.dir=3
        --next_x+=1
      else
        self.monty.mov=false
      end
      
      
      
      self.screen:update()
      self.monty:update()
      --if btnp(⬆️) then
      --  self.map_y-=1
      --elseif btnp(⬇️) then
      --  self.map_y+=1
      --elseif btnp(⬅️) then
      --  self.map_x-=1
      --elseif btnp(➡️) then
      --  self.map_x+=1
      --end



    end,
    draw=function(self)
      map(self.map_x*16,self.map_y*16,0,0)
      self.screen:draw()
      self.monty:draw()
    end
  }
end
