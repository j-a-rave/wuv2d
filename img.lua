-- imports
local love = love
setfenv(1,{})
-- /imports

local loadedImages = {}

local function get(img)
  local loaded = loadedImages[img]
  if loaded == nil then
    loaded = love.graphics.newImage(img)
    loadedImages[img] = loaded
  end
  return loaded
end

-- package
img = {
  get = get
}
return img