local SALARY, PRICE = 5, 5
local PLAYER_BASE_SPEED = (require "src/Moveable").new().speed

local starvation_message = {"Ты голоден.", "Ты очень голоден", "Ты умираешь от голода"}
local function next_day(game)
  local qm = game.quest_manager
  qm.day = qm.day + 1
  if qm.food then
    game.player.speed = PLAYER_BASE_SPEED
    qm.starvation = 0
    qm.food = false
    game.last_message = ""
  else
    game.player.speed = game.player.speed - 0.1 * PLAYER_BASE_SPEED
    qm.starvation = qm.starvation + 1
    game.last_message = starvation_message[qm.starvation]
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
      game.last_message = "Ты успел на работу вовремя и получил $" .. SALARY
    end,
    fail = function(game)
      game.last_message = "Ты опоздал на работу и тебе не заплатили за сегодня."
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
        game.last_message = "Ты успел в магазин и купил еды на $" .. PRICE
      else 
        game.last_message = "Тебе не хватило на еду. Нужно $" .. PRICE
      end
    end,
    fail = function(game)
      game.last_message = "Ты опоздал в магазин и остался без еды."
    end
  },
  {
    start = "Shop",
    destination = "Home",
    hour = 19,
    message = "Нужно успеть домой до 20:00, а то не выспишься! Завтра на работу!",
    success = function(game)
      next_day(game)
      game.last_message = "Ты прекрасно выспался и готов к новому дню боли. " ..
        game.last_message
    end,
    fail = function(game)
      next_day(game)
      game.player.speed = game.player.speed - 0.05 * PLAYER_BASE_SPEED
      game.last_message = "Ты не выспался, твоя скорость снижена." ..
        game.last_message
    end
  }
}
