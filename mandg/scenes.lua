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
      local next_x=self.monty.x
      local next_y=self.monty.y
 
      self.monty.mov=true
      if btn(⬆️) then
        self.monty.dir=0
        next_y-=1
      elseif btn(⬇️) then
        self.monty.dir=1
        next_y+=1
      elseif btn(⬅️) then
        self.monty.dir=2
        next_x-=1
      elseif btn(➡️) then
        self.monty.dir=3
        next_x+=1
      else
        self.monty.mov=false
      end
      
      if (not map_collide(scene,next_x,next_y)) then

  --screen wrap
  --local init_screen=false
  if next_x==-5 then
   next_x=116
   self.map_x-=1
   --init_screen=true
  elseif next_x==117 then
   next_x=-4
   self.map_x+=1
   --init_screen=true
  end
  
  if next_y==5 then
   next_y=116
   self.map_y-=1
   --init_screen=true
  elseif next_y==117 then
   next_y=6
   self.map_y+=1
   --init_screen=true
  end


        self.monty.x=next_x
        self.monty.y=next_y

        self.screen=self.screens[self.map_x..self.map_y]
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

function map_collide(scene,next_x,next_y)
  local x=flr((next_x+3)/8)
  local y=flr((next_y)/8)
  local check_6=next_y%8!=0
  --collide_sandwall=false

  local result=tile_collide(scene,x,y)
    or tile_collide(scene,x+1,y)
    or tile_collide(scene,x,y+1)
    or tile_collide(scene,x+1,y+1)
    or (check_6 and (
      tile_collide(scene,x,y+2)
      or tile_collide(scene,x+1,y+2)
    ))

  --if(collide_sandwall)add_ent(build_sandwall())
  return result
end

function tile_collide(scene,x,y)
  --if fget(mget((scene.map_x*16)+x,(scene.map_y*16)+y),1) then
  --  collide_sandwall=true
  --end
  return fget(mget((scene.map_x*16)+x,(scene.map_y*16)+y),0)
end