-- Change this if you use inverted mouse
local mouse1 = MOUSE_LEFT

-- Shoot delay amount in millisecond
local delayMs = 80

-- Minimum & maximum time a missed shot should be held (random)
local holdMinMs = 80
local holdMaxMs = 340

-- internal variables, do not touch
local delay = delayMs / 1000
local start = 0
local hold = 0
local clicked = false
local attack = false
local releaseAttack = false
local held = false

client.Command('unbind mouse1', true)

local function draw()
  local me = entities.GetLocalPlayer()

  if me == nil or not me:IsAlive() then
    if attack or releaseAttack then
      client.Command('-attack', true)
      attack = false
      releaseAttack = false
    end
    clicked = false
    held = false
    return
  end

  local hitscan = {
    [TF_WEAPON_SCATTERGUN] = true,
    [TF_WEAPON_HANDGUN_SCOUT_PRIMARY] = true,
    [TF_WEAPON_SNIPERRIFLE] = true,
    [TF_WEAPON_SNIPERRIFLE_DECAP] = true,
    [TF_WEAPON_SHOTGUN_PRIMARY] = true,
    [TF_WEAPON_SHOTGUN_SOLDIER] = true,
    [TF_WEAPON_SHOTGUN_HWG] = true,
    [TF_WEAPON_SHOTGUN_PYRO] = true,
    [TF_WEAPON_REVOLVER] = true
  }
  
  local wep = me:GetPropEntity('m_hActiveWeapon')

  if hitscan[wep:GetWeaponID()] then
    if input.IsButtonDown(mouse1) then
      if not clicked then
        start = globals.RealTime()
        clicked = true
      elseif start + delay <= globals.RealTime() then
        client.Command('+attack', true)
        attack = true
      end
    else
      if attack then
        if hold <= globals.RealTime() then
          client.Command('-attack', true)
          attack = false
        end
      elseif clicked then
        hold = globals.RealTime() + math.random(holdMinMs, holdMaxMs) / 1000
        client.Command('+attack', true)
        attack = true
      end
      clicked = false
    end
  elseif wep:GetWeaponID() == TF_WEAPON_SNIPERRIFLE_CLASSIC then
    if input.IsButtonDown(mouse1) then
      if not held then
        client.Command('+attack', true)
        releaseAttack = true
        held = true
      end
    else
      if held then
        start = globals.RealTime()
        held = false
      elseif releaseAttack and start + delay <= globals.RealTime() then
        client.Command('-attack', true)
        releaseAttack = false
      end
    end
  else
    if input.IsButtonDown(mouse1) then
      client.Command('+attack', true)
      attack = true
    else
      client.Command('-attack', true)
      attack = false
    end
    clicked = false
  end
end

local function unload()
  client.Command('bind mouse1 +attack', true)
end

callbacks.Register('Draw', 'ds_draw', draw)
callbacks.Register('Unload', 'ds_unload', unload)