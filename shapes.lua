-- imports
local love = love
local Object = require "3rd.classic"
local sqrt = math.sqrt
local min = math.min
local max = math.max
setfenv(1,{})
-- /imports

-- Shape base class
local Shape = Object:extend()

function Shape:new(x, y, drawMode)
  self.x = x
  self.y = y
  self.drawMode = drawMode or "line"
end

function Shape:setPos(x, y)
  self.x = x
  self.y = y
end

function Shape:move(x, y)
  self:setPos(self.x + x, self.y + y)
end

function Shape:contains(x, y)
  return false
end


-- Rect
local Rect = Shape:extend()

function Rect:new(x, y, w, h, drawMode)
  Rect.super.new(self, x, y, drawMode)
  self.w = w
  self.h = h
end

function Rect:draw()
  love.graphics.rectangle(self.drawMode, self.x, self.y, self.w, self.h)
end

function Rect:contains(x, y)
  local x1, x2 = self.x, self.x + self.w
  local y1, y2 = self.y, self.y + self.h
  
  local minX = min(x1, x2)
  local maxX = max(x1, x2)
  local minY = min(y1, y2)
  local maxY = max(y1, y2)
  
  return x >= minX and x <= maxX and y >= minY and y <= maxY
end


-- Circle
local Circle = Shape:extend()

function Circle:new(x, y, r, drawMode)
  Circle.super.new(self, x, y, drawMode)
  self.r = r
end

function Circle:draw()
  love.graphics.circle(self.drawMode, self.x, self.y, self.r)
end

function Circle:contains(x, y)
  xEl = (x - self.x) * (x - self.x)
  yEl = (y - self.y) * (y - self.y)
  return xEl + yEl <= self.r * self.r
end


-- package
shapes = {
  Shape = Shape,
  Rect = Rect,
  Circle = Circle
}
return shapes