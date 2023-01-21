pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
--main

_cntr=0
cntr=0
cntr_m2=0
cntr_m4=0
cntr_m18=0

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

 --monty
 local next_x=monty_x
 local next_y=monty_y
 monty_mov=true
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

 if (map_collide(next_x, next_y)) return

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
  current_screen={ ents={} }
  init_screens[map_x..map_y]()
 end

 --todo: probably want to move this
 foreach(current_screen.ents,update_entity)
 
end

function _draw()
 cls()
 map(map_x*16,map_y*16,0,0)

 -- blue to black for the eyes
 pal(12, 0)
 draw_monty()
 -- reset palette
 pal()

 --print(monty_x..","..monty_y.." "..map_x..","..map_y.." "..cntr_m4)
 print(count(current_screen.ents).." "..cntr_m18)
 foreach(current_screen.ents,draw_entity)
end

function update_entity(ent)
 ent.update(ent)
end

function draw_entity(ent)
 ent.draw(ent)
end
-->8
--monty

monty_x=18
monty_y=40
monty_dir=1
monty_mov=false

function draw_monty()
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
end

function draw_monty_row(s, y_offset)
 if monty_dir<2 then
  spr(s+monty_dir,monty_x,monty_y+y_offset)
  spr(s+monty_dir,monty_x+8,monty_y+y_offset,1,1,true)
 else
  spr(s+2,monty_x,monty_y+y_offset,2,1,monty_dir==2)
 end
end

-->8
--map

map_x=2
map_y=0

function map_collide(next_x, next_y)
 local x=flr((next_x+3)/8)
 local y=flr((next_y)/8)
 local check_6=next_y%8!=0

 --debug stuff
 --draw_tile_box(x,y)
 --draw_tile_box(x+1,y)
 --draw_tile_box(x,y+1)
 --draw_tile_box(x+1,y+1)
 --if check_6 then
 -- draw_tile_box(x,y+2)
 -- draw_tile_box(x+1,y+2)
 --end

 return tile_collide(x,y)
  or tile_collide(x+1,y)
  or tile_collide(x,y+1)
  or tile_collide(x+1,y+1)
  or (check_6 and (
   tile_collide(x,y+2)
   or tile_collide(x+1,y+2)
  ))

end

function tile_collide(x,y)
 return fget(mget((map_x*16)+x,(map_y*16)+y)) == 1
end

--debug stuff
--function draw_tile_box(x,y)
-- local start_x=x*8
-- local start_y=y*8
-- rect(start_x,start_y,start_x+7,start_y+7)
--end

-->8
--screens

--todo: just use current_ents
current_screen={ ents={} }

init_screens={}

-- desert top firestones
init_screens["10"]=function()
 add(current_screen.ents,
  build_firestone(8,40,3,8,32))
 add(current_screen.ents,
  build_firestone(8,72,3,12,40))
 add(current_screen.ents,
  build_firestone(8,96,3,16,24))
 add(current_screen.ents,
  build_firestone(48,16,1,2,64))
 add(current_screen.ents,
  build_firestone(72,16,1,14,64))
end

init_screens["20"]=function()
 local path={
  {x=24,y=24},
  {x=88,y=24},
  {x=88,y=56},
  {x=24,y=56},
 }

 add(current_screen.ents,
  build_fuzzy(24,24,path,2))
 add(current_screen.ents,
  build_fuzzy(56,24,path,2))
 add(current_screen.ents,
  build_fuzzy(88,24,path,3))
 add(current_screen.ents,
  build_fuzzy(88,56,path,4))
 add(current_screen.ents,
  build_fuzzy(56,56,path,4))
 add(current_screen.ents,
  build_fuzzy(24,56,path,1))

 -- good alternative with 1 fuzzy
 --path={
 -- {x=24,y=72},
 -- {x=80,y=72},
 -- {x=80,y=96},
 -- {x=24,y=96},
 --}

 path={
  {x=80,y=72},
  {x=24,y=72},
  {x=24,y=96},
  {x=80,y=96},
 }

 add(current_screen.ents,
  build_fuzzy(24,72,path,3))
 add(current_screen.ents,
  build_fuzzy(32,96,path,4))
 add(current_screen.ents,
  build_fuzzy(64,96,path,4))
 add(current_screen.ents,
  build_fuzzy(80,80,path,1))
 add(current_screen.ents,
  build_fuzzy(56,72,path,2))
end

init_screens["21"]=function()
 add(current_screen.ents,
  build_idiot(88,88,80,112))
 add(current_screen.ents,
  build_idiot(56,56,40,64))
end

--town square
init_screens["31"]=function()
end
-->8
--entities

function build_idiot(
 start_x,start_y,min_x,max_x)
 return {
  x=start_x, y=start_y,
  min_x=min_x, max_x=max_x,
  speed=0.75,
  update=function(ent)
   ent.x+=ent.speed
   if ent.x<ent.min_x or ent.x>ent.max_x then
    ent.speed*=-1
    ent.x+=ent.speed
   end
  end,
  draw=function(ent)
   local s=38
   if(cntr_m2==0)s=39
   spr(s,ent.x,ent.y)
  end
 }
end

function build_fuzzy(
 start_x,start_y,path,path_index)

 local speed_x=0.75
 local speed_y=0.75

 return {
  x=start_x, y=start_y,
  path=path,
  path_index=path_index,
  update=function(ent)
   local next_x=ent.path[ent.path_index].x
   local next_y=ent.path[ent.path_index].y
   if ent.x < next_x then
    ent.x+=speed_x
   elseif ent.x > next_x then
    ent.x-=speed_x
   end

   if ent.y < next_y then
    ent.y+=speed_y
   elseif ent.y > next_y then
    ent.y-=speed_y
   end

   if abs(ent.x-next_x)<1
    and abs(ent.y-next_y)<1 then
     --clamp
     ent.x=next_x
     ent.y=next_y
     ent.path_index+=1
     if (ent.path_index>count(ent.path)) ent.path_index=1
   end

  end,
  draw=function(ent)
   spr(16,ent.x,ent.y,1,1,
    cntr_m4>1,
    cntr_m4==1 or cntr_m4==2)
  end
 }
end

function build_firestone(x,y,dir,t,dist)
 local s=32
 local flip_x=false
 local flip_y=false
 if (dir<2) s=48

 return {
  update=function(ent)
   if cntr_m18==t+1 and _cntr==0 then
    local x_offset=0
    local y_offset=0    
    if (dir==3) x_offset=8
    if (dir==1) y_offset=8    
    add(current_screen.ents,
      build_arrow(x+x_offset,y+y_offset,dir,dist))
   end  
  end,
  draw=function(ent)
   local s2=s
   if cntr_m18==t then
    s2+=1
   elseif cntr_m18==t+1 then
    s2+=2
   end
   spr(s2,x,y,1,1,flip_x,flip_y)
  end
 }
end

function build_arrow(
 start_x,start_y,dir,dist)
 local speed=2.5
 return {
  x=start_x, y=start_y,
  dist=dist,
  update=function(ent)
   if dir==0 then
    ent.y-=speed
   elseif dir==1 then
    ent.y+=speed   
   elseif dir==2 then
    ent.x-=speed   
   else
    ent.x+=speed      
   end
   ent.dist-=speed
   if (ent.dist<=-2) del(current_screen.ents,ent)
  end,
  draw=function(ent)
   local s=35
   if (dir<2) s=51
   spr(s,ent.x,ent.y)
  end
 }
end

__gfx__
0000000000000003000000030000000330000000007770aa0077755a00007777a55aa00000000000000000000000333300003333000033330000044444400000
00000000000000330000003b0000003b33000000000777aa0007777a0000077777aaa00000000000000000000000300300003003000030030000447777440000
007007000000033b000003b3000003b3333000000000000300000003000000033000000000000000000000000000300300003003000030030004477777744000
00077000000003330000033300000333333000000000003300000033000000033300000000000000000000000000333300003333000033330004779999774000
0007700000003bb3000030aa0000333aaa00000000000a3300000a33000000033a00000000000000000000007777000077770000777700000004790990974000
00700700000333bb0003055a000330aaa5500000000550a0000550a0000000003000000000000000000000007007000070070000700700000004799999974000
000000000000033300005775000000aa57750000000555500005555000000000a055000000000000000000007007000070070000700700000044790990974400
00000000007000aa007057c5000070aa57c500000000000000000000000000055555000000000000000000007777000077770000777700000044749009474400
00010100007770aa0077755a00007777a55aa000007770aa0077755a00007777a55aa00000000000000000000000999900009999000099990444744994474440
00111111000777aa0007777a0000077777aaa000000777aa0007777a0000077777aaa00000000000000000000000900900009009000090090494744994474940
1011dd10000000030000000300000003300000000000000300000003000000033000000000000000000000000000900900009009000090090494444444444940
111d7d100000003300000033000000033300000000000a3300000a33000000033300000000000000000000000000999900009999000099990404444774444040
01dddd1100000a3300000a3300000003a300000000000033000000330000000a3300000000000000000000008888000088880000888800000404044774404040
111dd11100000030000000300000000030000000000000300000003000000000a055000000000000000000008008000080080000800800000440444444440440
01111110000550a0000550a000000000a0550000000550a0000550a0000000055555000000000000000000008008000080080000800800000040444444440400
01100100000555500005555000000005555500000005555000055550000000000000000000000000000000008888000088880000888800000040999449990400
0555577008888aa00555577000000000000cc000000cc000000cc000000cc0000000000000000000000000000000000000000000000000000000000000000000
556677768899aaa9556677760000070000cbbc0000cbbc00c0cc1c0c00cc7c000000000000000000000000000000000000000000000000000000000000000000
5566555588998888556655558000067000b5bb0000b7bb00cc1cc1cc0c1cc1c00000000000000000000000000000000000000000000000000000000000000000
55565577888988aa5556557788aaa667005bb500007bb700ac81c8ca0c81c8c00000000000000000000000000000000000000000000000000000000000000000
5556677788899aaa55566777449996650080080000800800aa1881aa0a7887a00000000000000000000000000000000000000000000000000000000000000000
555655558889888855565555400006500080080000800800aa8888aa0a8888a00000000000000000000000000000000000000000000000000000000000000000
5556677688899aa955565555000005000880088008800880cac00cac0ac00ca00000000000000000000000000000000000000000000000000000000000000000
05677770089aaaa005677770000000008880088888800888ccc00ccc0cc00cc00000000000000000000000000000000000000000000000000000000000000000
05555550088888800555555000448800005000000000000000000000555500000000000000000000000000000000000000000000000000000000000000000000
5555555588888888555555550004800000a000000099900000550000577000000000000000000000000000000000000000000000000000000000000000000000
6555566598888998655556650009a00000aa00000949990005750005572700000000000000000000000000000000000000000000000000000000000000000000
76666665a9999998766666650009a000000aa000999999995772225550d200000000000000000000000000000000000000000000000000000000000000000000
76565575a98988a8755655750009a000000aa000999994995ddddd55000d20000000000000000000000000000000000000000000000000000000000000000000
77575577aa8a88aa755755770566667000aa000009999900057500050000d2550000000000000000000000000000000000000000000000000000000000000000
77577577aa8aa8aa755775770056670000a000000094900000550000000005500000000000000000000000000000000000000000000000000000000000000000
06577560098aa8900557756000057000005000000000000000000000000055000000000000000000000000000000000000000000000000000000000000000000
9999999944554449bbbbbbbb6666666600000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeee0000000000
f999999955544555bbbbbbbb6666666600000000000000000000000000000000000000000000000000000000000000000000000000000e00000000eeee000000
9999999994455545bbbbbbbb666666660000000000700000077000000000000000000000000000000000000000000000000000000eeee0000000000000ee0000
9999999944459445bbbbbbbb666666660000000000777700700000000000000000000000000000000000000000000000000000eee000000000000000000ee000
999999f954554445bbbbbbbb66666666000000000000777700000000000000000000000000000000000000000000770000000ee00ee00000000000000000e000
9999999955544555bbbbbbbb66666666000000000000700770000000000000000000000000000000000000000777770000000e000eee00000000000000000e00
99f9999944455595bbbbbbbb6666666607777700000070007000000000000000000777000000000000000007700000000000ee000e0e00000000000000000e00
9999999994454445bbbbbbbb6666666607000077000070070000077777770000000007770000777777000077000000000000e000ee0e00e000000000000000e0
9cccccc99707707977077009444444440700000777707770077770000077000000000007700700000770070000000000000ee000e00e00e000eeeee0000000e0
c77777cc7000707007007070400000040700000000077777700000000070000000000000077000000007770000000000000e0000eeee00e00ee00ee0000000e0
9cccccc97070700700707007444444440070000000007700000000000770000000000000070000000007700000000000000e0000e00000e00e00eee0000000e0
c77777cc707007070070070750440400007700000000007000000000700000000000000007000000000070000000000000e00000e00000e00eeee00e000000e0
c88888cc70700707007007075044040000077000000000000000000700000000000000000700000000007000000000000ee00000000000e000ee000e0000000e
c77777cc77070707007007075044040000007770000000000000077000000000000777777700000000000700007777700e000000000000000000000e0000000e
c87778cc70007007070070075044040000000070000007700007700000000000000700000700000000000707770000000e000000000000000000000e0000000e
c88788cc9707707977077079504404000000000777777777777000000000000000000000070000000000077700000000e0000000000000000000000e0000000e
c78887cc0000000000000000504404000000000777777770000000000000000000000000077000000000077000000000e00000000000000000000000e000000e
c87878cc0000000000000000504404000000077000777777777770000000000000000007777000000000070000000000e00000000000000000000000e000000e
c88788cc0000000000000000504404000007700077000700000007770000000000077770007700000000070000000000e00000000000000000000000e000000e
c78887cc0000000000000000504404000070000070000770000000007700000000770000000700000000777777000000e00000000000000000000000e000000e
c77877cc0000000000000000504404000700000070000070000000000077000007700000007770000000770000777700e00000000000000000000000e000000e
c77777cc0000000000000000504404007000007700000007000000000007700007000000077007777777077000000000ee00000000000000000000000e00000e
c87778cc00000000000000005044040070000070000000070000000000007000000000007000000000000070000000000e00000000000000ee0000000e0000ee
c88788cc00000000000000005044040070777770000000007700000000007700000000770000000000000007000000000e000000000000000ee000eee00000e0
c78887cc00000000000000005044040007700000000000000077770000007700000007700000000000000007700000000ee000000000000000eeee00000000e0
c87878cc000000000000000050440400000000000000000000000077777770000000770000000000000000007700000000e000000000000000000000000000e0
c88788cc000000000000000050440400000000000000000000000000000000000007700000000000000000000770000000ee00000000000000000000000000e0
c78887cc0000000000000000504404000000000000000000000000000000000000070000000000000000000000077000000e0000000000000000000000000e00
cc7877cc00000000000000005044040000000000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000e00
9c7777c9000000000000000044444444000000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000eee000
9c7777c90000000000000000400000040000000000000000000000000000000000000000000000000000000000000000000000eeee000000000000000ee00000
99cccc990000000000000000444444440000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeeeeee0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
05050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05000000000000000000000000000005050404040404040404040404040404050514141414141414141414141414140505141414141414141414141414141405
05242424242424242424242424242405052424242424242424242424242424050524242424242424242424242424240505242424242424242424242424242405
05050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
05050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
05050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050524242424242424242424242424240505242424242424242424242424242405
05050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
05050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000000000000000000010101010000000000000000000000000100000100000000000000000000000001000001000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141415050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
4140404040404040404040404040404141404040404040404040404040404041414040404040404040404040404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140504040504040504040404040404141404040404040404040404040404041414040404040404040404040404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140704040704040704040404040404141404040404040504040404040404041414040404141414141414140404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140404040404040404040404040404141404040404040704040404040404041414040404141404040414140404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140404040404040404040404040404040404040404040404040404040404041414040404141414141414140404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140404040404040404040404040404141404040404040405040404040404040404040404040404040404040404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140404040404040404040404040404141404040404040407040404040404040404040404141414141414040404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140504040504040504040404040404141404040404040404040404040404041414040404141414141414040404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140604040604040604040404040404141404040404051525252404040404041414040404040404040404040404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140704040704040704040404040404141404040404040404040404040404041414051524040404040404040404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4140404040404040404040404040404141404040404040404040404040404041414040404040404040404040404040415041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
4141414141414141414141414141414141414141414141414141414141414141414141414140404040404041414141415050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5050505050505050505050505050505050505050505050505050505050505050414141414140404040404041414141415050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
5000000000000000000000000000005050404040404040404040404040404050414040405340404040404040404040415043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414040406340404040404040404040415043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414040406340404040404040404040415043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414050406340404040534141414141415043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414070406340404040634040404040404343434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414040407340404040634040404040404343434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414040404040404040634040404040404343434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414040404040404040634040404040404343434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414040404040404040634040404040415043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414040404040404040734040404040415043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414040404040404040404040404040415043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414040404040404040404040404040415043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050414040404040404040404040404040415043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5050505050505050505050505050505050505050505050505050505050505050414141414141414141414141414141415050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
