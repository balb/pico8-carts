boss_ent=nil

function build_idiot(
 start_x,start_y,min_x,max_x)
 return {
  x=start_x, y=start_y,
  min_x=min_x, max_x=max_x,
  speed=0.75,
  update=function(ent)
   if(state.freeze)return
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
   if(state.freeze)return
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
 start_x,start_y,path,path_index)

 local speed_x=1.2
 local speed_y=1.2

 return {
  x=start_x, y=start_y,
  path=path,
  path_index=path_index,
  cntr=0,
  update=function(ent)
   if(state.freeze)return
   -- same a fuzzy
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

   if ent.cntr==30 then
     local dir=rnd({2,3})
	 local dist=112-ent.x
	 if(dir==2) dist=ent.x-8
     add_ent(build_fireball(ent.x,ent.y+4,dir,dist))
	 ent.cntr=0
   end
   ent.cntr+=1

  end,
  draw=function(ent)
   
   local offset=abs(cntr_m2-1)
   spr(12,ent.x,ent.y+offset)
   spr(12,ent.x+8,ent.y+cntr_m2,1,1,true)   
   spr(28,ent.x,ent.y+8+offset)
   spr(28,ent.x+8,ent.y+8+cntr_m2,1,1,true)   
      
  end,
  box={2,2,13,13}
 }
end

function build_fireball(
 start_x,start_y,dir,dist)
 -- based on arrow
 local speed=2.5
 return {
  x=start_x, y=start_y,
  dist=dist,
  update=function(ent)
   if(state.freeze)return
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
   spr(44,ent.x,ent.y,1,1,cntr_m2==0)
  end,
  box={1,1,6,6},
  del_on_death=true
 }
end

function build_sand_blob(
 start_x,start_y)
 -- based on fireball
 local speed=3
 return {
  x=start_x, y=start_y,
  update=function(ent)
   if(state.freeze)return

   if boss_ent then
     local ex0=ent.x+ent.box[1]
	 local ey0=ent.y+ent.box[2]
	 local ew=ent.box[3]
	 local eh=ent.box[4]
	 
	 local mx0=boss_ent.x+boss_ent.box[1]
	 local my0=boss_ent.y+boss_ent.box[2]
	 local mw=boss_ent.box[3]
	 local mh=boss_ent.box[4] 
	 
	 if ex0<mx0+mw and ex0+ew>mx0
	  -- boss hit
	  and ey0<my0+mh and eh+ey0>my0 then
	  boss_ent.on_hit(boss_ent)
	  del(current_ents,ent)
     else
	  --move
      ent.x-=speed
      if (ent.x<=0) del(current_ents,ent)	  
	 end
   
   end
   
  end,
  draw=function(ent)
   spr(53,ent.x,ent.y,1,1,false,cntr_m2==0)
  end,
  box={1,1,6,6},
  del_on_death=true
 }
end

function build_fli()
 local speed_x=1.2
 local speed_y=1.2
 local path={
  {x=16,y=20},
  {x=80,y=84},
  {x=80,y=100},
  {x=16,y=100},
  {x=80,y=36},
  {x=80,y=20}
 }

 return {
  x=48, y=52,
  path_index=1,
  cntr=0,
  mode=0,
  hit_flash=0,
  update=function(ent)
   if ent.mode==0 then
     add_ent(build_textbox2(
	   {"i am the mighty fli!...", 
	   "how dare you enter my lair!...", 
	   "you will now pay for this\nfoolhardy intrusion."
	   }))
	 ent.mode=1
	 -- move up a bit for textbox
	 if(monty_y > 88)monty_y=88
   elseif ent.mode==1 then
       if(state.freeze)return
	   local next_x=path[ent.path_index].x
	   local next_y=path[ent.path_index].y
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
		 if (ent.path_index>count(path)) ent.path_index=1
	   end

	   if ent.cntr==24 then
		 local dir=3--rnd({2,3})
		 local dist=112-ent.x
		 add_ent(build_fireball(ent.x,ent.y+4,dir,dist))
		 ent.cntr=0
	   end
	   ent.cntr+=1
	   
	   if(ent.hit_flash > 0)ent.hit_flash-=1
	   
	   if ent.health <= 0 then
	     ent.mode=2
		 state.freeze=true
		 add_ent(build_textbox2(
		   -- todo: better dialog
    	   {"arrrrgh! you have defeated me...", 
	       "i beg your mercy. please take this key", 
    	   "blha blhaa as"
	       }))
			foreach(current_ents,function(ent)
				if(ent.del_on_death)del(current_ents,ent)
			  end) 
	   end
	   
       -- end mode 1
    elseif ent.mode==2 then	   
	  -- move fli up so he is not behind textbox
	  if(ent.y>64)ent.y-=1
	  if(monty_y>64)monty_y-=1
	  if not state.freeze then
	    ent.mode=3
		state.spade_collected=false
		state.has_north_key=true
		del(current_ents,ent)

        -- todo: warp back to gerts
	  end
	end
   
  end,
  draw=function(ent)
   if(ent.hit_flash>0)pal(12, flr(rnd(16)))
   --head
   spr(46,ent.x,ent.y)
   -- wings
   spr(60+cntr_m2,ent.x-6,ent.y+9)
   spr(60+cntr_m2,ent.x+5,ent.y+9,1,1,true)
   --body
   spr(62,ent.x+cntr_m2-1,ent.y+8,1,1,cntr_m2==0)
   if(ent.hit_flash)pal()
  end,
  box={0,0,7,15},
  health=10,
  on_hit=function(ent)
    ent.hit_flash=10
    ent.health-=1
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
    answers = {1,2},
  fingers=3
  },
  { text= "wrong! the answer is 3.\nlet's try again...",
  fingers=3,
  jump=2
  },
  { text= "wrong! the answer is 2.\nlet's try again...",
    fingers=2
  },
  { text= "how many fingers am i\nholding up this time?\n\n     1     2", 
    answers = {1,1},
  fingers=1
  },
  { text= "wrong! i am not holding\nup any fingers.\none more try...",
    fingers=0
  },    
  { text= "i'll make it easy this time..." },
  { text= "how many fingers am i\nholding up?\n\n     5     5", 
    answers = {1,1},
  fingers=5
  },
  { text="wrong, 6 fingers!\nyou are as blind as a bat.\nhee hee hee...",
    fingers=6
  },
  { text="not to worry, i'll help you\nanyway. i will open up the way\nsouth using my magical powers.\ncontinue your journay that way."},
  { done = true }
 }

  local function draw_finger_spr(a,b,c,d)
   local x=18
   local y=58
   spr(a,x,y)
   spr(b,x+8,y)
   spr(c,x,y+8)
   spr(d,x+8,y+8)
  end
 
  local function draw_fingers(count)
   if (count==0) draw_finger_spr(9,10,25,26)
   if (count==1) draw_finger_spr(9,10,41,42)
   if (count==2) draw_finger_spr(57,10,41,42)
   if (count==3) draw_finger_spr(11,10,27,42)
   if (count==4) draw_finger_spr(11,10,27,58)
   if (count==5) draw_finger_spr(11,43,27,58)
   if (count==6) draw_finger_spr(11,59,27,58)
  end
 
 return {
  x=32,y=40,
  chat=1,
  answer=1,
  update=function(ent)
   if(state.old_woman_done) return
   if chats[ent.chat].done then
    state.old_woman_done = true
	-- clear the wall
	mset(20,15,64)
	mset(21,15,64)
	mset(22,15,64)
	mset(23,15,64)
	mset(24,15,64)
	mset(25,15,64)
	mset(26,15,64)
	mset(27,15,64)
    return
   end
  
   if (btnp(❎) or btnp(🅾️)) then
     
   if chats[ent.chat].answers then
    ent.chat+=chats[ent.chat].answers[ent.answer]
     elseif chats[ent.chat].jump then
    ent.chat+=chats[ent.chat].jump
   else 
    ent.chat+=1
   end
    
  ent.answer=1
   end
   
   if chats[ent.chat].answers then
    if btnp(⬅️) then
      ent.answer=1
    elseif btnp(➡️) then
     ent.answer=2
    end
   end
   
  end,
  draw=function(ent)
    if(state.old_woman_done or chats[ent.chat].done) return
  
    print(chats[ent.chat].text,4,100,7)
   
   if chats[ent.chat].answers then
    if ent.answer==1 then 
      print(">",20,118,flr(rnd(16)))
    elseif ent.answer==2 then 
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

   if chats[ent.chat].fingers then
    draw_fingers(chats[ent.chat].fingers)
   end
   
   pal()
  end
 }
end

function build_spade(x,y)
 return {
  x=x,y=y,
  update=function()
  end,
  draw=function(ent)
   if not state.spade_collected then
     pal(7, flr(rnd(16)))
     spr(54,x,y)
     pal()
   end
  end,
  box={0,1,7,6},
  on_collide=function(ent)
    if not state.spade_collected then
     state.spade_collected=true
     del(current_ents,ent)
	 add_ent(build_textbox("this spiffing spade\nwill come in handy..."))
    end
  end
 }
end

-- don't really need this func
function build_textbox(text)
  return build_textbox2({text})
end

function build_textbox2(texts)
  return {
    cntr=1,
	idx=1,
    update=function(ent)
	  state.freeze=true
	  local text=texts[ent.idx]
	  if ent.cntr<#text then
	    -- wait for full string to be printed
	    ent.cntr+=1--cntr_m2
	  elseif (btnp(❎) or btnp(🅾️)) then
	    ent.cntr=1
		ent.idx+=1
		if ent.idx > count(texts) then
	      del(current_ents,ent)
		  state.freeze=false
		end
	  end
	end,
	draw=function(ent)
	  rectfill(0,104,127,127,0)
	  local text=texts[ent.idx]
	  print(sub(text,1,ent.cntr),4,112,7)
	end,
  }
end

function build_sandwall(text)
  -- sandwall event handler
  return {
    text="",
	cntr=0,
    update=function(ent)
	  if state.spade_collected then
	    ent.text="now to dig my way through!"
	  else
	    ent.text="if only i had a spade\nto dig my way through..."
	  end
	  -- copy from build_textbox
	  state.freeze=true
	  if ent.cntr<40 then
	    -- wait for a bit
	    ent.cntr+=1
	  elseif (btnp(❎) or btnp(🅾️)) then
	    del(current_ents,ent)
		state.freeze=false
		state.dig_sandwall=state.spade_collected
	  end
	end,
	draw=function(ent)
	  rectfill(0,104,127,127,0)
	  print(ent.text,4,112,7)
	end,
  }
end