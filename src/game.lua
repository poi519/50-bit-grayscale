local game = {}

game.map = require "src/map"
game.player = require "src/player"
game.pedestrian_manager = require "src/pedestrian_manager"


local UNIT = 48
local PLAYER_COLOR = {255, 255, 255}
local BLOCK_COLORS = {
  ["Pedestrian area"] = {150, 150, 150},
  ["Building"] = {50, 50, 50},
  ["Traffic area"] = {200, 200, 200},
  ["Home"] = {100, 100, 100},
  ["Shop"] = {100, 150, 100},
  ["Work"] = {100, 100, 150}
}
local PEDESTRIAN_COLOR = {125, 125, 125}

function game.init()
  local street_sounds = love.audio.newSource("resources/audio/street5.mp3", "stream")
  street_sounds:setLooping(true)
  love.audio.play(street_sounds)
  game.pedestrian_manager.init(game.map)
end

local function to_screen_cordinates(x, y, w, h)
   local sx = (x - game.player.x) * UNIT + w/2
   local sy = (y - game.player.y) * UNIT + h/2
   return sx, sy
end

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
      local cx, cy = to_screen_cordinates(i, j, w, h)
      lg.rectangle("fill", cx - UNIT/2, cy - UNIT/2, UNIT, UNIT)
    end
  end
  -- draw pedestrians
  for _, p in ipairs(game.pedestrian_manager.array) do
    local sx, sy = to_screen_cordinates(p.x, p.y, w, h)
    lg.setColor(PEDESTRIAN_COLOR)
    lg.circle("fill", sx, sy, 1/2 * UNIT, 50)
  end
   -- draw player
  lg.setColor(PLAYER_COLOR)
  lg.circle("fill", w/2, h/2, 1/2 * UNIT, 50)
end

function game.update(dt)
  game.player:move(dt, game.map)
  game.pedestrian_manager.update(dt, game.map)
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
    game.player:set_direction(dx, dy)
  end
end

function game.keyreleased(key)
  if not love.keyboard.isDown('w', 'a', 's', 'd') then
    game.player:set_direction(0, 0)
  end
end

return game
