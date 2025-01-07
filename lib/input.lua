-- imports
local love = love
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

local activeJoystick = nil -- only supports one active controller
local searchingForJoystick = false

-- functions
local function updateButtonState(buttonNum, prevButtonState)
  if love.mouse.isDown(buttonNum) then
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

local function updatePointer()
  local prevX = pointer.x
  local prevY = pointer.y
  
  pointer.x, pointer.y = love.mouse.getPosition()
  pointer.xDelta = pointer.x - prevX
  pointer.yDelta = pointer.y - prevY
  
  pointer.primaryButton = updateButtonState(1, pointer.primaryButton)
  pointer.secondaryButton = updateButtonState(2, pointer.secondaryButton)
end

local function setSearchingForJoystick(enabled)
  activeJoystick = nil
  searchingForJoystick = enabled
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
        print("we got em")
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
  print("updating joystick " .. activeJoystick:getID())
end

local function update()
  updatePointer()
  updateJoystick()
end


-- Package
input = {
  buttonState = buttonState,
  pointer = pointer,
  setSearchingForJoystick = setSearchingForJoystick,
  getJoystickConnected = getJoystickConnected,
  update = update
}
return input