-- improving the built-in pseudorandom generator (modified from lua-users.org/wiki/MathLibraryTutorial)

-- imports
local stdRandom = math.random
local seed = math.randomseed
local floor = math.floor
local time = os.time
setfenv(1,{})
-- /imports

seed(time())

local randomTable = {}
for i = 1, 97 do
  randomTable[i] = stdRandom()
end

local function rand()
    local x = stdRandom()
    local i = 1 + floor(97*x)
    x, randomTable[i] = randomTable[i], x
    return x
end

local function rangeFloat(min, max)
  if min >= max then
    return min
  end
  
  return rand() * (max - min) + min
end

local function rangeInt(min, max)
  return floor(rangeFloat(min, max))
end

random = {
  rand = rand,
  rangeFloat = rangeFloat,
  rangeInt = rangeInt
}
return random