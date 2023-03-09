pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
offset=0
counter=0

function _update()
 if counter==0 then
  offset+=4
  if offset==12 then
   offset-=12
  end
 end
 counter+=1
 if counter==5 then
  counter-=5
 end
end

function _draw()
 cls()
 spr(17+offset,56,64)
 spr(18+offset,64,64)
 spr(19+offset,72,64)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000b000000000000000000b00000000000000000000000b0000b000000000000000000b000000000000b0000000000000000000000000000000000000
000000000bbb0000000000000000bbb000000000000000000000bbb00bbb0000000000000000bbb0000000000bbb000000000000000000000000000000000000
00000000b33bbbbbbbbbbbbb3bbb33bb00000000bbbbbbbb3bbb33bbb33bbbbb000000003bbb33bbbbbbbbbbb33bbbbb00000000000000000000000000000000
00000000b333b33b333bb33bb33b333300000000333bb33bb33b3333b333b33b00000000b33b3333333bb33bb333b33b00000000000000000000000000000000
00000000333333b33b3b3bb3b3b3333b000000003b3b3bb3b3b3333b333333b300000000b3b3333b3b3b3bb3333333b300000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000004440000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000004440000000000000444000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000004444000000000000444000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000000444000000000000044400000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000cccc000000000000cccc000000000000cccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888880000000088888888000000000888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000088888888000000008888888000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000088888880000000008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000
