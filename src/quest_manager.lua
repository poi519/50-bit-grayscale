local quest_manager = {}

function quest_manager.reset()
  quest_manager.money = 0
  quest_manager.starvation = 0
  quest_manager.minutes = 0
  quest_manager.day = 1
end

quest_manager.reset()

local quest_index = 1

local quests = require "src/quests"

quest_manager.quest = quests[quest_index]

function quest_manager.next_quest(game)
  quest_index = quest_index + 1
  if quest_index > #quests then quest_index = 1 end
  quest_manager.quest = quests[quest_index]
  quest_manager.setup_quest(game)
end

function quest_manager.setup_quest(game)
  quest_manager.minutes = 0
  game.map.spawn(game.player, quest_manager.quest.start)
  game.pedestrian_manager.init(game.map)
  game.gopnik_manager.init(game.map)
end
 
local TIME_SCALE = 45

function quest_manager.update(dt, game)
  quest_manager.minutes = quest_manager.minutes +  dt * TIME_SCALE / 60
  quest_manager.check_state(game)
end

function quest_manager.check_state(game)
  if quest_manager.minutes > 60 then
    quest_manager.quest.fail(game)
    quest_manager.next_quest(game)
  else
    local p, m = game.player, game.map
    local i, j = math.floor(p.x + 0.5), math.floor(p.y + 0.5)
    if game.map.adjacent[quest_manager.quest.destination][i + m.width * (j - 1)] then
      quest_manager.quest.success(game)
      quest_manager.next_quest(game)
    end
  end
end

return quest_manager
