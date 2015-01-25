local map = {}

map.array = {}

map.width = 4
map.height = 4

for i = 1, 4 do
  for j = 1, 4 do
    if i == j then
      table.insert(map.array, "Pedestrian area")
    else
      table.insert(map.array, "Building")
    end
  end
end

function map.get(i, j)
  if 0 < i and i <= map.width and 0 < j and j <= map.height  then
    return map.array[(j-1) * 4 + i]
  else 
    return "Pedestrian area"
  end
end

return map
