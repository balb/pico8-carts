-- todo: town square 100%
-- todo: mention going west to desert
-- todo: replace calls to time_toggle(12, 2) with single call
-- todo: bug! hammer next in old woman room crashes
-- todo: 9 legged spida

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
g_scenes = nil
g_scene = nil

g_freeze = false
g_event = nil

function _init()
  g_scenes = build_scenes()
  switch_scene("title")
  --switch_scene("main")
end

function switch_scene(s)
  g_scene = g_scenes[s]
  g_scene:init()
end

function _update()
  g_scene:update()
end

function _draw()
  cls()
  g_scene:draw()
end

function time_toggle(t, mod)
  local time = flr(time() * 100)
  return flr(time / t) % mod
end