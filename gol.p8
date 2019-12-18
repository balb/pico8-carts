pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
loop = 0
buf_current = {}
font_color=0

function _init()
	-- draw_glider()
end

function _update()
	if loop == 7 then
		--buf_current = 
			--build_next_buf(buf_current)
		loop = 0
	end
	loop+=1
end

function _draw()
	cls()
	
	draw_title()
	
	for x=0,15 do
		for y=0,15 do
			render_tile(buf_current,x,y)
		end
	end
	
	print(stat(1),10,100,0)
	
	
	
	--print("conway's",0,0)
	--print("glider",10,10,font_color)
 --print("lwss",10,20,font_color)
	font_color+=1
	if font_color == 15 then
		font_color=0
	end
	
end
-->8
max_x = 31
max_y = 31

function set_buf(buf, x, y)
  if buf[x] == nil then buf[x] = {} end
  buf[x][y] = true
end

function get_buf(buf, x, y)
  return buf[x] ~= nil and buf[x][y] == true
end

function get_buf_num(buf, x, y)
  if get_buf(buf, x, y) then return 1 else return 0 end
end

function get_neighbour_count(buf, x, y)
  return get_buf_num(buf, x-1, y-1)
    + get_buf_num(buf, x, y-1)
    + get_buf_num(buf, x+1, y-1)
    + get_buf_num(buf, x-1, y)
    + get_buf_num(buf, x+1, y)
    + get_buf_num(buf, x-1, y+1)
    + get_buf_num(buf, x, y+1)
    + get_buf_num(buf, x+1, y+1)
end

function build_next_buf(buf)
  local new_buf = {}
  for x=0,max_x do
    for y=0,max_y do
      local count = get_neighbour_count(buf, x, y)
      -- alive and 2 or 3. dead and 3
      if count == 3 or (get_buf(buf, x, y) and count == 2) then
        set_buf(new_buf, x, y)        
      end      
    end
  end

  return new_buf
end
-->8
function render_tile(buf,x,y)
	
	-- tile 0,0
	-- needs buf[0][0]
	--       buf[1][0]
	--       ...
	
	local xx = x*2
	local yy = y*2
	local s = 
	   get_buf_num(buf,xx,yy)
		+ get_buf_num(buf,xx+1,yy) * 2
		+ get_buf_num(buf,xx,yy+1) * 4
		+ get_buf_num(buf,xx+1,yy+1) * 8
	
	spr(s, x*8, y*8)
end
-->8
function draw_title()
 --conway's
 local y = 1
 draw_char({3,4,4,4,3},1,y)
 draw_char({3,5,5,5,6},5,y)
 draw_char({6,5,5,5,5},9,y)
 draw_char({5,5,5,7,7},13,y)
	draw_char({7,5,7,5,5},17,y)
 draw_char({5,5,7,1,7},21,y)
 draw_char({2,4,0,0,0},25,y)
 draw_char({3,4,7,1,6},28,y)
end

function draw_char(char,x,y)
	-- 'c' looks like this
 -- 011 -> 3
 -- 100 -> 4
 -- 100 -> 4
 -- 100 -> 4
 -- 011 -> 3
 
 -- {3,4,4,4,3}
	
	local char_exp = {}
	for k,v in pairs(char) do
	  if band(v,4) == 4 then
	    add(char_exp, {0,k-1})
	  end
	  if band(v,2) == 2 then
	    add(char_exp, {1,k-1})
	  end
	  if band(v,1) == 1 then
	    add(char_exp, {2,k-1})
	  end
	end
	
 for k,v in pairs(char_exp) do
		set_buf(buf_current, v[1]+x, v[2]+y)
 end
end

function draw_glider()
	set_buf(buf_current, 4, 2)
	set_buf(buf_current, 5, 3)
	set_buf(buf_current, 3, 4)
	set_buf(buf_current, 4, 4)
	set_buf(buf_current, 5, 4)
end

__gfx__
77767776000677767776000600060006777677760006777677760006000600067776777600067776777600060006000677767776000677767776000600060006
77767776000677767776000600060006777677760006777677760006000600067776777600067776777600060006000677767776000677767776000600060006
77767776000677767776000600060006777677760006777677760006000600067776777600067776777600060006000677767776000677767776000600060006
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
77767776777677767776777677767776000677760006777600067776000677767776000677760006777600067776000600060006000600060006000600060006
77767776777677767776777677767776000677760006777600067776000677767776000677760006777600067776000600060006000600060006000600060006
77767776777677767776777677767776000677760006777600067776000677767776000677760006777600067776000600060006000600060006000600060006
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
