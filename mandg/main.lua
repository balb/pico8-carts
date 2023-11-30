function _init()
  scenes=build_scenes()
  scene=scenes["title"]
  scene.init()
end

function switch_scene(s)
  scene=scenes[s]
  scene.init()
end

function _update()
  scene:update()
end

function _draw()
  cls()
  scene:draw()
end