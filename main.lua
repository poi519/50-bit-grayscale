local stages = require "src/stages"
local current_stage = stages.splash

function love.load() 
  love.graphics.setNewFont("resources/fonts/times.ttf", 14)
end

function love.draw()
  current_stage.draw()
end

function love.update(dt)
  if current_stage.update then current_stage.update(dt) end
end
