local Moveable = require "src/Moveable"

local gopnik_manager = {
  array = {}
}

local INV_CREATION_PROBABILITY = 100
local DIRECTIONS = Moveable.DIRECTIONS

function gopnik_manager.init(map)
  gopnik_manager.array = Moveable.random_place(map, INV_CREATION_PROBABILITY)
end

local AVERAGE_RUN_DURATION = 10
local TIMEOUT = 20
local SIGHT = 10

local function distance(a, b, c, d)
  local x, y = a - c, b - d
  return math.sqrt(x * x + y * y)
end

local directions4 = {{0,-1}, {0, 1}, {-1, 0}, {1, 0}}
local function best_direction(i, j, x, y, map)
  local best_distance = 0
  local best_direction
  for _, dir in ipairs(directions4) do
    local x0, y0 = i + dir[1], j + dir[2]
    if map.is_passable(x0, y0) then
      local dist = distance(x0, y0, x, y)
      if best_distance == 0 or best_distance > dist then
        best_distance = dist
        best_direction = dir
      end
    end
  end
  return best_direction
end

function gopnik_manager.update(dt, game)
  local map, player = game.map, game.player
  for _, g in ipairs(gopnik_manager.array) do
    local moved = g:move(dt, map)
    if g.timer and g.timer > 0 then
      g.timer = g.timer - dt
    else
      g.timer = 0
    end
    local dist = distance(g.x, g.y, player.x, player.y)
    if dist <= SIGHT and g.timer <= 0 then
      -- check collision
      if dist < 1 then 
        game.quest_manager.money = 0
        game.last_message = "Гопник забрал у тебя все деньги"
        g.timer = TIMEOUT
      else
        -- chase
        local i, j = math.floor(g.x + 0.5), math.floor(g.y + 0.5)
        g.direction = best_direction(i, j, player.x, player.y, map)
      end
    else
      -- random walk
      if (not moved) or math.random() <= dt / AVERAGE_RUN_DURATION then
        local d = DIRECTIONS[math.random(#DIRECTIONS)]
        g:set_direction(d[1], d[2])
      end
    end
  end
end

return gopnik_manager
