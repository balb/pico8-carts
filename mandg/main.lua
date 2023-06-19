--directions up=0,down=1,
--left=2,right=3

--mode 0=title,1=game,
--2=game over
mode=0

_cntr=0
cntr=0
cntr_m2=0
cntr_m4=0
cntr_m18=0
cntr_game_over=0

collision=false

state={}

--debug
state.spade_collected=true

function _update()
 --counters
 _cntr+=1
 if _cntr==4 then
  _cntr=0
  cntr+=1
  if cntr==36 then
   cntr=0
  end
  cntr_m2=cntr%2
  cntr_m4=cntr%4
  cntr_m18=cntr%18
 end

 if mode==0 then
  --title screen
  if (btnp(❎) or btnp(🅾️)) mode=1
  return
 end
 
 if mode==2 then
  cntr_game_over+=1
  if cntr_game_over==40 then
   cntr_game_over=0
   mode=0
   --reset
   monty_x=18
   monty_y=40
   monty_dir=1
   monty_dying=0
   monty_lives=0
   map_x=3
   map_y=1
   current_ents={}  
   state={}
   -- reload map
   reload(0x1000, 0x1000, 0x2000)
  end
  return
 end
 
 --update monty
 if monty_dying>0 then
  monty_dying+=1
  if monty_dying==20 then
    --dead - reset
   monty_dying=0
   monty_lives-=1
   monty_x=init_x
   monty_y=init_y
   if monty_lives==-1 then
     --game over
     mode=2
   end
  end
  return
 end
 
 local next_x=monty_x
 local next_y=monty_y
 monty_mov=true
 
 if map_x==0 and map_y==0 and not state.old_woman_done then
  -- old woman screen
  if next_x > 80 then
   -- Walk Monty towards old woman...
   next_x-=1
   monty_dir=2
  else
   -- ...then stop
   monty_mov=false
  end
 elseif not state.freeze then 
   if btn(⬆️) then
    monty_dir=0
    next_y-=1
   elseif btn(⬇️) then
    monty_dir=1
    next_y+=1
   elseif btn(⬅️) then
    monty_dir=2
    next_x-=1
   elseif btn(➡️) then
    monty_dir=3
    next_x+=1
   else
    monty_mov=false
   end
 end

 collision=false
 foreach(current_ents,check_collision)

 if collision then
  monty_dying=1
 end

 if (not map_collide(next_x, next_y)) then

  --screen wrap
  local init_screen=false
  if next_x==-5 then
   next_x=116
   map_x-=1
   init_screen=true
  elseif next_x==117 then
   next_x=-4
   map_x+=1
   init_screen=true
  end
  
  if next_y==5 then
   next_y=116
   map_y-=1
   init_screen=true
  elseif next_y==117 then
   next_y=6
   map_y+=1
   init_screen=true
  end
  
  monty_x=next_x
  monty_y=next_y
  
  if (init_screen) then
   --clear all ents
   current_ents={}
   init_screens[map_x..map_y]()
   init_x=monty_x
   init_y=monty_y
  end
  
 end
 
 update_monty()

 foreach(current_ents,update_entity)

end

function _draw()
 cls()
 
 if mode==0 then
  draw_title()
  return
 end
 
 if mode==2 then
  rect(0,0,127,127,3)
  print("game over",46,60,11)
  return
 end
 
 map(map_x*16,map_y*16,0,0)

 -- blue to black for the eyes
 pal(12, 0)
 draw_monty()
 -- reset palette
 pal()

 --print(monty_x..","..monty_y.." "..map_x..","..map_y.." "..cntr_m4)
 print(map_x..","..map_y.." "..(collision and "yes" or "no").." lives "..monty_lives)
 foreach(current_ents,draw_entity)
end

function check_collision(ent)
 if(ent.box==nil)return
 
 local ex0=ent.x+ent.box[1]
 local ey0=ent.y+ent.box[2]
 local ew=ent.box[3]
 local eh=ent.box[4]
 
 local mx0=monty_x+monty_box[1]
 local my0=monty_y+monty_box[2]
 local mw=monty_box[3]
 local mh=monty_box[4] 
 
 if ex0<mx0+mw and ex0+ew>mx0
  and ey0<my0+mh and eh+ey0>my0 then
  if ent.on_collide!=nil then
   ent.on_collide(ent)
  else
   --normal enemy
   collision=true
  end
 end
 
end

function update_entity(ent)
 if(ent.update!=nil)ent.update(ent)
end

function draw_entity(ent)
 ent.draw(ent)
 if ent.box!=nil then
  rect(
   ent.x+ent.box[1],
   ent.y+ent.box[2],
   ent.x+ent.box[3],
   ent.y+ent.box[4],14)
 end
 rect(monty_x+monty_box[1],
  monty_y+monty_box[2],
  monty_x+monty_box[3],
  monty_y+monty_box[4],10)
end
