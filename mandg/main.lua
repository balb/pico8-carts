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
end

function freeze()
  scene:freeze()
end

function unfreeze()
  scene:unfreeze()
end