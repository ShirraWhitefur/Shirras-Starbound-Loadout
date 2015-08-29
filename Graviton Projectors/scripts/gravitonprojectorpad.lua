function init(virtual)
  script.setUpdateDelta(3)
  if virtual then return end

  self.signalwaiting = false
  self.signalstrength = 0
  self.signalstate = ""
  self.padcentrepoint = entity.configParameter("padcentrepoint")
  self.ringcentrepoint = entity.configParameter("ringcentrepoint")
  self.fieldsize = entity.configParameter("fieldsize")
  self.forcestrength = entity.configParameter("forcestrength")
  self.devicesize = entity.configParameter("devicesize")
  self.devicetier = entity.configParameter("devicetier")
  
  self.gravFieldUp = -1

  -- low > off (temp fix) --------------------------------
  if entity.animationState("projectorState") == "low" then
    entity.setAnimationState("projectorState", "off")
  end
  --------------------------------------------------------
  if storage.state == nil then
    output(false)
  else
    entity.setAllOutboundNodes(storage.state)
    if storage.state then
      entity.setAnimationState("projectorState", "on")
    else
      entity.setAnimationState("projectorState", "off")
    end
  end
  entity.setInteractive(not entity.isInboundNodeConnected(0))
end
    
function update(dt)
  pos = entity.position(); pos[1] = pos[1]+self.padcentrepoint
  if self.signalwaiting == true then readySignal() end
  -- determine field distance upwards
  if self.gravFieldUp < 0 then
    checkUp = world.loadRegion({pos[1]-(self.fieldsize*2),pos[2]-2,pos[1]+(self.fieldsize*2),pos[2]+18})
    if checkUp == true then
      findClosestAbove()    
      if #checkRings > 0 then
        self.gravFieldUp = (ringDistance-3)*0.5
      elseif #checkPads > 0 then
        self.gravFieldUp = padDistance*0.5
      end
      if #checkPads == 0 and #checkRings == 0 then
        self.gravFieldUp = 6
      end
    else
      return
    end
  end
  -- check area for players and preload world chunks above/below hopefully for ease of travel
  local playerList = world.playerQuery({pos[1]-self.fieldsize,pos[2]+0.5},{pos[1]+self.fieldsize,pos[2]+0.5+self.gravFieldUp})
  if #playerList > 0 then
    world.debugLine({pos[1]-self.fieldsize, pos[2]+0.5}, {pos[1]+self.fieldsize, pos[2]+0.5}, "green")
    world.debugLine({pos[1]+self.fieldsize, pos[2]+0.5}, {pos[1]+self.fieldsize, pos[2]+0.5+self.gravFieldUp}, "green")
    world.debugLine({pos[1]+self.fieldsize, pos[2]+0.5+self.gravFieldUp}, {pos[1]-self.fieldsize, pos[2]+0.5+self.gravFieldUp}, "green")
    world.debugLine({pos[1]-self.fieldsize, pos[2]+0.5+self.gravFieldUp}, {pos[1]-self.fieldsize, pos[2]+0.5}, "green")
    local loadRegion = world.loadRegion({pos[1]-(self.fieldsize*2),pos[2],pos[1]+(self.fieldsize*2),pos[2]+51})
    for key, value in pairs(playerList) do
      local position = world.entityPosition(value)
      local velocity = world.entityVelocity(value)
      --world.logInfo("velocity: " .. velocity[1] .. ", " .. velocity[2])
		  world.spawnProjectile("gravitonbuff",{position[1]+(velocity[1]*0.04),position[2]+(velocity[2]*0.04)})
    end
  else      
    world.debugLine({pos[1]-self.fieldsize, pos[2]+0.5}, {pos[1]+self.fieldsize, pos[2]+0.5+self.gravFieldUp}, "red")
    world.debugLine({pos[1]+self.fieldsize, pos[2]+0.5}, {pos[1]-self.fieldsize, pos[2]+0.5+self.gravFieldUp}, "red")
  end
  -- define graviton field region
  local region = {
    pos[1]-self.fieldsize, pos[2]+0.5,
    pos[1]+self.fieldsize, pos[2]+0.5+self.gravFieldUp
  }
  -- set graviton force power
  if entity.animationState("projectorState") == "off" then
    entity.setForceRegion(region, {0, world.gravity(pos)})
  else
    entity.setForceRegion(region, {0, world.gravity(pos)+(self.forcestrength*25)})
  end
end

function onNodeConnectionChange(args)
  entity.setInteractive(not entity.isInboundNodeConnected(0))
end

function onInboundNodeChange(args)
  cycleSetting()
end

function output(state)
  if storage.state ~= state then
    storage.state = state
    entity.setAllOutboundNodes(state)
    if state then
      entity.setAnimationState("projectorState", "on")
    else
      entity.setAnimationState("projectorState", "off")
    end
  end
end

function onInteraction(args)
  if (entity.isInboundNodeConnected(0)) then
    return
  end
  cycleSetting()
end

function cycleSetting()
  self.gravFieldUp = -1
  if entity.animationState("projectorState") == "off" then
    entity.setAnimationState("projectorState", "on")
    entity.playSound("on")
    self.signalstate = "on"
    output(true)
  elseif entity.animationState("projectorState") == "on" then
    entity.setAnimationState("projectorState", "off")
    entity.playSound("off")
    self.signalstate = "off"
    output(false)
  end
  self.signalwaiting = true
  self.signalstrength = 1
end

function synchronizeDevice(state)
  self.gravFieldUp = -1
  --world.logInfo(" - scanning for a ring above me.")
  entity.setAnimationState("projectorState", state)
  if state == "off" then
    output(false)
  else
    entity.playSound("on")
    output(true)
  end
end

function readySignal()
  pos = entity.position(); pos[1] = pos[1]+self.padcentrepoint
  -- check the possible receiving world chunk area is loaded
  self.signalwaiting = false
  local checkUp = world.loadRegion({pos[1]-(self.fieldsize*2),pos[2]-2,pos[1]+(self.fieldsize*2),pos[2]+20})
  if checkUp == false then
    self.signalwaiting = true
  else
    sendSignal(1, "up", entity.animationState("projectorState"))
  end  
end

function sendSignal(strength,direction,state)
  -- pads can only send signals "up" so direction is not used
  --world.logInfo(" - scanning for a ring above me.")
  -- look for rings above
  findClosestAbove()
  if #checkRings > 0 then
    -- send signal to closest ring
    --world.logInfo(" - a ring detected, it's my pal #" .. checkRings[1] .. " - sending him signal!" )
    world.callScriptedEntity(checkRings[1], "receivedSignal", strength, "up", state)
    --else
    --world.logInfo(" - no ring detected above ... *sniff* I'm lonely.") 
  end 
  -- signal sent (if valid receiver detected) - power down transmitter
  self.signalstrength = 0
end

function findClosestAbove()
  pos = entity.position(); pos[1] = pos[1]+self.padcentrepoint
  local padName = self.devicetier .. "_" .. self.devicesize .. "_gravitonprojectorpad"
  local ringName = self.devicetier .. "_" .. self.devicesize .. "_gravitonprojectorring"
  -------------------------------------------------------------------------------------------------
  -- look for rings above -------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------
  --world.logInfo(" - scanning for rings/pads above me")
  local checkAreaMin = {pos[1]-self.fieldsize,pos[2]+1}
  local checkAreaMax = {pos[1]+self.fieldsize,pos[2]+18}
  checkRings = world.objectQuery(checkAreaMin,checkAreaMax,{name=ringName})
  if #checkRings > 0 then
    ringPos = world.entityPosition(checkRings[1])
    ringDistance = ringPos[2]-pos[2]
    -- if multiple rings determine closest ring
    if #checkRings >1 then
      for i= 2,#checkRings do
        ringPos = world.entityPosition(checkRings[i])
        iDistance = ringPos[2]-pos[2]
        if iDistance < ringDistance then
          --world.logInfo(" - ring #" .. checkRings[i] .. " is closer than ring# " .. checkRings[1])
          checkRings[1] = checkRings[i]
          ringDistance = iDistance
        end
      end
    end
  end
  -------------------------------------------------------------------------------------------------
  -- look for pads above --------------------------------------------------------------------------
  -- (if one found closer than nearest ring then ring must be in another graviton elevator shaft) -
  -------------------------------------------------------------------------------------------------
  checkPads = world.objectQuery(checkAreaMin,checkAreaMax,{name=padName, withoutEntityId=entity.id()})
  -- if multiple pads, determine closest pad
  if #checkPads > 0 then
    padPos = world.entityPosition(checkPads[1])
    padDistance = pos[2]-padPos[2]
    if #checkPads >1 then
      for i= 2,#checkPads do
        padDistance = pos[2]-padPos[2]
        iDistance = pos[2]-padPos[2]
        if iDistance < padDistance then
          --world.logInfo(" - pad #" .. checkPads[i] .. " @ " .. iDistance .. " is closer than pad #" .. checkPads[1] .. " @ " .. padDistance)
          checkPads[1] = checkPads[i]
          padDistance = iDistance
        end
      end
    end
  end
  -------------------------------------------------------------------------------------------------
  -- if both a ring and pad then determine closest ------------------------------------------------
  -------------------------------------------------------------------------------------------------
  if #checkRings > 0 and #checkPads > 0 then
    if ringDistance < padDistance then
      -- ring closer so ignore pad
      --world.logInfo(" - ring #" .. checkRings[1] .. " @ " .. ringDistance .. " is closer than pad #" .. checkPads[1].. " @ " .. padDistance)
      checkPads = {}    
    else
      -- pad closer so ignore ring
      --world.logInfo(" - pad #" .. checkPads[1] .. " @ " .. padDistance .. " is closer than pad #" .. checkRings[1] .. " @ " .. ringDistance)
      checkRings = {}
    end
  end
  -------------------------------------------------------------------------------------------------
  -- return search results ------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------
  return checkRings, ringDistance, checkPads, padDistance
end

function receivedSignal(strength,direction,state)
  --world.logInfo("Pad #" .. entity.id() .. " here - I picked up an incoming signal!")
  -- incoming signal received, pad is at bottom so no need to send signal further downward
  self.gravFieldUp = -1
  self.signalstrength = 0
  self.signalwaiting = false
  -- synchronize setting
  synchronizeDevice(state)
end