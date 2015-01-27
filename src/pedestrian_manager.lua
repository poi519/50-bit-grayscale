local Moveable = require "src/Moveable"

local pedestrian_manager = {
  array = {}
}

local INV_CREATION_PROBABILITY = 10
local DIRECTIONS = Moveable.DIRECTIONS
  
function pedestrian_manager.init(map)
  pedestrian_manager.array = Moveable.random_place(map, INV_CREATION_PROBABILITY)
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
