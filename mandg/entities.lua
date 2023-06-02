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
  end,
  box={1,1,6,6}
 }
end

function build_jazzer(
 start_x,start_y,min_y,max_y)
 return {
  x=start_x, y=start_y,
  min_y=min_y, max_y=max_y,
  speed=0.75,
  update=function(ent)
   ent.y+=ent.speed
   if ent.y<ent.min_y or ent.y>ent.max_y then
    ent.speed*=-1
    ent.y+=ent.speed
   end
  end,
  draw=function(ent)
   local s=36
   if(cntr_m2==0)s=37
   spr(s,ent.x,ent.y)
  end,
  box={1,1,6,6}
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
   if(map_x==4 and map_y==0) pal(1, 5)
   spr(16,ent.x,ent.y,1,1,
    cntr_m4>1,
    cntr_m4==1 or cntr_m4==2)
   pal()
  end,
  box={1,1,6,6}
 }
end

function build_firestone(x,y,dir,t,dist)
 local s=32
 local flip_x=false
 local flip_y=false
 if (dir<2) s=48

 return {
  x=x,y=y,
  update=function(ent)
   if cntr_m18==t+1 and _cntr==0 then
    local x_offset=0
    local y_offset=0
    if (dir==3) x_offset=8
    if (dir==1) y_offset=8
    add_ent(
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
  end,
  box={1,1,6,6}
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
   if (ent.dist<=-2) del(current_ents,ent)
  end,
  draw=function(ent)
   local s=35
   if (dir<2) s=51
   spr(s,ent.x,ent.y)
  end,
  box={1,1,6,6}
 }
end

function build_cactus(
 start_x,start_y)
 local speed=2.5
 return {
  x=start_x, y=start_y,
  update=function(ent)
   --todo: path update
  end,
  draw=function(ent)
   local offset=abs(cntr_m2-1)
   spr(12,ent.x,ent.y+offset)
   spr(12,ent.x+8,ent.y+cntr_m2,1,1,true)   
   spr(28,ent.x,ent.y+8+offset)
   spr(28,ent.x+8,ent.y+8+cntr_m2,1,1,true)   
   
   --temp fileball
   spr(44,96,96,1,1,cntr_m2==0)
  end
 }
end

function build_fli()
 return {
  x=32, y=32,
  update=function(ent)
   --todo: path update
  end,
  draw=function(ent)
   local offset=abs(cntr_m2-1)
   
   --head
   spr(46,ent.x,ent.y)
   --wings
   --spr(30,ent.x+6,ent.y+9)   
   --spr(30,ent.x+6,ent.y+16,1,1,false,true)
   --spr(30,ent.x-6,ent.y+9,1,1,true)   
   --spr(30,ent.x-6,ent.y+16,1,1,true,true)   
   --body
   spr(62,ent.x,ent.y+8)   
   --spr(29,ent.x,ent.y+13)    
   --spr(29,ent.x,ent.y+18)       
   
  end
 }
end

function build_skel(
 start_x,start_y)
 local speed=2.5
 return {
  x=start_x, y=start_y,
  update=function(ent)
   --todo: path update
  end,
  draw=function(ent)
   pal(12, 0)
   local offset=abs(cntr_m2-1)
   spr(15,ent.x,ent.y)
   spr(15,ent.x+7,ent.y,1,1,true)   
   spr(31,ent.x,ent.y+8+offset)
   spr(31,ent.x+7,ent.y+8+cntr_m2,1,1,true)
   -- mouth
   pset(ent.x+5,ent.y+8,7)
   pset(ent.x+9,ent.y+8,7)   
   line(ent.x+6,ent.y+8+offset,
     ent.x+8,ent.y+8+offset,7)
   pal()
  end
 }
end

function build_key(x,y)
 return {
  update=function()
  end,
  draw=function()
   pal(10, flr(rnd(16)))
   spr(47,x,y)
   pal()
  end
 }
end

function build_door(x,y)
 return {
  update=function()
  end,
  draw=function()
   pal(12, 0)
   --top
   spr(70,x,y)
   spr(70,x+7,y,1,1,true)   
   --bottom
   spr(86,x,y+16)
   spr(86,x+7,y+16,1,1,true)      
   --middle
   spr(86,x,y+12)
   spr(86,x+7,y+12,1,1,true)      
   spr(86,x,y+8)
   spr(86,x+7,y+8,1,1,true)         
   pal()
  end
 }
end

function build_target(x,y)
 return {
  update=function()
  end,
  draw=function()
    circfill(x,y,4,10)
    circfill(x,y,2,12)    
    --circfill(x,y,1,8)        
  end
 }
end

function build_crate(x,y)
 return {
  update=function()
  end,
  draw=function()
    spr(116,x,y,1,1,false,true)
    spr(116,x+8,y,1,1,true,true)
    spr(116,x,y+8)
    spr(116,x+8,y+8,1,1,true)            
  end
 }
end

function build_web()
 return {
  update=function()
  end,
  draw=function()


    
    line(24,16,103,95,7)
    line(103,16,24,95,7)    
    line(64,16,64,95,7)
    line(24,56,103,56,7)

    line(64,28,74,32,7)
    line(74,32,86,32,7)    
    
  end
 }
end

function build_bra(x,y)
 return {
  x=x,y=y,
  draw=function()
   spr(63,x,y)
   spr(63,x+8,y,1,1,true)
  end,
  box={0,0,15,7}
 }
end

function build_old_woman()
 local chats = {
  { text= "oooh! hello young man.\nhee hee hee..." },
  { text= "with those spectacles you\nmust have poor eyesight!" },
  { text= "let me test your vision.\nif you pass the test i will\nhelp you on your journey." },
  { text= "ok then, how many fingers am\ni holding up?\n\n     2     3", 
    answers = true,
	draw = function()
	  --3
	  draw_fingers(11,10,27,42)
	end
  },
  { text= "wrong!\ni am holding up 3 fingers",
	draw = function()
	  --3
	  draw_fingers(11,10,27,42)
	end
  },
  { text= "wrong!\ni am holding up 2 fingers",
	draw = function()
	  --2
	  draw_fingers(57,10,41,42)
	end,
	skip=true
  },
  { text= "the end" },
 }
 
 return {
  x=32,y=40,
  chat=1,
  answer=0,
  update=function(ent)
   if (btnp(❎) or btnp(🅾️)) then
     
	 if chats[ent.chat].answers then
	  ent.chat+=1+ent.answer
     else
	  ent.chat+=1
	  if chats[ent.chat].skip then
	   ent.chat+=1
	  end
	 end
    
	ent.answer=0
   end
   
   if chats[ent.chat].answers then
	if btnp(⬅️) and ent.answer > 0 then
      ent.answer-=1
    elseif btnp(➡️) and ent.answer < 1 then
     ent.answer+=1
    end
   end
   
  end,
  draw=function(ent)  
    print(chats[ent.chat].text,4,100,7)
   
   if chats[ent.chat].answers then
    if ent.answer==0 then 
		print(">",20,118,flr(rnd(16)))
	elseif ent.answer==1 then 
		print(">",44,118,flr(rnd(16)))
	end
   end
  
   local offset=0
   if (cntr_m4<2) offset=1
   pal(12, 0)
   
   --draw feet first
   spr(56,32,64)
   spr(56,40,64,1,1,true)
   spr(40,32,56+offset)
   spr(40,40,56+offset,1,1,true)

   --fingers
   if chats[ent.chat].draw then
    chats[ent.chat].draw()
   end
   
   --0
   --draw_fingers(9,10,25,26,48,48)
   --1
   --draw_fingers(9,10,41,42,72,48)
   --2
   --draw_fingers(57,10,41,42,96,48)
   --3
   --draw_fingers(11,10,27,42,48,72)
   --4
   --draw_fingers(11,10,27,58,72,72)
   --5
   --draw_fingers(11,43,27,58,96,72)
   --6
   --draw_fingers(11,59,27,58,96,96)
   pal()
  end
 }
end

-- old woman hands
function draw_fingers(a,b,c,d)
 local x=18
 local y=58
 spr(a,x,y)
 spr(b,x+8,y)
 spr(c,x,y+8)
 spr(d,x+8,y+8)
end
