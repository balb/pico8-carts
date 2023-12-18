-- todo: town square 100%
-- todo: mention going west to desert
-- todo: brick up the desert on complete
-- todo: warp not triggering on_change_screen
-- todo: replace calls to time_toggle(12, 2) with single call
-- todo: bug! hammer next in old woman room crashes
-- todo: bug! has_north_key_message not working

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
start_monty_y = 60

-- globals
scenes = nil
scene = nil

g_freeze = false
g_event = nil

function _init()
  scenes = build_scenes()
  switch_scene("title")
  --switch_scene("main")
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