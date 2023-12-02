start_map_x=4
start_map_y=2
start_monty_x=4
start_monty_y=2

btn_up=⬆️
btn_down=⬇️
btn_left=⬅️
btn_right=➡️
btn_x=❎
btn_o=🅾️

scenes=nil
scene=nil

function _init()
  scenes=build_scenes()
  switch_scene("title")
end

function switch_scene(s)
  scene=scenes[s]
  scene:init()
end

function _update()
  scene:update()
end

function _draw()
  cls()
  scene:draw()
end