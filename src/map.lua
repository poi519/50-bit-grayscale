local map = {}

map.array = {}
map.width = 0
map.height = 0

local dict = {
  [' '] = "Pedestrian area",
  ['x'] = "Building",
  ['.'] = "Traffic area",
  ['h'] = "Home",
  ['w'] = "Work",
  ['s'] = "Shop"
}

function map.load(filename)
  map.array = {}
  map.width = 0
  map.height = 0
  
  for line in love.filesystem.lines(filename) do
    map.height = map.height + 1
    if map.width == 0 then
      map.width = line:len()
    end
    for i = 1, map.width do
      local c = line:sub(i, i)
      table.insert(map.array, dict[c] or "Pedestrian area")
    end
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

map.load("resources/map.txt")

return map
