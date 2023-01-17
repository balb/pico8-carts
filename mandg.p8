pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
--main

_cntr=0
cntr=0
cntr_m2=0
cntr_m3=0

function _update()
 --counters
 _cntr+=1
 if _cntr==4 then
  _cntr=0
  cntr+=1
  if cntr==12 then 
   cntr=0
  end  
  cntr_m2=cntr%2  
  cntr_m3=cntr%3
 end
 
 --monty
 monty_mov=true
 if btn(⬆️) then
  monty_dir=0
  monty_y-=1
 elseif btn(⬇️) then
  monty_dir=1
  monty_y+=1
 elseif btn(⬅️) then 
  monty_dir=2
  monty_x-=1
 elseif btn(➡️) then
  monty_dir=3
  monty_x+=1  
 else 
  monty_mov=false
 end  
end

function _draw()
 cls()
 print(cntr,10,20)
 draw_monty()
end

-->8
--monty

monty_x=40
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

__gfx__
0000000000000003000000030000000330000000007770aa0077755a00007777a55aa00000000000000000000000333300003333000033330000044444400000
00000000000000330000003b0000003b33000000000777aa0007777a0000077777aaa00000000000000000000000300300003003000030030000447777440000
007007000000033b000003b3000003b3333000000000000300000003000000033000000000000000000000000000300300003003000030030004477777744000
00077000000003330000033300000333333000000000003300000033000000033300000000000000000000000000333300003333000033330004779999774000
0007700000003bb3000030aa0000333aaa00000000000a3300000a33000000033a00000000000000000000007777000077770000777700000004790990974000
00700700000333bb0003055a000330aaa5500000000550a0000550a0000000003000000000000000000000007007000070070000700700000004799999974000
000000000000033300005775000000aa57750000000555500005555000000000a055000000000000000000007007000070070000700700000044790990974400
00000000007000aa00705705000070aa570500000000000000000000000000055555000000000000000000007777000077770000777700000044749009474400
ffff0000007770aa0077755a00007777a55aa000007770aa0077755a00007777a55aa00000000000000000000000999900009999000099990444744994474440
f00f0000000777aa0007777a0000077777aaa000000777aa0007777a0000077777aaa00000000000000000000000900900009009000090090494744994474940
f00f0000000000030000000300000003300000000000000300000003000000033000000000000000000000000000900900009009000090090494444444444940
ffff00000000003300000033000000033300000000000a3300000a33000000033300000000000000000000000000999900009999000099990404444774444040
0000888800000a3300000a3300000003a300000000000033000000330000000a3300000000000000000000008888000088880000888800000404044774404040
0000800800000030000000300000000030000000000000300000003000000000a055000000000000000000008008000080080000800800000440444444440440
00008008000550a0000550a000000000a0550000000550a0000550a0000000055555000000000000000000008008000080080000800800000040444444440400
00008888000555500005555000000005555500000005555000055550000000000000000000000000000000008888000088880000888800000040999449990400
0555577008888aa00555577000000000000cc000000cc000000cc000000cc0000001010000500000000000000000000055550000000000000000000000000000
556677768899aaa9556677760000000000cbbc0000cbbc00c0cc1c0cc0cc7c0c0011111100a00000009990000055000057700000000000000000000000000000
5566555588998888556655550000070000b5bb0000b7bb00cc1cc1cccc1cc1cc1011dd1000aa0000094999000575000557270000000000000000000000000000
55565577888988aa5556557780000670005bb500007bb700ac81c8caac81c8ca111d7d10000aa000999999995772225550d20000000000000000000000000000
5556677788899aaa5556677788aaa6670080080000800800aa1881aaaa7887aa01dddd11000aa000999994995ddddd55000d2000000000000000000000000000
555655558889888855565555449996650080080000800800aa8888aaaa8888aa111dd11100aa000009999900057500050000d255000000000000000000000000
5556677688899aa955565555400006500880088008800880cac00caccac00cac0111111000a00000009490000055000000000550000000000000000000000000
05677770089aaaa005677770000005008880088888800888ccc00cccccc00ccc0110010000500000000000000000000000005500000000000000000000000000
000000000000000000007777a55aa00000007777a55aa000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeee
00000000000000000000077777aaa0000000077777aaa000000000000000000000000000000000000000000000000000000000000000000000000000e0000000
000000000000000000000003300000000000000330000000000000000000000000000000000000000000000000000000000000000000000000000000e0eeeeee
000000000000000000000003a30000000000000333000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0000e
0000000000000000000000033300000000000003a3000000000000000000000000000000000000000000000000000000000000000000000000000000e0e00e0e
0000000000000000000000003000000000000000a0550000000000000000000000000000000000000000000000000000000000000000000000000000e0eeee0e
000000000000000000000000a05500000000000555550000000000000000000000000000000000000000000000000000000000000000000000000000e000000e
000000000000000000000005555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeee
ffffffff11111111bbbbbbbb66666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff11111111bbbbbbbb66666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff11111111bbbbbbbb66666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff11111111bbbbbbbb66666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff11111111bbbbbbbb66666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff11111111bbbbbbbb66666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff11111111bbbbbbbb66666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff11111111bbbbbbbb66666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5040404040404040404040404040405050404040404040404040404040404050504040404040404040404040404040505041414141414141414141414141415050414141414141414141414141414150504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5000000000000000000000000000005050404040404040404040404040404050504040404040404040404040404040505043434343434343434343434343435050424242424242424242424242424250504141414141414141414141414141505041414141414141414141414141415050000000000000000000000000000050
5050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
