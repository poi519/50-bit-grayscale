local splash = {}

local BIG_FONT = love.graphics.newFont("resources/fonts/times.ttf", 32)
local SMALL_FONT = love.graphics.newFont("resources/fonts/times.ttf", 16)
function splash.draw()
  local h = love.graphics.getHeight()
  local w = love.graphics.getWidth()

  love.graphics.setFont(BIG_FONT)
  love.graphics.printf(
    "50 градаций серого",
    0, h / 2, w, 'center'
  )

  love.graphics.setFont(SMALL_FONT)
  love.graphics.printf(
    "Для /gd/ TWO WEEKS RELOADED",
    0, 0, w, 'center'
  )
end

return splash
