local game = {}

game.map = require "src/map"
game.player = require "src/player"

local UNIT = 48
local PLAYER_COLOR = {255, 255, 255}
local BLOCK_COLORS = {
  ["Pedestrian area"] = {150, 150, 150},
  ["Building"] = {50, 50, 50}
}

function game.draw()
  local lg = love.graphics
  local h = lg.getHeight()
  local w = lg.getWidth()
  -- draw map
  local i0 = math.floor(game.player.x - w/2 / UNIT)
  local i1 = math.ceil(game.player.x + w/2 / UNIT)
  local j0 = math.floor(game.player.y - h/2 / UNIT)
  local j1 = math.ceil(game.player.y + h/2 / UNIT)
  
  for i = i0, i1 do
    for j = j0, j1 do
      lg.setColor(BLOCK_COLORS[game.map.get(i, j)])
      local cx = (i - game.player.x) * UNIT + w/2
      local cy = (j - game.player.y) * UNIT + h/2
      lg.rectangle("fill", cx - UNIT/2, cy - UNIT/2, UNIT, UNIT)
    end
  end
   -- draw player
  lg.setColor(PLAYER_COLOR)
  love.graphics.circle("fill", w/2, h/2, 1/2 * UNIT, 40)
end

local function move(moveable, dt)
  local x = moveable.x + moveable.speed * moveable.direction[1] * dt
  local y = moveable.y + moveable.speed * moveable.direction[2] * dt
  
  local function is_passable(i, j)
    return game.map.get(i, j) ~= "Building"
  end
  
  if is_passable(math.floor(x), math.floor(y)) and
    is_passable(math.floor(x), math.ceil(y)) and
    is_passable(math.ceil(x), math.floor(y)) and
    is_passable(math.ceil(x), math.ceil(y)) then
      moveable.x, moveable.y = x, y
  end
end

local function set_direction(moveable, dx, dy)
    moveable.direction[1] = dx
    moveable.direction[2] = dy
end

function game.update(dt)
  move(game.player, dt)
end

function game.keypressed(key)
  local dx, dy
  if key == 'w' then
    dx, dy = 0, -1
  elseif key == 'a' then
    dx, dy = -1, 0
  elseif key == 's' then
    dx, dy = 0, 1
  elseif key == 'd' then
    dx, dy = 1, 0
  end
  if dx and dy then
    set_direction(game.player, dx, dy)
  end
end

function game.keyreleased(key)
  if not love.keyboard.isDown('w', 'a', 's', 'd') then
    set_direction(game.player, 0, 0)
  end
end

return game