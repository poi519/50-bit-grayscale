local map = {}

local dict = {
  [' '] = "Pedestrian area",
  ['x'] = "Building",
  ['.'] = "Traffic area",
  ['h'] = "Home",
  ['w'] = "Work",
  ['s'] = "Shop"
}

local function adjacent_blocks(b)
  local i, j = b[1], b[2]
  return {
    {i - 1, j - 1},
    {i - 1, j},
    {i - 1, j + 1},
    {i, j - 1},
    {i, j + 1},
    {i + 1, j - 1},
    {i + 1, j},
    {i + 1, j + 1}
  }
end

function map.load(filename)
  map.array = {}
  map.width = 0
  map.height = 0
  map.adjacent = {}
  map.centers = {}
  
  local quest_buildings = {
    ["Home"] = {},
    ["Work"] = {},
    ["Shop"] = {}
  }

  for line in love.filesystem.lines(filename) do
    map.height = map.height + 1
    if map.width == 0 then
      map.width = line:len()
    end
    for i = 1, map.width do
      local c = line:sub(i, i)
      local b = dict[c] or "Pedestrian area"
      table.insert(map.array, b)
      if quest_buildings[b] then
        table.insert(quest_buildings[b], {i, map.height})
      end
    end
  end
  
  for building, blocks in pairs(quest_buildings) do
    map.adjacent[building] = {}
    map.centers[building] = {0, 0}
    
    for _, b in ipairs(blocks) do
      map.centers[building][1] = map.centers[building][1] + b[1]
      map.centers[building][2] = map.centers[building][2] + b[2]
      
      for _, a in ipairs(adjacent_blocks(b)) do
        local index = a[1] + map.width * (a[2] -1)
        if map.is_passable(a[1], a[2]) then 
          map.adjacent[building][index] = a
        end
      end
    end
    
    map.centers[building][1] = map.centers[building][1] / #blocks
    map.centers[building][2] = map.centers[building][2] / #blocks
  end
end

function map.get(i, j)
  if 0 < i and i <= map.width and 0 < j and j <= map.height  then
    return map.array[(j-1) * map.width + i]
  else 
    return "Pedestrian area"
  end
end

function map.is_passable(i, j)
  local b = map.get(i, j)
  return b ~= "Building" and b ~= "Shop" and b ~= "Work" and b ~= "Home"
end

function map.spawn(moveable, building)
  local adj = map.adjacent[building]
  local n = math.random(#adj)
  local i = 0
  for k, v in pairs(adj) do
    i = i + 1
    if i == n then
      moveable.x, moveable.y = v[1], v[2]
      return
    end
  end
end

map.load("resources/map.txt")

return map
