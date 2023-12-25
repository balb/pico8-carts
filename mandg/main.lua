-- todo: improve boss music
-- todo: sfx
-- todo: boxing py
-- todo: make monty and gerts jump at the end
-- todo: gerts final text
-- todo: credits text

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

g_toggle2 = 0
g_toggle4 = 0

g_the_end = false

function _init()
  g_scenes = build_scenes()
  switch_scene "title"
  --switch_scene "main"
  --main theme drum and bass
  music(4)
end

function switch_scene(s)
  g_scene = g_scenes[s]
  g_scene:init()
end

function _update()
  g_toggle2 = time_toggle(12, 2)
  g_toggle4 = time_toggle(12, 4)
  g_scene:update()
end

function _draw()
  cls()
  g_scene:draw()

  -- Debug FPS
  print(stat(7), 24, 1)
end

function time_toggle(t, mod)
  local time = flr(time() * 100)
  return flr(time / t) % mod
end

function iif(condition, value_if_true, value_if_false)
  if (condition) return value_if_true
  return value_if_false
end

function split_path(path)
  local tbl = {}
  foreach(
    split(path, " ", false), function(point)
      local chunks = split(point)
      add(tbl, { x = chunks[1], y = chunks[2] })
    end
  )
  return tbl
end

--function outline_ent(ent)
--  rect(ent.x + ent.box[1], ent.y + ent.box[2], ent.x + ent.box[3], ent.y + ent.box[4])
--end

function empty_func()
end