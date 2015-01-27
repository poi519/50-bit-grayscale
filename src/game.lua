local game = {}

local Moveable = require "src/Moveable"
local map = require "src/map"
local player = require "src/player"
local pedestrian_manager = require "src/pedestrian_manager"
local quest_manager = require "src/quest_manager"

game.map, game.player, game.pedestrian_manager, game.quest_manager =
  map, player, pedestrian_manager, quest_manager

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
local INFO_FONT = love.graphics.newFont("resources/fonts/consola.ttf", 16)
local BLACK, WHITE = {0, 0, 0}, {255, 255, 255}
local ARROW_COLOR = {0, 200, 200}

function game.init()
  local street_sounds = love.audio.newSource("resources/audio/street5.mp3", "static")
  street_sounds:setLooping(true)
  love.audio.play(street_sounds)
  player.speed = Moveable.new().speed
  quest_manager.reset()
  quest_manager.setup_quest(game)
end

local function to_screen_cordinates(x, y, w, h)
   local sx = (x - player.x) * UNIT + w/2
   local sy = (y - player.y) * UNIT + h/2
   return sx, sy
end

function game.draw()
  local lg = love.graphics
  local h = lg.getHeight()
  local w = lg.getWidth()
  -- draw map
  local i0 = math.floor(player.x - w/2 / UNIT)
  local i1 = math.ceil(player.x + w/2 / UNIT)
  local j0 = math.floor(player.y - h/2 / UNIT)
  local j1 = math.ceil(player.y + h/2 / UNIT)
  
  for i = i0, i1 do
    for j = j0, j1 do
      lg.setColor(BLOCK_COLORS[map.get(i, j)])
      local cx, cy = to_screen_cordinates(i, j, w, h)
      lg.rectangle("fill", cx - UNIT/2, cy - UNIT/2, UNIT, UNIT)
    end
  end
  -- draw pedestrians
  for _, p in ipairs(pedestrian_manager.array) do
    local sx, sy = to_screen_cordinates(p.x, p.y, w, h)
    lg.setColor(PEDESTRIAN_COLOR)
    lg.circle("fill", sx, sy, 1/2 * UNIT, 50)
  end
  -- draw player
  lg.setColor(PLAYER_COLOR)
  lg.circle("fill", w/2, h/2, 1/2 * UNIT, 50)
  -- draw info
  lg.setColor(BLACK)
  lg.rectangle("fill", 0, h - 32, w, h)
  lg.setColor(WHITE)
  lg.setFont(INFO_FONT)
  local quest = quest_manager.quest
  lg.printf(
    quest.message,
    0, h - 24, w, 'center'
  )
  local minutes = math.floor(quest_manager.minutes)
  if minutes < 10 then minutes = "0" .. minutes end
  local time = quest_manager.day .. ":" ..
    quest.hour .. ":" .. minutes
  lg.printf(time, 0, h - 24, w, 'right')
  lg.printf("$" .. quest_manager.money, 0, h - 24, w, "left")
  -- draw quest direction
  local destination = map.centers[quest.destination]
  local a = math.atan2(destination[2] - player.y, destination[1] - player.x)
  local sin, cos = math.sin(a), math.cos(a)
  lg.setColor(ARROW_COLOR)
  lg.setLineWidth(2)
  lg.line(
    w/2 - UNIT/2.2 * cos, h/2 - UNIT/2.2 * sin,
    w/2 + UNIT/2.2 * cos, h/2 + UNIT/2.2 * sin,
    w/2 - UNIT/5 * sin, h/2 + UNIT/5 * cos,
    w/2 + UNIT/5 * sin, h/2 - UNIT/5 * cos,
    w/2 + UNIT/2.2 * cos, h/2 + UNIT/2.2 * sin
  )
end

function game.update(dt)
  player:move(dt, map)
  pedestrian_manager.update(dt, map)
  quest_manager.update(dt, game)
end

function game.keypressed(key)
  local dx, dy
  if key == 'w'or key == 'up' then
    dx, dy = 0, -1
  elseif key == 'a' or key == 'left' then
    dx, dy = -1, 0
  elseif key == 's' or key == 'down' then
    dx, dy = 0, 1
  elseif key == 'd' or key == 'right' then
    dx, dy = 1, 0
  end
  if dx and dy then
    player:set_direction(dx, dy)
  end
end

function game.keyreleased(key)
  if not love.keyboard.isDown('w', 'a', 's', 'd', 'up', 'down', 'left', 'right')
  then
    player:set_direction(0, 0)
  end
end

return game
