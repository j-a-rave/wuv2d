-- imports
local table = table
local pairs = pairs
setfenv(1, {})
-- /imports

local function find(t, el)
  if t == nil then
    return nil
  end
  for k, v in pairs(t) do
    if v == el then
      return k
    end
  end
  return nil
end

local function get(t, key, default)
  if t == nil then
    return nil
  end
  for k, v in pairs(t) do
    if k == key then
      return v
    end
  end
  return default
end
  

table.find = find
table.get = get

return table