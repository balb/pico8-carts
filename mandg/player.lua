init_x=0
init_y=0

monty_x=70
monty_y=40
monty_dir=1
monty_mov=false
monty_box={4,0,11,15}
monty_dying=0
monty_lives=10

function draw_monty()
 if monty_dying>0 then
  pal(3, flr(rnd(16)))
  pal(11, flr(rnd(16)))
 end
 --head
 draw_monty_row(1, 0)
 --feet
 if monty_mov then
  if monty_dir<2 then
   local s1=5+monty_dir+(16*cntr_m2)
   local s2=5+monty_dir+(16*abs(cntr_m2-1))
   spr(s1,monty_x,monty_y+8)
   spr(s2,monty_x+8,monty_y+8,1,1,true)
  else
   spr(7+(16*cntr_m2),monty_x,monty_y+8,2,1,monty_dir==2)
  end
 else
  --not moving
  draw_monty_row(17, 8)
 end
 pal()
end

function draw_monty_row(s, y_offset)
 if monty_dir<2 then
  spr(s+monty_dir,monty_x,monty_y+y_offset)
  spr(s+monty_dir,monty_x+8,monty_y+y_offset,1,1,true)
 else
  spr(s+2,monty_x,monty_y+y_offset,2,1,monty_dir==2)
 end
 
 if state.dig_sandwall then
  spr(54+cntr_m2,monty_x-6,monty_y+6,1,1,false,cntr_m2)
 end
end
