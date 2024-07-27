-- you can add radar or other settings here
local settings = {'players', 'buildings'} -- , 'radar'}

-- check for list of keys here https://lmaobox.net/lua/Lua_Constants/
local toggleKey = KEY_LSHIFT

local last = 0
local active = false

local function draw()
  if input.IsButtonPressed(toggleKey) then
    local now = globals.RealTime()
    if now - last > 0.2 then
      last = now
      active = not active
      for i, s in ipairs(settings) do
        gui.SetValue(s, active and 1 or 0)
      end
    end
  end
end

callbacks.Register('Draw', 'ok_draw', draw)