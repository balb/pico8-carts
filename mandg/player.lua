--dir: up=0,down=1,left=2,right=3
function build_monty()
  return {
    x=0,
    y=0,
    dir=0,
    mov=false,
    walk_cntr=0,
    walk_step=0,
    init=function(self)
      self.x=start_monty_x
      self.y=start_monty_y
      self.dir=1
    end,
    update=function(self)
      self.walk_cntr+=1
      if(self.walk_cntr==11)self.walk_cntr=0
      self.walk_step=self.walk_cntr<6 and 0 or 1
    end,
    draw=function(self)
      draw_monty(self)
    end,
  }
end

function draw_monty(monty)
  --if monty.dying>0 or monty.warp>0 then
  -- pal(3, flr(rnd(16)))
  -- pal(11, flr(rnd(16)))
  --end
 
  --head
  draw_monty_row(monty,1,0)
  --feet
  if monty.mov then
   if monty.dir<2 then
    local s1=5+monty.dir+(16*monty.walk_step)
    local s2=5+monty.dir+(16*abs(monty.walk_step-1))
    spr(s1,monty.x,monty.y+8)
    spr(s2,monty.x+8,monty.y+8,1,1,true)
   else
    spr(7+(16*monty.walk_step),monty.x,monty.y+8,2,1,monty.dir==2)
   end
  else
   --not moving
   draw_monty_row(monty,17,8)
  end
  --pal()
  
  --if state.dig_sandwall or monty.dig_shoot>0 then
   -- draw spade
   --spr(54+monty.walk_step,monty.x-5,monty.y+6,1,1,false,monty.walk_step)
  --end
 
 end

function draw_monty_row(monty,s,y_offset)
  if monty.dir<2 then
    spr(s+monty.dir,monty.x,monty.y+y_offset)
    spr(s+monty.dir,monty.x+8,monty.y+y_offset,1,1,true)
  else
    spr(s+2,monty.x,monty.y+y_offset,2,1,monty.dir==2)
  end 
end
