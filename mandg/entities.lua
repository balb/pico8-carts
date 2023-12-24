function build_idiot(start_x, start_y, min_x, max_x)
  local speed = .75
  return {
    x = start_x, y = start_y,
    min_x = min_x, max_x = max_x,

    update = function(self, screen)
      if (g_freeze) return
      self.x += speed
      if self.x < self.min_x or self.x > self.max_x then
        speed *= -1
        self.x += speed
      end
    end,
    draw = function(self)
      local s = 38 + time_toggle(10, 2)
      spr(s, self.x, self.y)
    end,
    box = split("1,1,6,6")
  }
end

function build_fuzzy(start_x, start_y, path, path_index, mask)
  local speed_x, speed_y = .75, .75
  return {
    x = start_x, y = start_y,
    path = path,
    path_index = path_index,
    update = function(ent, screen)
      if (g_freeze) return
      update_position(ent, speed_x, speed_y)
    end,
    draw = function(self)
      --if ((map_x == 4 or map_x == 6) and map_y == 0) pal(1, 5)
      if (mask) pal(1, 5)
      local tog_4 = time_toggle(12, 4)
      spr(
        16, self.x, self.y, 1, 1,
        tog_4 > 1,
        tog_4 == 1 or tog_4 == 2
      )
      if (mask) pal()
    end,
    box = split("1,1,6,6")
  }
end

function update_position(ent, speed_x, speed_y)
  local next_x, next_y = ent.path[ent.path_index].x, ent.path[ent.path_index].y

  if ent.x < next_x then
    ent.x += speed_x
  elseif ent.x > next_x then
    ent.x -= speed_x
  end

  if ent.y < next_y then
    ent.y += speed_y
  elseif ent.y > next_y then
    ent.y -= speed_y
  end

  if abs(ent.x - next_x) < 1
      and abs(ent.y - next_y) < 1 then
    --clamp
    ent.x = next_x
    ent.y = next_y
    ent.path_index += 1
    if (ent.path_index > count(ent.path)) ent.path_index = 1
  end
end

function build_firestone(x, y, dir, t, dist)
  local s, flip_x, flip_y = 32, dir == 2, false
  if (dir < 2) s = 48
  return {
    x = x, y = y,
    timer = 0,
    arrow_added = false,
    update = function(self, screen)
      self.timer = time_toggle(18, 18)
      if self.timer == t then
        if not self.arrow_added then
          local x_offset, y_offset = 0, 0
          if dir == 1 then
            y_offset = 8
          elseif dir == 2 then
            x_offset = -8
          elseif dir == 3 then
            x_offset = 8
          end
          screen:add_ent(build_projectile("arrow", x + x_offset, y + y_offset, dir, dist))
          self.arrow_added = true
        end
      else
        self.arrow_added = false
      end
    end,
    draw = function(self)
      local s2 = s
      if self.timer == t then
        s2 += 1
      elseif self.timer == t + 1 then
        s2 += 2
      end
      spr(s2, x, y, 1, 1, flip_x, flip_y)
      -- print(self.timer, 96, 0)
    end,
    box = split("1,1,6,6")
  }
end

function build_old_woman()
  local chats = {
    { text = "oooh! hello young man.\nhee hee hee..." },
    { text = "with those spectacles you\nmust have poor eyesight!" },
    { text = "let me test your vision.\nif you pass the test i will\nhelp you on your journey." },
    {
      text = "ok then, how many fingers am\ni holding up?",
      answers = { "two", "three" },
      get_next = function(ans)
        if (ans == "two") return 5
        if (ans == "three") return 6
        return -1
      end,
      fingers = 3
    },
    --[[ 5 ]] {
      text = "wrong! the answer is 3.\nlet's try again...",
      get_next = function()
        return 7
      end,
      fingers = 3
    },
    --[[ 6 ]] {
      text = "wrong! the answer is 2.\nlet's try again...",
      fingers = 2
    },
    --[[ 7 ]] {
      text = "how many fingers am i\nholding up this time?",
      answers = { "one", "two" },
      fingers = 1
    },
    {
      text = "wrong! i am not holding\nup any fingers.\none more try...",
      fingers = 0
    },
    { text = "i'll make it easy this time..." },
    {
      text = "how many fingers am i\nholding up?",
      answers = { "five", "five " },
      fingers = 5
    },
    {
      text = "wrong, 6 fingers!\nyou are as blind as a bat.\nhee hee hee...",
      fingers = 6
    },
    { text = "you have failed the test\nbut i will help you anyway..." },
    { text = "head south from here.\nand try not to die." },
    { text = "be seeing you!" },
    { text = "", done = true }
  }

  local function draw_finger_spr(a, b, c, d)
    local x, y = 18, 58
    spr(a, x, y)
    spr(b, x + 8, y)
    spr(c, x, y + 8)
    spr(d, x + 8, y + 8)
  end

  local function draw_fingers(count)
    if (count == 0) draw_finger_spr(9, 10, 25, 26)
    if (count == 1) draw_finger_spr(9, 10, 41, 42)
    if (count == 2) draw_finger_spr(57, 10, 41, 42)
    if (count == 3) draw_finger_spr(11, 10, 27, 42)
    if (count == 4) draw_finger_spr(11, 10, 27, 58)
    if (count == 5) draw_finger_spr(11, 43, 27, 58)
    if (count == 6) draw_finger_spr(11, 59, 27, 58)
  end

  return {
    x = 32, y = 40,
    chat = 1,
    text_ticker = build_text_ticker(chats[1].text),
    q_and_a = nil,
    add_q_and_a = false,
    update = function(self, screen)
      self.text_ticker:update()
      if (self.q_and_a) self.q_and_a:update()
      if chats[self.chat].done then
        -- return control to player and remove old woman
        g_freeze = false
        screen:del_ent(self)
        map_remove_desert_top_wall()
        music(0)
        return
      end

      if self.text_ticker.ready and (btnp(❎) or btnp(🅾️)) then
        local origChat = self.chat
        if chats[self.chat].get_next then
          local answer = nil
          if self.q_and_a then
            answer = self.q_and_a.answer
          end
          self.chat = chats[self.chat].get_next(answer)
        else
          self.chat += 1
        end

        if self.chat == -1 then
          -- answer not ready
          self.chat = origChat
        else
          self.text_ticker = build_text_ticker(chats[self.chat].text)
          self.q_and_a = nil
          self.add_q_and_a = chats[self.chat].answers ~= nil
        end
      end

      -- don't show the answers until the text_ticker is ready
      if self.add_q_and_a and self.text_ticker.ready then
        local ans = chats[self.chat].answers
        self.q_and_a = build_q_and_a(ans[1], ans[2])
        self.add_q_and_a = false
      end
    end,
    draw = function(self)
      self.text_ticker:draw()
      if (self.q_and_a) self.q_and_a:draw()
      local offset = time_toggle(24, 2)

      -- pal for eyes
      pal(12, 0)

      --draw feet first
      spr(56, 32, 64)
      spr(56, 40, 64, 1, 1, true)
      spr(40, 32, 56 + offset)
      spr(40, 40, 56 + offset, 1, 1, true)

      if chats[self.chat].fingers then
        draw_fingers(chats[self.chat].fingers)
      end

      pal()
    end
  }
end

function build_q_and_a(a1, a2)
  local x, y, w = 20, 118, 4
  return {
    answer = a1,
    update = function(self)
      if btnp(⬅️) then
        self.answer = a1
      elseif btnp(➡️) then
        self.answer = a2
      end
    end,
    draw = function(self)
      local a2_x = x + (#a1 + 4) * w
      print(a1, x + w, y, 10)
      print(a2, a2_x, y, 10)
      if self.answer == a1 then
        print(">", x, y, flr(rnd(16)))
      elseif self.answer == a2 then
        print(">", a2_x - w, y, flr(rnd(16)))
      end
      -- reset print color
      color(7)
    end
  }
end

function build_textbox2(texts, on_done)
  return {
    idx = 1,
    text_ticker = nil,
    update = function(self, screen)
      g_freeze = true
      if self.text_ticker == nil then
        self.text_ticker = build_text_ticker(texts[self.idx])
        screen:add_ent(self.text_ticker)
      elseif self.text_ticker.ready then
        if btnp(❎) or btnp(🅾️) then
          screen:del_ent(self.text_ticker)
          self.idx += 1
          if self.idx > count(texts) then
            g_freeze = false
            screen:del_ent(self)
            if (on_done) on_done()
          else
            self.text_ticker = build_text_ticker(texts[self.idx])
            screen:add_ent(self.text_ticker)
          end
        end
      else
      end
    end,
    draw = function(self)
    end
  }
end

function build_text_ticker(text)
  return {
    text = text,
    len = 1,
    ready = false,
    update = function(self)
      if not self.ready then
        if self.len < #self.text then
          self.len += 1
        else
          self.ready = true
        end
      end
    end,
    draw = function(self)
      local y = 96
      rectfill(0, y, 127, y + 32, 0)
      print(sub(self.text, 1, self.len), 4, y + 4, 7)

      -- border
      local bcol = 5
      rect(0, y + 1, 127, y + 31, bcol)
      rect(0, y + 1, 2, y + 3, bcol)
      rect(0, y + 1, 1, y + 2, 0)

      rect(125, y + 1, 127, y + 3, bcol)
      rect(126, y + 1, 127, y + 2, 0)

      rect(125, y + 28, 127, y + 31, bcol)
      rect(126, y + 29, 127, y + 31, 0)

      rect(0, y + 28, 2, y + 31, bcol)
      rect(0, y + 29, 1, y + 31, 0)

      -- reset print color
      color(7)
    end
  }
end

function build_sandwall()
  local x, y = 0, 22
  return {
    x = x, y = y,
    box = { 0, 0, 10, 96 },
    update = function()
    end,
    draw = function(ent)
      --outline_ent(ent)
    end,
    on_collide = function(self, monty, screen)
      if monty.dir == 2 and monty.mov then
        monty.mov = false
        local text = nil
        if monty.has_spade then
          text = "now to dig my way through the\nsand!"
        else
          text = "if only i had a spade to dig\nmy way through the sand..."
        end
        if monty.y > 72 then
          monty.move_to_pos = { x = monty.x, y = 72 }
        end

        screen:add_ent(build_textbox2(
          { text }, function()
            if monty.has_spade then
              g_freeze = true
              monty:start_dig_sandwall(function()
                g_freeze = false
                screen:del_ent(self)
              end)
            end
          end
        ))
      end
    end
  }
end

function build_thrower(type, start_x, start_y, path, path_index)
  local speed_x, speed_y = 1.2, 1.2
  return {
    x = start_x, y = start_y,
    path = path,
    path_index = path_index,
    cntr = 0,
    update = function(ent, screen)
      if (g_freeze) return
      update_position(ent, speed_x, speed_y)

      -- throw
      if ent.cntr == 30 then
        local dir, dist = rnd { 2, 3 }, 112 - ent.x
        if dir == 2 then
          dist = ent.x - 8
        end
        local projectile_type = iif(type == "monkey", "banana", "fireball")
        screen:add_ent(build_projectile(projectile_type, ent.x, ent.y + 4, dir, dist))
        ent.cntr = 0
      end
      ent.cntr += 1
    end,
    draw = function(ent)
      local offset = abs(g_toggle2 - 1)
      if type == "cactus" then
        spr(12, ent.x, ent.y + offset)
        spr(12, ent.x + 8, ent.y + g_toggle2, 1, 1, true)
        spr(28, ent.x, ent.y + 8 + offset)
        spr(28, ent.x + 8, ent.y + 8 + g_toggle2, 1, 1, true)
      elseif type == "monkey" then
        pal(12, 0)
        spr(103, ent.x, ent.y + offset)
        spr(103, ent.x + 7, ent.y + offset, 1, 1, true)
        spr(119, ent.x, ent.y + 8)
        spr(120, ent.x + 8, ent.y + 8)
        pal()
      else
        -- skellington
        pal(12, 0)
        spr(15, ent.x, ent.y)
        spr(15, ent.x + 7, ent.y, 1, 1, true)
        spr(31, ent.x, ent.y + 8 + offset)
        spr(31, ent.x + 7, ent.y + 8 + g_toggle2, 1, 1, true)
        -- mouth
        pset(ent.x + 5, ent.y + 8, 7)
        pset(ent.x + 9, ent.y + 8, 7)
        line(
          ent.x + 6, ent.y + 8 + offset,
          ent.x + 8, ent.y + 8 + offset, 7
        )
        pal()
      end
    end,
    box = { 2, 2, 13, 13 }
  }
end

function build_spade(x, y)
  return {
    x = x, y = y,
    update = function()
    end,
    draw = function(ent)
      pal(7, flr(rnd(16)))
      spr(54, x, y)
      pal()
    end,
    box = { 0, 1, 7, 6 },
    colliding = false,
    on_collide = function(spade, monty, screen)
      if (spade.colliding) return
      spade.colliding = true
      monty.mov = false
      screen:add_ent(build_textbox2(
        { "this spiffing spade\nwill come in handy!" }, function()
          screen:del_ent(spade)
          monty.has_spade = true
        end
      ))
    end
  }
end

function build_fli()
  return {
    x = 48, y = 52,
    path = split_path "16,20 80,84 80,100 16,100 80,36 80,20",
    path_index = 1,
    cntr = 0,
    help_cntr = 90,
    mode = 0,
    hit_flash = 0,
    start_fight = function(self)
      self.mode = 1
    end,
    update = function(self, screen)
      if self.mode == 1 then
        fli_update(self, screen)
      elseif self.mode == 2 then
        if self.x > 46 then
          self.x -= 1
        elseif self.x < 42 then
          self.x += 1
        end
        if self.y > 66 then
          self.y -= 1
        elseif self.y < 62 then
          self.y += 1
        end
      elseif self.mode == 3 then
        screen:add_ent(build_textbox2 {
          "it will help you on\nyour quest.",
          "good luck!",
          "don't forget to pop back\nand say hi some time."
        })
        screen:add_ent(build_machete())
        self.mode = 0
      end
    end,
    draw = function(ent)
      if (ent.hit_flash > 0) pal(12, flr(rnd(16)))
      --head
      spr(46, ent.x, ent.y)
      -- wings
      spr(60 + g_toggle2, ent.x - 6, ent.y + 9)
      spr(60 + g_toggle2, ent.x + 5, ent.y + 9, 1, 1, true)
      --body
      spr(62, ent.x + g_toggle2 - 1, ent.y + 8, 1, 1, g_toggle2 == 0)
      if (ent.hit_flash) pal()
      -- health
      for i = 0, 10 do
        if i < ent.health then
          print("●", 32 + i * 6, 0, 8)
        end
      end

      if ent.mode == 1 and ent.help_cntr > 0 then
        print("hit ❎ or 🅾️", 32, 112, flr(rnd(16)))
      end

      color(7)
    end,
    box = { 0, 0, 7, 15 },
    health = 10,
    on_hit = function(ent)
      ent.hit_flash = 10
      ent.health -= 1
    end
  }
end

function fli_update(ent, screen)
  local speed_x, speed_y = 1.2, 1.2
  update_position(ent, speed_x, speed_y)

  if ent.cntr == 24 then
    local dir, dist = 3, 112 - ent.x
    screen:add_ent(build_projectile("fireball", ent.x, ent.y + 4, dir, dist))
    ent.cntr = 0
  end
  ent.cntr += 1

  if (ent.hit_flash > 0) ent.hit_flash -= 1
  if ent.health <= 0 then
    ent.hit_flash = 0
    ent.mode = 2
    g_event = "fli_dead"
    screen:add_ent(build_textbox2(
      {
        "arrrrgh! defeated by a simple\nhuman. the shame!",
        "oh well, i can't complain.\nat least i had some company.",
        "it does get lonely here.\nperhaps we could be friends?",
        "as a kindly gesture please\naccept this machete..."
      }, function()
        ent.mode = 3
      end
    ))

    foreach(
      screen.ents, function(ent)
        if (ent.del_on_death) screen:del_ent(ent)
      end
    )
  end

  if (ent.help_cntr > 0) ent.help_cntr -= 1
end

function build_sand_blob(start_x, start_y)
  local speed = 3
  return {
    x = start_x, y = start_y,
    update = function(ent, screen)
      if (g_freeze) return
      if check_boss_collision(ent, screen.boss_fli) then
        screen.boss_fli:on_hit()
        screen:del_ent(ent)
      else
        --move
        ent.x -= speed
        if (ent.x <= 0) screen:del_ent(ent)
      end
    end,
    draw = function(ent)
      spr(53, ent.x, ent.y, 1, 1, false, g_toggle2 == 0)
    end,
    box = split("1,1,6,6"),
    del_on_death = true
  }
end

function build_monty_fist(start_x, start_y)
  local speed = 3
  return {
    x = start_x, y = start_y,
    update = function(ent, screen)
      if (g_freeze) return
      if check_boss_collision(ent, screen.boss_py) then
        screen.boss_py:on_hit()
        screen:del_ent(ent)
      else
        --move
        ent.x -= speed
        if (ent.x <= 0) screen:del_ent(ent)
      end
    end,
    draw = function(ent)
      spr(94, ent.x, ent.y)
    end,
    box = split("1,1,6,6"),
    del_on_death = true
  }
end

function check_boss_collision(ent, boss)
  local ex0, ey0, ew, eh = ent.x + ent.box[1], ent.y + ent.box[2], ent.box[3], ent.box[4]
  local mx0, my0, mw, mh = boss.x + boss.box[1], boss.y + boss.box[2], boss.box[3], boss.box[4]
  return ex0 < mx0 + mw and ex0 + ew > mx0 and ey0 < my0 + mh and eh + ey0 > my0
end

function build_machete()
  return {
    x = 108, y = 24,
    update = function()
    end,
    draw = function(ent)
      pal(7, flr(rnd(16)))
      spr(14, ent.x, ent.y)
      pal()
    end,
    on_collide = function(ent, monty, screen)
      monty.has_spade = false
      monty.has_machete = true
      monty:do_warp()
      screen:del_ent(ent)
      map_add_desert_town_square_wall()
    end,
    box = split("0,0,7,7")
  }
end

function build_north_key()
  return {
    x = 64, y = 72,
    update = function()
    end,
    draw = function(ent)
      pal(7, flr(rnd(16)))
      spr(13, ent.x, ent.y)
      pal()
    end,
    on_collide = function(ent, monty, screen)
      monty.has_north_key = true
      monty:do_warp()
      screen:del_ent(ent)
      map_add_jungle_town_square_wall()
    end,
    box = split("0,0,7,7")
  }
end

function build_py(x, y)
  return {
    x = x, y = y,
    mov = true,
    path = split_path "40,56 40,80 16,80 40,80 40,56 96,56 40,56 40,24 16,24 96,24 96,56",
    --path = split_path "40,20 40,80",
    path_index = 1,
    cntr = 0,
    help_cntr = 90,
    mode = 0,
    hit_flash = 0,
    start_fight = function(self)
      self.mode = 1
    end,
    fist_ent = nil,
    update = function(self, screen)
      if self.mode == 1 then
        py_update(self, screen)
      elseif self.mode == 2 then
        if self.x > 46 then
          self.x -= 1
        elseif self.x < 42 then
          self.x += 1
        end
        if self.y > 66 then
          self.y -= 1
        elseif self.y < 62 then
          self.y += 1
        end
      elseif self.mode == 3 then
        screen:add_ent(build_textbox2 {
          "it will help you on\nyour quest.",
          "good luck!",
          "don't forget to pop back\nand say hi some time."
        })
        screen:add_ent(build_machete())
        self.mode = 0
      end
    end,
    draw = function(ent)
      if (ent.hit_flash > 0) pal(12, flr(rnd(16)))
      -- eyes
      -- pset for bit of eye
      pset(ent.x - 1, ent.y + 5, 12)
      pset(ent.x - 1, ent.y + 6, 12)
      spr(77, ent.x, ent.y)
      pset(ent.x + 16, ent.y + 5, 12)
      pset(ent.x + 16, ent.y + 6, 12)
      spr(77, ent.x + 8, ent.y, 1, 1, true)
      -- py top
      spr(92, ent.x - 8, ent.y + 8)
      spr(93, ent.x, ent.y + 8)
      spr(93, ent.x + 8, ent.y + 8, 1, 1, true)
      spr(92, ent.x + 16, ent.y + 8, 1, 1, true)
      -- legs
      local l_offset, r_offset = 0, 0
      if ent.mov then
        if g_toggle2 == 0 then
          l_offset = -2
        else
          r_offset = -2
        end
      end
      spr(124, ent.x - 8, ent.y + 24 + l_offset)
      spr(125, ent.x, ent.y + 24 + l_offset)
      spr(125, ent.x + 8, ent.y + 24 + r_offset, 1, 1, true)
      spr(124, ent.x + 16, ent.y + 24 + r_offset, 1, 1, true)
      -- py bottom
      spr(108, ent.x - 8, ent.y + 16)
      spr(109, ent.x, ent.y + 16)
      spr(109, ent.x + 8, ent.y + 16, 1, 1, true)
      spr(108, ent.x + 16, ent.y + 16, 1, 1, true)

      if (ent.hit_flash) pal()
      if (ent.mode == 0) return
      -- health
      for i = 0, 10 do
        if i < ent.health then
          print("●", 32 + i * 6, 0, 8)
        end
      end

      if ent.mode == 1 and ent.help_cntr > 0 then
        print("hit ❎ or 🅾️", 40, 112, flr(rnd(16)))
      end

      color(7)

      --outline_ent(ent)
    end,
    box = { -2, 4, 17, 28 },
    health = 10,
    on_hit = function(ent)
      ent.hit_flash = 10
      ent.health -= 1
    end
  }
end

function py_update(ent, screen)
  local speed_x, speed_y = 1.2, 1.2
  update_position(ent, speed_x, speed_y)

  if ent.cntr == 24 then
    ent.fist_ent = build_py_fist(ent.x - 20, ent.y + 8)
    screen:add_ent(ent.fist_ent)
    ent.cntr = 0
  elseif ent.cntr == 12 and ent.fist_ent then
    screen:del_ent(ent.fist_ent)
    ent.fist_ent = nil
  end
  ent.cntr += 1

  -- move the fist with py
  if ent.fist_ent then
    ent.fist_ent.x = ent.x - 20
    ent.fist_ent.y = ent.y + 8
  end

  if (ent.hit_flash > 0) ent.hit_flash -= 1
  if ent.health <= 0 then
    ent.hit_flash = 0
    ent.mode = 2
    g_event = "py_dead"
    screen:add_ent(build_textbox2(
      {
        "arrrrgh! defeated by a simple\nhuman. the shame!",
        "oh well, i can't complain.\nat least i had some company.",
        "it does get lonely here.\nperhaps we could be friends?",
        "as a kindly gesture please\naccept this machete..."
      }, function()
        ent.mode = 3
      end
    ))

    foreach(
      screen.ents, function(ent)
        if (ent.del_on_death) screen:del_ent(ent)
      end
    )
  end

  if (ent.help_cntr > 0) ent.help_cntr -= 1
end

function build_py_fist(x, y)
  return {
    x = x, y = y,
    update = function(ent, screen)
    end,
    draw = function(ent)
      pal(10, 9)
      pal(12, 4)
      spr(9, ent.x, ent.y)
      spr(10, ent.x + 8, ent.y)
      spr(25, ent.x, ent.y + 8)
      spr(26, ent.x + 8, ent.y + 8)
      --outline_ent(ent)
      pal()
    end,
    box = { 4, 2, 15, 13 },
    del_on_death = true
  }
end

function build_gerts(x, y)
  return {
    x = x, y = y,
    mov = true,
    cntr = 0,
    inc = 1,
    has_machete_message_added = false,
    has_north_key_message_added = false,
    update = function(ent, screen)
      ent.cntr += ent.inc
      if (ent.cntr == 0 or ent.cntr == 3) ent.inc *= -1
      if g_event == "has_machete_message" and not ent.has_machete_message_added then
        screen:add_ent(build_textbox2 { "monty! use the machete to\nhack your way into\nthe east jungle!" })
        g_event = nil
        ent.has_machete_message_added = true
      elseif g_event == "has_north_key_message" and not ent.has_north_key_message_added then
        screen:add_ent(build_textbox2 { "monty! you have the key\nto the north dungeon.\nget in there quick!" })
        g_event = nil
        ent.has_north_key_message_added = true
      end
    end,
    draw = function(ent)
      -- hat propeller
      if ent.cntr > 0 then
        pset(ent.x + 6, ent.y + 1, 12)
        pset(ent.x + 9, ent.y + 1, 12)
      end
      if ent.cntr > 1 then
        pset(ent.x + 5, ent.y + 1, 12)
        pset(ent.x + 10, ent.y + 1, 12)
      end
      if ent.cntr > 2 then
        pset(ent.x + 4, ent.y + 1, 12)
        pset(ent.x + 11, ent.y + 1, 12)
      end
      spr(68, ent.x, ent.y)
      spr(68, ent.x + 8, ent.y, 1, 1, true)
      -- blue to black for the eyes
      pal(12, 0)
      spr(84, ent.x, ent.y + 8)
      spr(84, ent.x + 8, ent.y + 8, 1, 1, true)
      pal()
    end
  }
end

function build_door(x, y, k)
  return {
    x = x, y = y,
    open = false,
    update = function()
    end,
    draw = function(ent)
      if (ent.open) return
      pal(12, 0)
      --top
      spr(70, x, y)
      spr(70, x + 7, y, 1, 1, true)
      --bottom
      spr(86, x, y + 16)
      spr(86, x + 7, y + 16, 1, 1, true)
      --middle
      spr(86, x, y + 12)
      spr(86, x + 7, y + 12, 1, 1, true)
      spr(86, x, y + 8)
      spr(86, x + 7, y + 8, 1, 1, true)

      -- key hole
      local key_x, key_y = x + 8, y + 13
      rectfill(key_x + 1, key_y, key_x + 2, key_y + 3, 0)
      rectfill(key_x, key_y + 1, key_x + 3, key_y + 2, 0)
      rectfill(key_x, key_y + 4, key_x + 3, key_y + 4, 0)
      pset(key_x + 2, key_y - 1, 4)
      pset(key_x + 2, key_y + 5, 4)
      pal()
    end,
    box = { 0, 0, 7, 24 },
    collided = false,
    on_collide = function(ent, monty, screen)
      if (ent.collided) return
      ent.collided = true
      -- todo: could save some code here
      if k == "north_key" then
        if monty.has_north_key then
          monty.has_north_key = false
          screen:del_ent(ent)
        else
          screen:add_ent(build_textbox2(
            { "hmm, it appears this door\nis locked." }, function()
              ent.collided = false
              monty.y += 2
            end
          ))
        end
      elseif k == "simple_key" then
        if monty.has_simple_key then
          monty.has_simple_key = false
          screen:del_ent(ent)
        else
          screen:add_ent(build_textbox2(
            { "hmm, it appears this door\nis locked." }, function()
              ent.collided = false
              monty.x -= 2
            end
          ))
        end
      end
    end
  }
end

function build_foliage()
  local x, y = 119, 13
  return {
    x = x, y = y,
    box = { 0, 0, 6, 110 },
    update = function()
    end,
    draw = function(ent)
      --outline_ent(ent)
    end,
    on_collide = function(self, monty, screen)
      if monty.dir == 3 and monty.mov then
        monty.mov = false
        local text = nil
        if monty.has_machete then
          text = "now to slash my way\nthrough the foliage!"
        else
          text = "if only i had a machete to\nslash my way through the\nfoliage..."
        end
        if monty.y > 72 then
          monty.move_to_pos = { x = monty.x, y = 72 }
        end

        screen:add_ent(build_textbox2(
          { text }, function()
            if monty.has_machete then
              g_freeze = true
              monty:start_slash_foliage(function()
                g_freeze = false
                screen:del_ent(self)
              end)
            end
          end
        ))
      end
    end
  }
end

function build_jazzer(start_x, start_y, min_y, max_y)
  return {
    x = start_x, y = start_y,
    min_y = min_y, max_y = max_y,
    speed = .75,
    update = function(ent)
      ent.y += ent.speed
      if ent.y < ent.min_y or ent.y > ent.max_y then
        ent.speed *= -1
        ent.y += ent.speed
      end
    end,
    draw = function(ent)
      local s = 36
      if (g_toggle2 == 0) s = 37
      spr(s, ent.x, ent.y)
    end,
    box = split("1,1,6,6")
  }
end

function build_snake(x, y)
  return {
    x = 130, y = y,
    target_x = x,
    snake_cntr = 1,
    show_bra = false,
    update = function(ent)
      if g_toggle2 == 0 then
        ent.snake_cntr += 1
        if (ent.snake_cntr > 6) ent.snake_cntr = 1
      end
      if (ent.x > ent.target_x) ent.x -= 1
      if g_event == "add_bra_to_snake" then
        ent.show_bra = true
        g_event = nil
      end
    end,
    draw = function(ent)
      pal(12, 0)
      local xoset, cntr_m4 = 0, time_toggle(12, 4)
      if (cntr_m4 > 2) xoset += 1
      spr(87, ent.x - 1 + xoset, y - 8)
      pal()
      snake_segment(ent.x, ent.y, 5, 5, ent.snake_cntr, 1)
      snake_segment(ent.x, ent.y + 5, 5, 5, ent.snake_cntr, 2)
      snake_segment(ent.x, ent.y + 10, 5, 4, ent.snake_cntr, 3)
      snake_segment(ent.x + 1, ent.y + 14, 4, 4, ent.snake_cntr, 4)
      snake_segment(ent.x + 1, ent.y + 18, 3, 3, ent.snake_cntr, 5)
      snake_segment(ent.x + 1, ent.y + 21, 2, 2, ent.snake_cntr, 6)

      if ent.show_bra then
        snake_boob(ent.x - 3, ent.y + 6, 0, true)
        snake_boob(ent.x + 8, ent.y + 6, 0, true)
        -- bra
        spr(63, x - 5, y + 2)
        spr(63, x + 3, y + 2, 1, 1, true)
      else
        snake_boob(ent.x - 3, ent.y + 6, g_toggle2)
        snake_boob(ent.x + 8, ent.y + 6, abs(g_toggle2 - 1))
      end
    end,
    box = { 0, 0, 7, 15 },
    on_collide = function(ent)
    end
  }
end

function snake_segment(sx, sy, w, h, sc, idx)
  local oset = 0
  if (sc == idx) oset = 1
  local ssx = sx + oset
  rectfill(ssx, sy, ssx + w, sy + h, 10)
  rect(ssx, sy, ssx + w, sy + h, 3)
end

function snake_boob(x, y, yoset, show_bra)
  if show_bra then
    circfill(x, y + yoset, 4, 15)
  else
    circfill(x, y + yoset, 5, 15)
  end
  circfill(x, y + 1 + yoset, 1, 4)
end

function build_jonathon(x, y)
  return {
    x = x, y = y,
    phase = 0,
    --show_bra = false,
    update = function(ent, screen)
      if ent.phase == 1 then
        screen:add_ent(build_snake(66, 32))
        screen:add_ent(build_textbox2(
          {
            "his name is jon-a-thon...",
            "he has large wobbly boobies!",
            "he doesn't wear a bra...",
            "he is the no-bra co-bra!",
            "his lack of brassiere\nis embarrassing!",
            "legend has it that a suitable\nbra is hidden in this jungle...",
            "if you can find the bra i will\nhelp you on your journey...",
            "good luck with your search!"
          }, function()
            music(0)
          end
        ))
        ent.phase = 2
      end

      if g_event == "jonathon_with_bra" then
        g_event = nil
        screen:add_ent(build_textbox2(
          {
            "rejoice!!!",
            "you have found the bra.",
            "time to tame those boobies..."
          }, function()
            g_event = "remove_bra_icon"
            screen:add_ent(build_textbox2(
              {
                "ahh, that's much better.",
                "maybe a little snug but\nit'll do the job.",
                "as promised i will help you\non your journey.",
                "take this key.\nit opens the door\nto the north dungeon."
              }, function()
                screen:add_ent(build_north_key())
              end
            ))
          end
        ))
      end
      --
    end,
    draw = function(ent)
      local ft_s, y_oset, cntr_m4 = 18, 0, time_toggle(12, 4)
      if cntr_m4 >= 2 then
        ft_s, y_oset = 6, 1
      end

      pal(12, 0)
      spr(45, ent.x, ent.y + y_oset)
      spr(45, ent.x + 8, ent.y + y_oset, 1, 1, true)
      --tache
      pal(7, 0)
      --body
      pal(3, 2)
      spr(ft_s, ent.x, ent.y + 8 + y_oset)
      spr(ft_s, ent.x + 8, ent.y + 8 + y_oset, 1, 1, true)
      pal()
    end
  }
end

function build_projectile(type, start_x, start_y, dir, dist)
  local speed = 2.5
  return {
    x = start_x, y = start_y,
    dist = dist,
    update = function(ent, screen)
      if (g_freeze) return
      if dir == 0 then
        ent.y -= speed
      elseif dir == 1 then
        ent.y += speed
      elseif dir == 2 then
        ent.x -= speed
      else
        ent.x += speed
      end
      ent.dist -= speed
      if (ent.dist <= -2) screen:del_ent(ent)
    end,
    draw = function(ent)
      if type == "arrow" then
        local s = iif(dir < 2, 51, 35)
        spr(s, ent.x, ent.y, 1, 1, dir == 2)
      elseif type == "fireball" then
        spr(44, ent.x, ent.y, 1, 1, g_toggle2 == 0)
      elseif type == "banana" then
        local s = iif(g_toggle2 == 0, 30, 52)
        spr(s, ent.x, ent.y, 1, 1, g_toggle4 == 1 or g_toggle4 == 2)
      end
    end,
    box = split("1,1,6,6"),
    del_on_death = true
  }
end

function build_bra(x, y)
  return {
    x = x, y = y,
    update = function()
    end,
    draw = function()
      pal(6, flr(rnd(16)))
      spr(63, x, y)
      spr(63, x + 8, y, 1, 1, true)
      pal()
    end,
    box = { 0, 0, 15, 7 },
    collided = false,
    on_collide = function(ent, monty, screen)
      if not ent.collided then
        ent.collided = true
        screen:add_ent(build_textbox2(
          { "this must be the snake's bra!" }, function()
            monty.has_bra = true
            screen:del_ent(ent)
          end
        ))
      end
    end
  }
end

function build_simple_key()
  return {
    x = 64, y = 86,
    update = function()
    end,
    draw = function(ent)
      pal(10, flr(rnd(16)))
      spr(47, ent.x, ent.y)
      pal()
    end,
    colliding = false,
    on_collide = function(ent, monty, screen)
      if (ent.colliding) return
      ent.colliding = true
      screen:add_ent(build_textbox2(
        { "huzzah! a key!" }, function()
          monty.has_simple_key = true
          screen:del_ent(ent)
        end
      ))
    end,
    box = split("0,0,7,7")
  }
end