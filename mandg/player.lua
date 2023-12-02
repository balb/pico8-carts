--dir: up=0,down=1,left=2,right=3
function build_monty()
  return {
    x=0,
    y=0,
    dir=0,
    init=function(self)
      self.x=start_monty_x
      self.y=start_monty_y
      self.dir=1
    end,
    update=function(self)
      if btnp(⬆️) then
        scene.map_y-=1
      elseif btnp(⬇️) then
        scene.map_y+=1
      elseif btnp(⬅️) then
        scene.map_x-=1
      elseif btnp(➡️) then
        scene.map_x+=1
      end
    end,
    draw=function(self)
      print("I am monty",32,32)
    end
  }
end