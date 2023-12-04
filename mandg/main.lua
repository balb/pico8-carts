start_map_x = 3
start_map_y = 1
start_monty_x = 32
start_monty_y = 32

--btn_up=⬆️
--btn_down=⬇️
--btn_left=⬅️
--btn_right=➡️
--btn_x=❎
--btn_o=🅾️

scenes = nil
scene = nil

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
  print(time_toggle(30), 64, 0)
  print(time_toggle(12), 96, 0)
end

function freeze()
  scene:freeze()
end

function unfreeze()
  scene:unfreeze()
end

function time_toggle(t)
  local time = flr(time() * 100)
  return flr(time / t) % 2
end