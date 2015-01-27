local SALARY, PRICE = 50, 50
local PLAYER_BASE_SPEED = (require "src/Moveable").new().speed

local function next_day(game)
  local qm = game.quest_manager
  qm.day = qm.day + 1
  if qm.food then
    game.player.speed = PLAYER_BASE_SPEED
    qm.starvation = 0
    qm.food = false
  else
    game.player.speed = game.player.speed - 0.1 * PLAYER_BASE_SPEED
    qm.starvation = qm.starvation + 1
    if qm.starvation > 3 then 
      set_current_stage(stages.game_over)
    end
  end
end

return {
  {
    start = "Home",
    destination = "Work",
    hour = 8,
    message = "Проснись, Нео! Тебе нужно добраться на работу к 9:00!",
    success = function(game)
      local qm = game.quest_manager
      qm.money = qm.money + SALARY
    end,
    fail = function(game)
    end
  },
  {
    start = "Work",
    destination = "Shop",
    hour = 18,
    message = "Скорей, нужно купить еды в магазине до 19:00, а то он закроется!",
    success = function(game)
      local qm = game.quest_manager
      if qm.money >= PRICE then
        qm.money = qm.money - PRICE
        qm.food = true
      end
    end,
    fail = function(game)
    end
  },
  {
    start = "Shop",
    destination = "Home",
    hour = 19,
    message = "Нужно успеть домой до 20:00, а то не выспишься! Завтра на работу!",
    success = function(game)
      next_day(game)
    end,
    fail = function(game)
      next_day(game)
      game.player.speed = game.player.speed - 0.05 * PLAYER_BASE_SPEED
    end
  }
}
