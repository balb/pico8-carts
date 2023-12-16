-- todo: fli help - hit ZX
-- todo: fli key and warp
-- todo: get desert done 100%

--btn_up=⬆️
--btn_down=⬇️
--btn_left=⬅️
--btn_right=➡️
--btn_x=❎
--btn_o=🅾️

-- consts
start_map_x = 1
start_map_y = 3
start_monty_x = 8
start_monty_y = 50

-- globals
scenes = nil
scene = nil

-- todo: rename to g_freeze
freeze_enemies = false
g_event = nil

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