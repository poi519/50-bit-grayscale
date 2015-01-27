local game_over = {
  message = ""
}

local BIG_FONT = love.graphics.newFont("resources/fonts/times.ttf", 64)
local SMALL_FONT = love.graphics.newFont("resources/fonts/times.ttf", 16)
function game_over.draw()
  local h = love.graphics.getHeight()
  local w = love.graphics.getWidth()

  love.graphics.setFont(BIG_FONT)
  love.graphics.printf(
    "GAME OVER\n" .. message,
    0, h / 2, w, 'center'
  )
  
end

local t = 0
local T_MAX = 3

function game_over.update(dt)
  t = t + dt
  if t > T_MAX then set_current_stage(stages.game) end
end

return game_over
