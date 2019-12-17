pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
pix_color = 6
bg_color = 0

draw_count = 0

revives = {}
kills = {}

frame = 0

function _init()
 cls()
 -- glider
 pset(0,2,10)
 pset(1,2,10)
 pset(2,2,10)
 pset(2,1,10)
 pset(1,0,10)
end

function _update()
 
 if frame < 5 then
	frame += 1
	return
end

frame = 0

	
 revives = {}
 kills = {}
 for x=0,15 do
 	for y=0,15 do
 	 nbr_cnt = get_nbr_cnt(x,y)
 	 if pget(x,y) == 0 then
 	 	--dead
 	 	if nbr_cnt == 3 then
			add(revives, {x,y})  
 	 	end
 	 else
 	 	--alive
 	 	if nbr_cnt != 2 and nbr_cnt != 3 then
			add(kills, {x,y})
 	 	end
 	 end
 	end
 end

end

function _draw()
	
	-- cls()

	count = 0

	for key,value in pairs(kills) do
		pset(value[1], value[2], bg_color)
		count+=1
	end

	for key,value in pairs(revives) do
		pset(value[1], value[2], pix_color)
		count+=1
	end

	draw_count+=1

	-- rectfill(100,100,127,127,2)
	print(stat(1), 100, 100)
end

function get_nbr_cnt(x,y)
	return is_alive(x-1,y-1)
		+ is_alive(x,y-1)
  + is_alive(x+1,y-1)
  + is_alive(x-1,y)
  + is_alive(x+1,y)
  + is_alive(x-1,y+1)
  + is_alive(x,y+1)
  + is_alive(x+1,y+1)
end

function is_alive(x,y)
	if x < 0 or x > 127 or y < 0 or y > 127 then
		return 0
	end
	if pget(x,y) == 0 then
		return 0
	else
	 return 1
	end
end
-->8
-- hello
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
