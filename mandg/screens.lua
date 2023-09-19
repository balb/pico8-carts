current_ents={}
init_screens={}
map_x=6
map_y=3

collide_sandwall=false

-- map stuff
function map_collide(next_x, next_y)
 local x=flr((next_x+3)/8)
 local y=flr((next_y)/8)
 local check_6=next_y%8!=0
 collide_sandwall=false
 
 local result=tile_collide(x,y)
  or tile_collide(x+1,y)
  or tile_collide(x,y+1)
  or tile_collide(x+1,y+1)
  or (check_6 and (
   tile_collide(x,y+2)
   or tile_collide(x+1,y+2)
  ))

  if(collide_sandwall)add_ent(build_sandwall())
  return result
end

function tile_collide(x,y)
 if fget(mget((map_x*16)+x,(map_y*16)+y),1) then
   collide_sandwall=true
 end
 return fget(mget((map_x*16)+x,(map_y*16)+y),0)
end

-- build screens
function add_ent(ent)
 add(current_ents,ent)
end

init_screens["00"]=function()
 add_ent(build_old_woman())
end

-- desert top firestones
init_screens["10"]=function()
 add_ent(
  build_firestone(8,40,3,8,32))
 add_ent(
  build_firestone(8,72,3,12,40))
 add_ent(
  build_firestone(8,96,3,16,24))
 add_ent(
  build_firestone(48,16,1,2,64))
 add_ent(
  build_firestone(72,16,1,14,64)) 
end

--desert after open
init_screens["11"]=function()
 add_ent(build_idiot(16,72,8,48))
 add_ent(build_idiot(40,88,8,48))

 add_ent(build_idiot(72,64,72,112))
 add_ent(build_idiot(88,80,72,112))
 add_ent(build_idiot(104,96,72,112))
end

--
init_screens["12"]=function()
  local path={
    {x=80,y=40},
    {x=104,y=40},
    {x=104,y=64},
    {x=80,y=64},
   }

  add_ent(build_fuzzy(80,40,path,1))
  add_ent(build_fuzzy(104,64,path,3))
  
  add_ent(build_firestone(56,64,1,8,24))
  add_ent(build_firestone(64,64,1,8,24))
end

--
init_screens["13"]=function()
  add_ent(build_idiot(112,48,72,112))
  add_ent(build_idiot(72,80,72,112))
  
    local path1={
    {x=24,y=24},
    {x=40,y=24},
    {x=40,y=48},
    {x=24,y=48},
   }

  add_ent(build_fuzzy(24,24,path1,1))
  
  local path2={
    {x=24,y=80},
    {x=40,y=80},
    {x=40,y=104},
    {x=24,y=104},
   }

  add_ent(build_fuzzy(40,104,path2,3))

end

init_screens["03"]=function()
 boss_ent=build_fli()
 add_ent(boss_ent)
end

init_screens["23"]=function()
 local path={
  {x=24,y=24},
  {x=88,y=24},
  {x=88,y=96},
  {x=24,y=96}
 }
 add_ent(
  build_cactus(88,24,path,2))
 add_ent(build_spade(96,24))
end

--desert fuzzies
init_screens["20"]=function()
 local path={
  {x=24,y=24},
  {x=88,y=24},
  {x=88,y=56},
  {x=24,y=56},
 }

 add_ent(
  build_fuzzy(24,24,path,2))
 add_ent(
  build_fuzzy(56,24,path,2))
 add_ent(
  build_fuzzy(88,24,path,3))
 add_ent(
  build_fuzzy(88,56,path,4))
 add_ent(
  build_fuzzy(56,56,path,4))
 add_ent(
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

 add_ent(
  build_fuzzy(24,72,path,3))
 add_ent(
  build_fuzzy(32,96,path,4))
 add_ent(
  build_fuzzy(64,96,path,4))
 add_ent(
  build_fuzzy(80,80,path,1))
 add_ent(
  build_fuzzy(56,72,path,2))
end

--north dungeon enter
init_screens["30"]=function()
 add_ent(
  build_firestone(24,88,3,8,32))
 add_ent(
  build_jazzer(72,64,48,81))  
 add_ent(
  build_jazzer(96,56,48,81))    
end

init_screens["40"]=function()

 local path={
  {x=88,y=72},
  {x=32,y=72},
  {x=32,y=104},
  {x=88,y=104},
 }

 add_ent(
  build_fuzzy(32,72,path,3))
 add_ent(
  build_fuzzy(88,104,path,1))  

  path={
    {x=88,y=24},
    {x=32,y=24},
    {x=32,y=56},
    {x=88,y=56},
   }
  
   add_ent(
    build_fuzzy(32,24,path,3))
   add_ent(
    build_fuzzy(88,56,path,1))  

end

init_screens["50"]=function()
 add_ent(build_door(113,56))
 add_ent(
  build_firestone(72,40,3,8,24))  
 add_ent(
  build_firestone(64,80,3,16,32)) 
 add_ent(
  build_idiot(24,96,8,88))  
end

init_screens["60"]=function()
  local next=1
  local targets={}
  local on_collide=function(ent)
    if ent.ord==next then
      ent.on=true
      next+=1
      sfx(0)
      if next==5 then
        --remove wall
        mset(101,15,97)
        mset(102,15,97)
        mset(103,15,97)
        mset(104,15,97)
        mset(105,15,97)
        mset(106,15,97)
      end
    elseif ent.ord>next then
      next=1
      sfx(1)
      for t in all(targets) do
        t.on=false
      end
    end
  end

  add(targets,build_target(44,36,2,on_collide))
  add(targets,build_target(104,64,4,on_collide))
  add(targets,build_target(24,100,3,on_collide))
  add(targets,build_target(70,104,1,on_collide))
  foreach(targets,add_ent) 

  local path1={
    {x=64,y=24},
    {x=88,y=24},
    {x=88,y=48},
    {x=64,y=48},
  }

  add_ent(build_fuzzy(64,24,path1,2))

  local path2={
    {x=32,y=56},
    {x=56,y=56},
    {x=56,y=80},
    {x=32,y=80},
  }

  add_ent(build_fuzzy(56,80,path2,4))

end

init_screens["51"]=function()
 local path={
  {x=24,y=32},
  {x=88,y=32},
  {x=88,y=100},
  {x=24,y=100}
 }
 add_ent(build_skel(88,32,path,2))
 add_ent(build_key(64,86))
end

init_screens["61"]=function()
  add_ent(build_machete(60,64))
end

init_screens["21"]=function()
 add_ent(
  build_idiot(88,88,80,112))
 add_ent(
  build_idiot(56,56,40,64))
end

---------------
--town square
---------------
init_screens["31"]=function()
  add_ent(build_gerts())
end

----------
--jungle
----------

--enter jungle
init_screens["41"]=function()
 --add_ent(build_bra(32,32))
 --add_ent(build_snake(64,64))
 --add_ent(build_jonathon(80,80))
end

init_screens["42"]=function()
end

init_screens["52"]=function()
end

init_screens["62"]=function()
  add_ent(build_jonathon(80,80))
end

init_screens["72"]=function()
end

init_screens["63"]=function()
end

init_screens["73"]=function()
  local path={
    {x=24,y=32},
    {x=88,y=32},
    {x=88,y=96},
    {x=24,y=96}
   }
   add_ent(
    build_monkey(88,24,path,2))

  if(not state.has_bra) add_ent(build_bra(96,24))
end

init_screens["71"]=function()
  add_ent(build_firestone(16,32,3,0,88))
  add_ent(build_firestone(8 ,48,3,8,96))
  add_ent(build_firestone(16,64,3,0,88))
  add_ent(build_firestone(8 ,80,3,8,96))
  add_ent(build_firestone(16,96,3,0,88))
end

init_screens["70"]=function()
 add_ent(build_web())
end
