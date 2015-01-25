-- Global
stages = require "src/stages"
current_stage = stages.game

function love.draw()
  current_stage.draw()
end

function love.update(dt)
  if current_stage.update then current_stage.update(dt) end
end

function love.keypressed(key)
  if current_stage.keypressed then current_stage.keypressed(key) end
end

function love.keyreleased(key)
  if current_stage.keyreleased then current_stage.keyreleased(key) end
end
