-- todo: scene_update_handler???

start_map_x = 1
start_map_y = 3
start_monty_x = 8
start_monty_y = 50

--btn_up=⬆️
--btn_down=⬇️
--btn_left=⬅️
--btn_right=➡️
--btn_x=❎
--btn_o=🅾️

scenes = nil
scene = nil

freeze_enemies = false
freeze_monty = false

boss_fli = nil

function _init()
  scenes = build_scenes()
  switch_scene("title")
end

function switch_scene(s)
  scene = scenes[s]
  scene:init()
end

function _update()
  scene:update()
end

function _draw()
  cls()
  scene:draw()
end

function time_toggle(t, mod)
  local time = flr(time() * 100)
  return flr(time / t) % mod
end