-- imports
setfenv(1, {})
-- /imports

local function bind(obj, funct) -- more readable way to pass an object functor
  return function(...) return obj[funct](obj, ...) end
end

-- package
helper = {
  bind = bind
}
return helper