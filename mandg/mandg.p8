pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--hello

#include entities.lua
#include screens.lua
#include player.lua
#include main.lua

-->8
--title screen

title_txt=[[
8""8""8
8  8  8 eeeee eeeee eeeee e    e
8e 8  8 8  88 8   8   8   8    8
88 8  8 8   8 8e  8   8e  8eeee8
88 8  8 8   8 88  8   88    88
88 8  8 8eee8 88  8   88    88

       eeeee eeeee eeeee
       8   8 8   8 8   8
       8eee8 8e  8 8e  8
       88  8 88  8 88  8
       88  8 88  8 88ee8       

 8""""8
 8    " eeee eeeee eeeee eeeee
 8e     8    8   8   8   8   "
 88  ee 8eee 8eee8e  8e  8eeee
 88   8 88   88   8  88     88
 88eee8 88ee 88   8  88  8ee88
]]

function draw_title()
 local col=11
 print(title_txt,0,4,col)
 for x=0,127 do
  for y=0,127 do
   p=pget(x,y)
   if p==0 then
    if pget(x-1,y)==col
     and pget(x+1,y)==col then
     pset(x,y,col)
    elseif pget(x,y-1)==col
     and pget(x,y+1)==col then
     pset(x,y,col)
    end
   end
  end 
 end

 spr(2,2,50)
 spr(2,10,50,1,1,true) 
 spr(18,2,58)
 spr(18,10,58,1,1,true)  

end


__gfx__
0000000000000003000000030000000330000000007770aa0077755a00007777a55aa0000000000000000000000cc00000000003000a77000067000000000777
00000000000000330000003b0000003b33000000000777aa0007777a0000077777aaa000000000000000000000caacc0000000bb000a70700066700000007777
007007000000033b000003b3000003b33330000000000003000000030000000330000000000000000ccc000000caaaac0000003b000a70700066700000077cc7
0007700000000333000003330000033333300000000000330000003300000003330000000000000ccaaacc00000ccaaa000300bb000a0000000670000007c8c7
0007700000003bb3000030aa0000333aaa00000000000a3300000a33000000033a000000000000caaaaaaac00ccc0caa00bbb03b00aaa000000670000007cc77
00700700000333bb0003055a000330aaa5500000000550a0000550a0000000003000000000000caaaaaaaaaccaaacccc003b30bb0aa0aa0000aaaa000007777c
000000000000033300005775000000aa57750000000555500005555000000000a055000000000ccaaaaaaaaacaaaaaaa00bbb03b00aaa0000008800000077777
00000000007000aa007057c5000070aa57c50000000000000000000000000005555500000000ccaaaaaaaaaa0cccaaaa003b30bb0000000000088000000077cc
00010100007770aa0077755a00007777a55aa000007770aa0077755a00007777a55aa0000000caaaaaccaaaa0000cccc00bbbbbb000a077000000000000000cc
00111111000777aa0007777a0000077777aaa000000777aa0007777a0000077777aaa0000000caaaccaacaaa00000cca0003bbbb000a700000000000007000cc
1011dd1000000003000000030000000330000000000000030000000300000003300000000000caaaaaaacaaa00cccaaa000003bb000a0070000000000770077c
111d7d100000003300000033000000033300000000000a3300000a33000000033300000000000caaaaccaaaa0caaaaac000000bb000a7700000aa0000077cccc
01dddd1100000a3300000a3300000003a300000000000033000000330000000a33000000000000ccccaaaaac0caaacc0000003bb00aaa00000aaaa000000077c
111dd11100000030000000300000000030000000000000300000003000000000a0550000000000000caaacc000ccc0000000bbb00aa0aa005aa00aa5000000cc
01111110000550a0000550a000000000a0550000000550a0000550a000000005555500000000000000ccc0000000000000003b3000aaa0000000000000770070
01100100000555500005555000000005555500000005555000055550000000000000000000000000000000000000000000000b00000000000000000000777770
0555577008888aa00555577000000000000cc000000cc000000cc000000cc00000000444000ccaaaaaaaaaaa00cc0000008080800000000207707700000aa000
556677768899aaa9556677760000070000cbbc0000cbbc00c0cc1c0c00cc7c00000044770ccaaaaaaacccaaa0caac000084848400000002e7707707000a00a00
5566555588998888556655558000067000b5bb0000b7bb00cc1cc1cc0c1cc1c000044777caaaaaacccaacaaaccaac0008449a448000222e2770770700a000a00
55565577888988aa5556557788aaa667005bb500007bb700ac81c8ca0c81c8c0000477aacaaaccc0caccaaaacccaac00849aaa4800222222077277000a00a000
5556677788899aaa55566777449996650080080000800800aa1881aa0a7887a000047aca0ccc00000caaaaacaacaac00849a7a48000000aa0cc2cc0000aa0a00
555655558889888855565555400006500080080000800800aa8888aa0a8888a000047aaa000000000caaacc0aaaaaac0844aa4480000055a0c222c00000000a0
5556677688899aa955565555000005000880088008800880cac00cac0ac00ca000447aca0000000000ccc000aaaaaaac884444800000577500ccc00000000a0a
05677770089aaaa005677770000000008880088888800888ccc00ccc0cc00cc0004474ac0000000000000000aaaaaaaa0848488000c057c5000c0000000000a0
05555550088888800555555000448800005000000000000000000000555500000444744a00000000aaaaaaaa00cc0cc00000000000000000000c000007000000
5555555588888888555555550004800000a0000000aaa000005500005770000004a4744a00000000aaaaaaaa0caaccac0000666600000066201cc02070600000
6555566598888998655556650009a00000aa00000a4aaa00057500055727000004a4444400000000aaaaaaaaccaacaac006667770000666702cc120070677700
76666665a9999998766666650009a000000aa000aaaaaaaa5772225550d20000040444470000000ccccaaaaccccacaac6667767700066776001cc00077776770
76565575a98988a8755655750009a000000aa000aaaaa4aa5ddddd55000d2000040404470cccccca00caaac0accacacc677667760067766700cc100007776770
77575577aa8a88aa755755770566667000aa00000aaaaa00057500050000d25504404444caaaaaaa0caaac00aaaaaac06767766600676776001cc00007666677
77577577aa8aa8aa755775770056670000a0000000a4a000005500000000055000404444caaaaaaacaaac000aaaaaacc667766000066776602cc120007776770
06577560098aa8900557756000057000005000000000000000000000000055000040aaa40cccccca0ccc0000aaaaaaaa0666600000066660200c002000777700
9999999944554449bbbbbbbb66666666066666666666666011cccc55666666660000000000000000000000000000000000000000000000000000000000000000
f999999955544555bbbbbbbb6666656606665555555566601cc55c55555555550000000000000000000000000000000000000000000000000000000000000000
9999999994455545b5bbbbbb666666660666666886666660c5c55ccc606060600000000000000000000000000000000000000000000000000000000000000000
9999999944459445bbbbb5bb66666666066666888866666055c5cc446060606000000000000000000000000000000000000000000cc000000000000000000000
999999f954554445bbbbbbbb66566666066668899886666055ccc444606060600000000000000000000000000000770000000000c77c00000000000000000000
9999999955544555bbbbbbbb66666666066666aaaa666660ccc4c44460606060000000000000000000000000077777000000000c7cc7c9990000000000000999
99f9999944455595bbb5bbbb666666560666655aa55666605c44c44460606060000777000000000000000007700000000000000c7cc7c9990000000000099999
9999999994454445bbbbbbbb6666666606665775577566605c455555555555550000077700007777770000770000000000000000c77c99990000000009999999
9cccccc9970770797707700944444444066657c55c7566605c45c5c50770077000000007700700000770070000000000000000099cc999990000000999999999
c77777cc7000707007007070400000040666655aa5566660cc45c5c57cc77cc70000000007700000000777000000000000000099999999940000009999999999
9cccccc97070700700707007444444440666666dd66666605c45c5c5077337700000000007000000000770000000000000000999994499440000099999999999
c77777cc70700707007007075044040006666adddda666605c455555033333300000000007000000000070000000000000009999944499440000999999999999
c88888cc707007070070070750440400066666dddd6666605c44c44403c33c300000000007000000000070000000000000044999949999990004499999999999
c77777cc770707070070070750440400066666d66d666660cc44c444833333300007777777000000000007000077777000094449999999990009444999999999
c87778cc700070070700700750440400066656a66a6566605c44c444088833000007000007000000000007077700000000999944444999990099994444499999
c88788cc97077079770770795044040006665556655566605c44c444803333000000000007000000000007770000000000999999994444440099999999444444
c78887cc11111111aaaaaaaa50440400b00bbbbbcccccccc00555500000004440000000007700000000007700000000000099999999999990000000000000000
c87878cc11115111aa9aaaaa504404000330b0bbcc1ccccc05555550000044ff0700007077700000000007000000000000005559999999990000000000000000
c88788cc11111111a99aaa9a50440400b0000b0bc1c1cccc5c5c5c5500004fcf7000000700770000000007000000000000005555555999990000000000000000
c78887cc11111111aaaaaa9a50440400bbb0b0bbcccccccc5c5c5c5500004fff7000000700070000000077777700000000005555555555550000000000000000
c77877cc11111111aaaaaaaa50440400b0b0bbbbcccccccc65555555000044776770077600777000000077000077770000000555555555550000000000000000
c77777cc11511111aaaa9aaa504404000b00b00bcccc1cccb6555555000000447767776707700777777707700000000000000555555555550000000000000000
c87778cc11111151aaaaaaaa50440400b0b00330ccc1c1ccbb65555500f0044f7777777770000000000000700000000000000555555555550000000000000000
c88788cc11111111a9aaaaaa50440400bbb0b00bcccccccc6b6555550ff444ff0770077000000000000000070000000000000005555555550000000000000000
c78887cc011001001dddddd15044040000000000bbbbbbbb6b66555500f004fff400f00000000000000000077000000000000000000555550000000000000000
c87878cc11000111d1dddd105044040000000000bbbbbbbb6bb65505000004fff400000000000000000000007700000000000000000999000000000000000000
c88788cc01100100dd1111005044040000000000bbbbbbbb66b66000000004fff444444000000000000000000770000000000000000999000000000000000000
c78887cc00111110dd1111005044040000000000bbbbbbbbb6b665050000044f4400004000000000000000000007700000000000009999000000000000000000
cc7877cc01100010dd1111005044040000000000bbbbbbbbb6666505000000444000404000000000000000000000000000000000009990000000000000000000
9c7777c901000010dd1111004444444400000000bbbbbbbb6666655500000040400044400000000000000000000000000000ccc00c999c000000000000000000
9c7777c911100111d10000d04000000400000000bbbbbbbb6666655500000040400000000000000000000000000000000000cccccccccc000000000000000000
99cccc99001111001000000d4444444400000000bbbbbbbb6666655500000440440000000000000000000000000000000000cccccccccc000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505050505050505050505050505140404040404041414040404040404140505050505050505050505050505050505050505050505050505050505050505
46464646462424242424242446464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464624242446
05000000000000000000000000000005140404040404041414040404040404140514141414141414141414141414140505141414141414141414141414141405
46464624242424242424242424464646464646464646464646464646464646464624242424242424242424242424244646242424242424242424242424242446
05000000000000000000000000000005140404040404041414040404040404140514141414141414141414141414140505141414141414141414141414141405
46464624245724242457242424464646464646464646464646464646464646464624242424242424242424242424244646242424242424245757572424242446
05000000000000000000000000000005140415252525041414040404040404140514141414141414141414141414140505141414141414141414141414141405
46462424575724242457575757464646464646464646464646464646464646464624575757575757242424575724244646242424575757572457245724242446
05000000000000000000000000000005140404040404041414040404040404140514141414141414141414141414140505141414141414141414141414141405
46242457572424575757575724574646464646464646464646464646464646464624575757245757245757575757244646242457572457242457575757242446
05000000000000000000000000000005141414141414141414040405050404140514141414141414141414141414140505141414141414141414141414141405
46245757242424573557575757575724242456565757242457572456565624242424242457575757242457245757242424245724575724242424242457242446
05000000000000000000000000000005141414141414141414040407070404140514141414141414141414141414140505141414141414141414141414141405
46245757572424353657575757572424242456565724245757245756565624242424242424575757242424245757242424245757245757572457572457572446
05000000000000000000000000000005140404040404040404040404040404140514141414141414141414141414140505141414141414141414141414141405
46242457572424363657575757572457242456575757572457245724565624242457245757575724242424575724242424242457572424242457242457572446
05000000000000000000000000000005140404040404040404040404040404140514141414141414141414141414140505141414141414141414141414141405
46242457572424363757575757575757572457572424245656245757245724575757572457575724242424575724242424242424575724245724242457572446
05000000000000000000000000000005140404040404040404040404040404140514141414141414141414141414140505141414141414141414141414141405
46242457242424375757575757572424242424242424565656245757575724242424245757245724575757575724245656242424245757245757242424572446
05000000000000000000000000000005140404040404040404040404040404140514141414141414141414141414140505141414141414141414141414141405
46242457242424575757575757572424242424242456565624242424572424242424242457575757572457242424245656565656242457572457575757572446
05000000000000000000000000000005140404040404040404040404040404140514141414141414141414141414140505141414141414141414141414141405
46462457575757575757575757572446464646464646464646464646464646464624242424245757242424242456565656565656562424242424572457242446
05000000000000000000000000000005140404040404040505040404040404140514141414141414141414141414140505141414141414141414141414141405
46464646242424242424242424244646464646464646464646464646464646464624245724242457242424245656565656565656565656242424575757242446
05000000000000000000000000000005140404040404040707040404040404140514141414141414141414141414140505141414141414141414141414141405
46464646242424242424242424464646464646464646464646464646464646464624242424242457575757245656565656242424565656245656575724242446
05050505050505050505050505050505140404040404041414040404040404140505050505050505050505050505050505050505050505050505050505050505
46464646464646464646464646464646464646464646464646464646464646464624242424464646464646465656565656244624565656565656565646464646
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
14141414141414141414141414141414140404040404041414040404040404141414141414141414141414141414141405050505050505050505050505050505
05050505050505050505050505050505050505050505050505050505050505054624242424464646464646465656565656565656565656565656565646464646
14000000000000000000000026040404260404040404043535040404040404141404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414054624242424242457575757242456565656565656565624242456562424242446
14000000000000000000000026040404260404040404043636040404040404141404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414054624242424575757575757242424565656565624565624245757572424242446
14000000000000000000000026040404260404040504043636040404040404141404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414054624575757572424575757572424244646242424242424245757575724242446
14000000000000000000000026040404260404040704043636040404040404141404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414054624242424242424242457242424244646242424242424245757572424242446
14000000000000000000000026040404260404040404043737040404040404141404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414054624242424242424242457572424242424242457242424575757575724572446
14000000000000000000000026040404260404040404040404040404040404141404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414054624242457575724575757572424245757245757575724575757572424572446
14000000000000000000000026040404260404040404040404040404040404141404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414054624575757242457575757575757575757575724575724572424242457572446
14000000000000000000000026040404260404040404040404040404040404141404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414054624575757242457245724245757575757242424242424242424242457572446
14000000000000000000000026040404260404040404043535040404040404141404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414054624245724242424575757245757575757575757242424245757575757242446
14000000000000000000000026040404260404040504043636040404040404040404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414054646465757575724245757245724242424242457575724575757575757242446
14000000000000000000000026040404260404040704043636040404040404040404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050000464646245757575757575724242424242424575757575757575724242446
14000000000000000000000026040404260404040404043636040404040404040404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050000000046242424242424242424244646242424242424242424242424242446
14000000000000000000000026040404260404040404043737040404040404141404040404040404040404040404041405141414141414141414141414141405
05141414141414141414141414141405051414141414141414141414141414050000000046462424242424242424244646242424242424242424242424244646
14141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141405050505050505050505050505050505
05050505050505050505050505050505050505050505050505050505050505050000000000464646464646464646464646464646464646464646464646464600
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000010000000000000000010101010000000000000000000000000100030101010000000000000000000001010101000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141410000007171717171717171717171717171710000000000000000000000007171000071717171717171717171710000000000000071717171717171717171000064646464646464646464646464646464
4140404040404040404040404040404141404040404040404040404040404041414040404040404040404040404040410000717161616161616161616161617171710071717171717171717171000071717171616161616161616161717171710000717171716161616161616171710064757500000000000000000000757564
4140504040504040504040404040404141404040404040404040404040404041414040404040404040404040404040410071716161616161616161727272617100000071616161616161616171710000716161616161616161616161616172717171716161616161616161616171710064757500000000000000000000757564
4140704040704040704040404040404141404040404040504040404040404041414040404141414141414140404040417171616161616161617272727272617100007171617272727272726161717100716161616161616161616161616172717161616161616161617272616171717164757500000000000000000000757564
4140404040404040404040404040404141404040404040704040404040404041414040404141404040414140404040417161617272726161617272727261617171717161617272720000726161617171716161616161727272616161616172727161616161616161617272616171717164757500000000000000000000757564
4140404040404040404040404040404040404040404040404040404040404041414040404141414141414140404040417161617200726161616161616161616161616161617272727272726161616161616161616172720000726161616172727261616161616161616161616161617164757500000000000000000000757564
4140404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040417161617272726161616161616161616161616161616161616161616161616161616161616172720072726161616171616161616161616161616161616161617164757500000000000000000000757564
4140404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040417161616161616161616161616161616161616161616161616161616161616161616161616172000072726161616171616161616161727261616161616161617164757500000000000000000000757564
4140404040404040404040404040404141404040404040405040404040404040404040404040404040404040404040417161616161616161616161616161616161616161616161616161616161616161616161616161727272616161616171616161616161727261616161616161617164757500000000000000000000757564
4140404040404040404040404040404141404040404040407040404040404040404040404141414141414040404040417161616161616161616161616161616161616161617272727272726161616161616161616161727261616161617772727261616161616161616161727272727164757500000000000000000000757564
4141414141414141414141414141414141404040404040404040404040404041414040404141414141414040404040417161726161616161617272727261617171616161617200007200726161616171716161616161616161616161616172717161616161616161616161720072717164757500000000000000000000757564
0000000000000000000000000000000041404040404051525252404040404041414040404040404040404040404040417171717261616161617272727272617171717161617272727272726161617171716161616161616161616161717171717161616161616161616161727271000064427575754242757575757575754264
0000000000000000000000000000000041404040404040404040404040404041414051524040404040404040404040410000717261616161616161727272617100007171616161616161616171717100717171616161616161616171710000007161616161616161616161727271000064424275757575754275427575424264
0000000000000000000000000000000041404040404040404040404040404041414040404040404040404040404040410000716161616161616161616161617100007171717171717161717171000000000071716161616161616171000000007171616161616161616161727100000064424242424242427575754242424264
0000000000000000000000000000000041414141414141414141414141414141414141414140404040404041414141410000717171616161616161717171717100717100000000007171710000000000000000717171616161616171000000000071717171727272727272717100000064646464424242427575424242646464
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5050505050505050505050505050505041414141404040404040404041414141414141414140404040404041414141417272727272434343434343727272727264646464646464646464646464646464717171717171616161616171717171717171717171616161616161717171717164646464424242646464646464646464
5000000000000000000000000000005041404040404040404040404040404041414040405340404040404040404040414143434343434343434343434343436464426464646464646464644242426464716161616161616161616161616161710072727271616161616161717272720064424264424242644275754242424264
5000000000000000000000000000005041404040404040404040404040404041414040406340404040404040404040414143434343434343434343434343436464646442426464646464646464424264716161616161616161616161616161710000007271616161616161717200000064427564424242644275754242424264
5000000000000000000000000000005041404040404040404040404040404041414040406340404040404040404040414143434343434343434343434343436464644275756464646475756464424264716161616161616161616161616161710000007271616161616161717200000064424242424242424275424242424264
5000000000000000000000000000005041404040404040404040404040404041414050406340404040534141414141414143434343434343434343434343436464427575424275754242427564646464716161616161616161616161616161710000007271616161616161717200000064424264424242644275756442754264
5000000000000000000000000000005041404040404040404040404040404041414070406340404040634040404040404343434343434343434343434343434242427542424242424242427542646464716161616161616161616161616161710000007271616161616161717200000064424242427575424275754242754264
5000000000000000000000000000005041404040404040515240404040404041414040407340404040634040404040404343434343434347474343434343434242754275754242424242424242426464716161616161616161616161616161710000007271616161616161717200000064424264427542644275426442424264
5000000000000000000000000000005041404040404040414140404040404041414040404040404040634040404040404343434343434344454343434343437542427575656565657575757575754264716161616161616161616161616161710000007271616161616161717200000064424242424242424275754242424264
5000000000000000000000000000005041404040404040414140404040404041414040404040404040634040404040404343434343434354554343434343437575424242756565656575757575754264716161616172727272727261616161710000007271616161616161717200000064424264427575644242756442424264
5000000000000000000000000000005041404040404040414140404040404041414040404040404040634040404040414143434343434347474343434343437575424242757565656575757575754264716161616172726161617261616161710000007271616161616161717200000064424242424242424275754242424264
5000000000000000000000000000005041404040404040414140404040404041414040404040404040734040404040414143434343434343434343434343434242424242757575757575757575754264716161616172726161617261616161710000007271616161616161717200000064424264424242644242426442424264
5000000000000000000000000000005041404040404040414140404040404041414040404040404040404040404040414143434343434343434343434343434242424242757575757575757575756464716161616161616161616161616161710000007271716161616171717200000064424242427575424242424242424264
5000000000000000000000000000005041404040404040414140404040404041414040404040404040404040404040414143434343434343434343434343436464424242424242427575757575646464716161616161616161616161616161710000000072717171717171720000000064424264427575424275756442424264
5000000000000000000000000000005041404040404040414140404040404041414040404040404040404040404040414143434343434343434343434343436464644242424242424242424242646464716161616161616161616161616161710000000000727272727272000000000064424264424242424275756442424264
5050505050505050505050505050505041404040404040414140404040404041414141414141414141414141414141414172727272727272727272727272727264646464644242424242424264646464717171717171717171717171717171710000000000000000000000000000000064646464646464646464646442424264
