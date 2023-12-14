-- todo: think about death and textbox freeze
-- todo: scene_update_handler???

--btn_up=⬆️
--btn_down=⬇️
--btn_left=⬅️
--btn_right=➡️
--btn_x=❎
--btn_o=🅾️

-- consts
start_map_x = 3
start_map_y = 1
start_monty_x = 8
start_monty_y = 50

-- globals
scenes = nil
scene = nil

freeze_enemies = false

-- todo: this should be a screen prop
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