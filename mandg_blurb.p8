pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
cls()
local blurb_1=[[
  monty and gerts were loking 
  for the ledgendary stone of 
  greatness, the only thing 
  sharp enough to cut monty's 
  ever growing mustache. 
 
  they found it in a pyramid
  in the desert.
  
  after dodging and weaving 
  through many booby traps, 
  the pair acquired what they 
  were looking for - 
  
     the ledgendary stone 
        of greatness... 
        
  
]]

local blurb_2=[[
  however, as they were about 
  to leave, the ceiling caved 
  in seperating monty and 
  gerts. 
  
  monty diged as fast as his 
  small victroian excavator 
  trowel could dig but by the 
  time he got to the other 
  side of the rubble, gerts 
  was no where to be found, 
  then came a cry from above -
  
    "i am the evil pi and i 
    have captured your dear 
    friend gerts, you will 
    not stop me before i turn 
    him into an onion to add 
    to my filling!"...
]]

local blurb_3=[[
  with no time to lose, monty 
  fled for the village square 
  in search for his friend. 
  
       this is were our 
        story begins...
]]

print(blurb_3,0,8)
rect(0,0,127,127)
line(2,2,2,127)
line(2,2,127,2)
pset(126,0,0)
pset(127,0,0)
pset(127,1,0)
pset(0,126,0)
pset(0,127,0)
pset(1,127,0)

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
