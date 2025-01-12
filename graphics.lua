-- imports
local love = love
local shapes = require "wuv.shapes"
local img = require "wuv.img"
local abs = math.abs
setfenv(1,{})
-- /imports


-- Sprite
local Sprite = shapes.Rect:extend()

function Sprite:new(image, x, y, sx, sy)
  self.image = img.get(image)
  self.x = x
  self.y = y
  self.r = 0
  self.sx = sx or 1
  self.sy = sy or 1
  self.ox = 0
  self.oy = 0
  self.kx = 0
  self.ky = 0
  self.w = self.image:getWidth() * self.sx
  self.h = self.image:getHeight() * self.sy
end

function Sprite:draw()
  love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
  love.graphics.draw(self.image, self.x, self.y, self.r, self.sx, self.sy, self.ox, self.oy, self.kx, self.ky)
end

function Sprite:setPos(x, y)
  self.x = x
  self.y = y
end

function Sprite:move(x, y)
  self:setPos(self.x + x, self.y + y)
end


-- Package
graphics = {
  Sprite = Sprite
}
return graphics