local Moveable = require "src/Moveable"

local pedestrian_manager = {
  array = {}
}

local INV_CREATION_PROBABILITY = 10

local DIRECTIONS = {
  {1, 0},
  {0, 1},
  {0, 0},
  {0, -1},
  {-1, 0}
}
  
function pedestrian_manager.init(map)
  -- TODO reuse pedestrians
  pedestrian_manager.array = {}
  for j = 1, map.height do
    for i = 1, map.width do
      if map.get(i, j) == "Pedestrian area" and
      math.random(INV_CREATION_PROBABILITY) == 1 then
        local p = Moveable.new()
        p.x, p.y = i, j
        local d = DIRECTIONS[math.random(#DIRECTIONS)]
        p:set_direction(d[1], d[2])
        table.insert(pedestrian_manager.array, p)
      end
    end 
  end
end
  
local AVERAGE_RUN_DURATION = 10

function pedestrian_manager.update(dt, map)
  for _, p in ipairs(pedestrian_manager.array) do
    local moved = p:move(dt, map)
    if (not moved) or math.random() <= dt / AVERAGE_RUN_DURATION then
      local d = DIRECTIONS[math.random(#DIRECTIONS)]
      p:set_direction(d[1], d[2])
    end
  end
end

return pedestrian_manager
