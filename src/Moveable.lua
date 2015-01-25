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

return Moveable
