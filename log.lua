-- imports
local table = require "wuv.table"
local print = print
local io = io
local os = os
setfenv(1,{})
-- /imports

-- severity levels
local LEVEL = "level"
local LEVEL_DEBUG = "DEBUG"
local LEVEL_INFO = "INFO"
local LEVEL_WARNING = "WARNING"
local LEVEL_ERROR = "ERROR"
local LEVEL_FATAL = "FATAL"
local levels = {LEVEL_DEBUG, LEVEL_INFO, LEVEL_WARNING, LEVEL_ERROR, LEVEL_FATAL}

-- detail levels
local DETAIL = "detail"
local DETAIL_DEFAULT = "DEFAULT"
local DETAIL_VERBOSE = "VERBOSE"
local details = {DETAIL_DEFAULT, DETAIL_VERBOSE}

-- local only variables
local LOG_LOG = "wuv.log"
local logDetail = DETAIL_DEFAULT

-- list of stored categories
local categories = {}

local function register(category, level, detail)
  if table.get(categories, category, nil) then
    return category
  end
  local l = level or LEVEL_INFO
  local d = detail or DETAIL_DEFAULT
  if not table.find(levels, l) then
    return nil
  end
  if not table.find(details, d) then
    return nil
  end
  categories[category] = { [LEVEL] = l, [DETAIL] = d }
  return category
end

local function write(category, message, level, detail)
  local l = level or LEVEL_INFO
  local d = detail or DETAIL_DEFAULT

  if not table.get(categories, category, nil) then
    register(category, level, detail)
    write(LOG_LOG, "Registering category: " .. category .. ", " .. l .. ", " .. d)
  end
    -- do not log detail levels higher than the current setting
  if table.find(details, d) > table.find(details, logDetail) then
    return
  end
  
  -- TODO replace with io
  -- TODO get more precise timestamps
  print(category .. " " .. l .. ": " .. message .. ", " .. os.time(os.date("!*t")))
end

local function setDetail(detail)
  if not table.find(details, detail) then
    write(LOG_LOG, "Detail level doesn't exist: " .. detail .. " - Use provided values")
    return
  end
  logDetail = detail
  write(LOG_LOG, "Detail level set to " .. logDetail)
end

register(LOG_LOG)
setDetail(DETAIL_DEFAULT)

-- package
log = {
  LEVEL = LEVEL,
  LEVEL_DEBUG = LEVEL_DEBUG,
  LEVEL_INFO = LEVEL_INFO,
  LEVEL_WARNING = LEVEL_WARNING,
  LEVEL_ERROR = LEVEL_ERROR,
  LEVEL_FATAL = LEVEL_FATAL,
  
  DETAIL = DETAIL,
  DETAIL_DEFAULT = DETAIL_DEFAULT,
  DETAIL_VERBOSE = DETAIL_VERBOSE,
  
  register = register,
  write = write,
  setDetail = setDetail
}
return log