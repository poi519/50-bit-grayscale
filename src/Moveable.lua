local Moveable = {}

local meta = {__index = Moveable}

function Moveable.new()
  local m = {
    x = 0,
    y = 0,
    speed = 2,
    direction = {0, 0}
  }
  setmetatable(m, meta)
  return m
end

local EPS = 0.05

function Moveable:move(dt, map)
  local x = self.x + self.speed * self.direction[1] * dt
  local y = self.y + self.speed * self.direction[2] * dt

  if map.is_passable(math.floor(x + EPS), math.floor(y + EPS)) and
  map.is_passable(math.floor(x + EPS), math.ceil(y - EPS)) and
  map.is_passable(math.ceil(x - EPS), math.floor(y + EPS)) and
  map.is_passable(math.ceil(x - EPS), math.ceil(y - EPS)) then
    self.x, self.y = x, y
    return true
  else 
    return false
  end
end

function Moveable:set_direction(dx, dy)
    self.direction[1] = dx
    self.direction[2] = dy
end

Moveable.DIRECTIONS = {
  {1, 0},
  {0, 1},
  {0, 0},
  {0, -1},
  {-1, 0}
}

local DIRECTIONS = Moveable.DIRECTIONS

function Moveable.random_place(map, inverse_probability)
  local array = {}
  for j = 1, map.height do
    for i = 1, map.width do
      if map.get(i, j) == "Pedestrian area" and
      math.random(inverse_probability) == 1 then
        local p = Moveable.new()
        p.x, p.y = i, j
        local d = DIRECTIONS[math.random(#DIRECTIONS)]
        p:set_direction(d[1], d[2])
        table.insert(array, p)
      end
    end 
  end
  return array
end

return Moveable
