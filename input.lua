-- imports
local love = love
local func = require "wuv.func"
local print = print
setfenv(1,{})
-- /imports

-- members
local buttonState = {
  UP = 1,
  PRESSED = 2,
  HELD = 3,
  RELEASED = 4
}

local pointer = {
  x = 0,
  y = 0,
  xDelta = 0,
  yDelta = 0,
  primaryButton = buttonState.UP,
  secondaryButton = buttonState.UP
}

local joystick = {
  name = nil,
  
  buttonCount = 0,
  buttonStates = {},
  
  axisCount = 0,
  axes = {}
}

local activeJoystick = nil -- only supports one active controller
local searchingForJoystick = false

-- functions
local function getButtonState(buttonDownFunc, buttonNum, prevButtonState)
  if buttonDownFunc(buttonNum) then
    if prevButtonState == buttonState.PRESSED or prevButtonState == buttonState.HELD then
      return buttonState.HELD
    else
      return buttonState.PRESSED
    end
  else
    if prevButtonState == buttonState.RELEASED or prevButtonState == buttonState.UP then
      return buttonState.UP
    else
      return buttonState.RELEASED
    end
  end
end

local function getMouseButtonState(buttonNum, prevButtonState)
  return getButtonState(love.mouse.isDown, buttonNum, prevButtonState)
end

local function getJoystickButtonState(buttonNum, prevButtonState)
  return getButtonState(func.bind(activeJoystick, "isDown"), buttonNum, prevButtonState)
end

local function updatePointer()
  local prevX = pointer.x
  local prevY = pointer.y
  
  pointer.x, pointer.y = love.mouse.getPosition() -- TODO is touch control handled here?
  pointer.xDelta = pointer.x - prevX
  pointer.yDelta = pointer.y - prevY
  
  pointer.primaryButton = getMouseButtonState(1, pointer.primaryButton)
  pointer.secondaryButton = getMouseButtonState(2, pointer.secondaryButton)
end

local function disconnectJoystick()
  activeJoystick = nil
  joystick.name = nil
  joystick.buttonCount = 0
  joystick.buttonStates = {}
  joystick.axisCount = 0
  joystick.axes = {}
end

local function searchForJoystick()
  disconnectJoystick()
  searchingForJoystick = true
end

local function getJoystickConnected()
  return activeJoystick ~= nil
end

local function findJoystick()
  local joysticks = love.joystick.getJoysticks()
  anyJoysticks = #joysticks > 0
  for i = 1, #joysticks do
    local count = joysticks[i]:getButtonCount()
    for j = 1, count do
      if joysticks[i]:isDown(j) then
        activeJoystick = joysticks[i]
        joystick.name = activeJoystick:getName()
        joystick.buttonCount = activeJoystick:getButtonCount()
        for i = 1, joystick.buttonCount do
          joystick.buttonStates[i] = buttonState.UP
        end
        joystick.axisCount = activeJoystick:getAxisCount()
        searchingForJoystick = false
        return
      end
    end
  end
end

local function updateJoystick()
  if searchingForJoystick then
    findJoystick()
  end
  if not activeJoystick then
    return
  end
  for i = 1, joystick.buttonCount do
    joystick.buttonStates[i] = getJoystickButtonState(i, joystick.buttonStates[i])
  end
  for i = 1, joystick.axisCount do
    joystick.axes[i] = activeJoystick:getAxis(i)
  end
end

local function update()
  updatePointer()
  updateJoystick()
end


-- Package
input = {
  buttonState = buttonState,
  pointer = pointer,
  joystick = joystick,
  searchForJoystick = searchForJoystick,
  getJoystickConnected = getJoystickConnected,
  disconnectJoystick = disconnectJoystick,
  update = update
}
return input