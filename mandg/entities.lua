function build_idiot(start_x, start_y, min_x, max_x)
  local speed = 0.75
  return {
    x = start_x, y = start_y,
    min_x = min_x, max_x = max_x,

    update = function(self)
      -- if (state.freeze) return
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
    box = { 1, 1, 6, 6 }
  }
end

function build_fuzzy(start_x, start_y, path, path_index)
  local speed_x = 0.75
  local speed_y = 0.75

  return {
    x = start_x, y = start_y,
    path = path,
    path_index = path_index,
    update = function(self)
      -- if (state.freeze) return
      local next_x = self.path[self.path_index].x
      local next_y = self.path[self.path_index].y
      if self.x < next_x then
        self.x += speed_x
      elseif self.x > next_x then
        self.x -= speed_x
      end

      if self.y < next_y then
        self.y += speed_y
      elseif self.y > next_y then
        self.y -= speed_y
      end

      if abs(self.x - next_x) < 1
          and abs(self.y - next_y) < 1 then
        --clamp
        self.x = next_x
        self.y = next_y
        self.path_index += 1
        if (self.path_index > count(self.path)) self.path_index = 1
      end
    end,
    draw = function(self)
      --if ((map_x == 4 or map_x == 6) and map_y == 0) pal(1, 5)
      local tog_4 = time_toggle(12, 4)
      spr(
        16, self.x, self.y, 1, 1,
        tog_4 > 1,
        tog_4 == 1 or tog_4 == 2
      )
      --pal()
    end,
    box = { 1, 1, 6, 6 }
  }
end

function build_firestone(x, y, dir, t, dist)
  local s = 32
  local flip_x = false
  local flip_y = false
  if (dir < 2) s = 48
  return {
    x = x, y = y,
    timer = 0,
    arrow_added = false,
    update = function(self, screen)
      self.timer = time_toggle(18, 18)
      if self.timer == t then
        if not self.arrow_added then
          local x_offset = 0
          local y_offset = 0
          if dir == 3 then
            x_offset = 8
          elseif dir == 1 then
            y_offset = 8
          end
          screen:add_ent(build_arrow(x + x_offset, y + y_offset, dir, dist))
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
    box = { 1, 1, 6, 6 }
  }
end

function build_arrow(start_x, start_y, dir, dist)
  local speed = 2.5
  return {
    x = start_x, y = start_y,
    dist = dist,
    update = function(self, screen)
      if dir == 0 then
        self.y -= speed
      elseif dir == 1 then
        self.y += speed
      elseif dir == 2 then
        self.x -= speed
      else
        self.x += speed
      end
      self.dist -= speed
      if (self.dist <= -2) screen:del_ent(self)
    end,
    draw = function(self)
      local s = 35
      if (dir < 2) s = 51
      spr(s, self.x, self.y)
    end,
    box = { 1, 1, 6, 6 }
  }
end

function build_old_woman()
  local chats = {
    { text = "oooh! hello young man.\nhee hee hee..." },
    { text = "with those spectacles you\nmust have poor eyesight!" },
    { text = "let me test your vision.\nif you pass the test i will\nhelp you on your journey." },
    {
      text = "ok then, how many fingers am\ni holding up?\n\n     2     3",
      answers = { 1, 2 },
      fingers = 3
    },
    {
      text = "wrong! the answer is 3.\nlet's try again...",
      fingers = 3,
      jump = 2
    },
    {
      text = "wrong! the answer is 2.\nlet's try again...",
      fingers = 2
    },
    {
      text = "how many fingers am i\nholding up this time?\n\n     1     2",
      answers = { 1, 1 },
      fingers = 1
    },
    {
      text = "wrong! i am not holding\nup any fingers.\none more try...",
      fingers = 0
    },
    { text = "i'll make it easy this time..." },
    {
      text = "how many fingers am i\nholding up?\n\n     5     5",
      answers = { 1, 1 },
      fingers = 5
    },
    {
      text = "wrong, 6 fingers!\nyou are as blind as a bat.\nhee hee hee...",
      fingers = 6
    },
    { text = "not to worry, i'll help you\nanyway. i will open up the way\nsouth using my magical powers.\ncontinue your journay that way." },
    { done = true }
  }

  local function draw_finger_spr(a, b, c, d)
    local x = 18
    local y = 58
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
    answer = 1,
    update = function(self)
      --if(state.old_woman_done) return
      if chats[self.chat].done then
        --state.old_woman_done = true
        -- clear the wall
        --[[ mset(20, 15, 64)
        mset(21, 15, 64)
        mset(22, 15, 64)
        mset(23, 15, 64)
        mset(24, 15, 64)
        mset(25, 15, 64)
        mset(26, 15, 64)
        mset(27, 15, 64) ]]
        return
      end

      if btnp(❎) or btnp(🅾️) then
        if chats[self.chat].answers then
          self.chat += chats[self.chat].answers[self.answer]
        elseif chats[self.chat].jump then
          self.chat += chats[self.chat].jump
        else
          self.chat += 1
        end

        self.answer = 1
      end

      if chats[self.chat].answers then
        if btnp(⬅️) then
          self.answer = 1
        elseif btnp(➡️) then
          self.answer = 2
        end
      end
    end,
    draw = function(self)
      --if(state.old_woman_done or chats[self.chat].done) return

      print(chats[self.chat].text, 4, 100, 7)

      if chats[self.chat].answers then
        if self.answer == 1 then
          print(">", 20, 118, flr(rnd(16)))
        elseif self.answer == 2 then
          print(">", 44, 118, flr(rnd(16)))
        end
        -- reset print color
        print("", 0, 0, 7)
      end

      local offset = time_toggle(24, 2)
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