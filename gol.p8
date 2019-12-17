pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
loop = 0
buf_current = {}

function _init()
	set_buf(buf_current, 4, 2)
	set_buf(buf_current, 5, 3)
	set_buf(buf_current, 3, 4)
	set_buf(buf_current, 4, 4)
	set_buf(buf_current, 5, 4)
end

function _update()
	if loop == 7 then
		buf_current = 
			build_next_buf(buf_current)
		loop = 0
	end
	loop+=1
end

function _draw()
	cls()
	-- print("hello, world!")
	
	for x=0,15 do
		for y=0,15 do
			-- spr(0,x*8,y*8)
			render_tile(buf_current,x,y)
		end
	end
	
	print(stat(1),10,100,0)
	
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
__gfx__
77767776000677767776000600060006777677760006777677760006000600067776777600067776777600060006000677767776000677767776000600060006
77767776000677767776000600060006777677760006777677760006000600067776777600067776777600060006000677767776000677767776000600060006
77767776000677767776000600060006777677760006777677760006000600067776777600067776777600060006000677767776000677767776000600060006
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
77767776777677767776777677767776000677760006777600067776000677767776000677760006777600067776000600060006000600060006000600060006
77767776777677767776777677767776000677760006777600067776000677767776000677760006777600067776000600060006000600060006000600060006
77767776777677767776777677767776000677760006777600067776000677767776000677760006777600067776000600060006000600060006000600060006
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
