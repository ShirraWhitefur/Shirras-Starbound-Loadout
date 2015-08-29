function init(virtual)
  script.setUpdateDelta(3)
  if virtual then return end

  self.signalwaiting = false
  self.signalstrength = 0
  self.signaldirection = ""
  self.padcentrepoint = entity.configParameter("padcentrepoint")
  self.ringcentrepoint = entity.configParameter("ringcentrepoint")
  self.fieldsize = entity.configParameter("fieldsize")
  self.forcestrength = entity.configParameter("forcestrength")
  self.devicesize = entity.configParameter("devicesize")
  self.devicetier = entity.configParameter("devicetier") 
  self.gravFieldUp = -1
  self.gravFieldDown = -1
  
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
  pos = entity.position(); pos[1] = pos[1]+self.ringcentrepoint
  if self.signalwaiting == true then readySignal(self.signaldirection) end
  -- check area for players and preload world chunks above/below hopefully for ease of travel
  local playerIds = world.playerQuery({pos[1]-self.fieldsize,pos[2]-self.gravFieldDown},{pos[1]+self.fieldsize,pos[2]+0.5+self.gravFieldUp})
  --determine field distance upwards
  if self.gravFieldUp < 0 then
    checkAbove = world.loadRegion({pos[1]-(self.fieldsize*2),pos[2],pos[1]+(self.fieldsize*2),pos[2]+20})
    if checkAbove == true then
      findClosestAbove()
      if #checkRings > 0 then
        self.gravFieldUp = (ringDistance-3)*0.5
      elseif #checkPads > 0 then
        self.gravFieldUp = padDistance*0.5
      end
      if #checkPads == 0 and #checkRings == 0 then
        self.gravFieldUp = 1
      end
    end
  end
    -- determine field distance downwards
  if self.gravFieldDown < 0 then
    checkBelow = world.loadRegion({pos[1]-(self.fieldsize*2),pos[2]-20,pos[1]+(self.fieldsize*2),pos[2]})
    if checkBelow == true then
      findClosestBelow() 
      self.gravFieldDown = 0
      if #checkRings > 0 then
        self.gravFieldDown = (ringDistance-3)*0.5
      elseif #checkPads > 0 then
        self.gravFieldDown = (padDistance-3)*0.5
      end
      if #checkPads == 0 and #checkRings == 0 then
        self.gravFieldDown = 6
      end
    end
  end
  if self.gravFieldUp < 0 or self.gravFieldDown < 0 then return end
  -- check area for players and preload world chunks above/below hopefully for ease of travel
  local playerList = world.playerQuery({pos[1]-self.fieldsize,pos[2]+0.5},{pos[1]+self.fieldsize,pos[2]+0.5+self.gravFieldUp})
  if #playerList > 0 then
    world.debugLine({pos[1]-self.fieldsize, pos[2]+0.5-self.gravFieldDown}, {pos[1]+self.fieldsize, pos[2]+0.5-self.gravFieldDown}, "green")
    world.debugLine({pos[1]+self.fieldsize, pos[2]+0.5-self.gravFieldDown}, {pos[1]+self.fieldsize, pos[2]+0.5+self.gravFieldUp}, "green")
    world.debugLine({pos[1]+self.fieldsize, pos[2]+0.5+self.gravFieldUp}, {pos[1]-self.fieldsize, pos[2]+0.5+self.gravFieldUp}, "green")
    world.debugLine({pos[1]-self.fieldsize, pos[2]+0.5+self.gravFieldUp}, {pos[1]-self.fieldsize, pos[2]+0.5-self.gravFieldDown}, "green")
    local loadRegion = world.loadRegion({pos[1]-(self.fieldsize*2),pos[2]-51,pos[1]+(self.fieldsize*2),pos[2]+51})
    for key, value in pairs(playerList) do
      local position = world.entityPosition(value)
      local velocity = world.entityVelocity(value)   
		  world.spawnProjectile("gravitonbuff",{position[1]+(velocity[1]*0.04),position[2]+(velocity[2]*0.04)})
    end
    else      
    world.debugLine({pos[1]-self.fieldsize, pos[2]+0.5-self.gravFieldDown}, {pos[1]+self.fieldsize, pos[2]+0.5+self.gravFieldUp}, "red")
    world.debugLine({pos[1]+self.fieldsize, pos[2]+0.5-self.gravFieldDown}, {pos[1]-self.fieldsize, pos[2]+0.5+self.gravFieldUp}, "red")
  end
  -- define graviton field region
  local region = {
    pos[1]-self.fieldsize, pos[2]+0.5-self.gravFieldDown,
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

function cycleSetting(state)
  self.gravFieldUp = -1; self.gravFieldDown = -1
  if entity.animationState("projectorState") == "off" then
    entity.playSound("on")
    output(true)
  elseif entity.animationState("projectorState") == "on" then
    entity.playSound("off")
    output(false)
  end
  self.signalwaiting = true
  self.signalstrength = 1
  self.signaldirection = "both"
end

function synchronizeDevice(state)
  --world.logInfo("stateing setting change to: " .. state)
  if state == "off" then
    entity.playSound("off")
    output(false)
  else
    entity.playSound("on")
    output(true)
  end
  self.signalwaiting = true
end

function readySignal(direction)
  pos = entity.position(); pos[1] = pos[1]+self.ringcentrepoint
  -- check the possible receiving world chunk area is loaded
  self.signalwaiting = false
  local checkUp = true
  local checkDown = true
  if direction == "up" or direction == "both" then
    checkUp = world.loadRegion({pos[1]-(self.fieldsize*2),pos[2],pos[1]+(self.fieldsize*2),pos[2]+18})
  end
  if direction == "down" or direction == "both" then
    checkDown = world.loadRegion({pos[1]-(self.fieldsize*2),pos[2]-18,pos[1]+(self.fieldsize*2),pos[2]})
  end
  if checkUp == false or checkDown == false then
    --world.logInfo(" - delaying signal...")
    self.signalwaiting = true
  else
    sendSignal(self.signalstrength, direction, entity.animationState("projectorState"))
  end  
end

function sendSignal(strength, direction, state)
  local pos = entity.position(); pos[1] = pos[1]+self.ringcentrepoint -- rings 0,0 is on far left not centre so adjust
  -------------------------------------------------------------------------------------------------
  -- check for rings/pads in signal direction------------------------------------------------------
  -------------------------------------------------------------------------------------------------
  if direction == "up" or direction == "both" then
    findClosestAbove()
    if #checkRings > 0 then
      -- send signal to closest ring
      --world.logInfo(" - a ring detected, it's my pal #" .. checkRings[1] .. " who is " .. ringDistance .. " above me - sending him signal!" )
      world.callScriptedEntity(checkRings[1], "receivedSignal", strength, "up", state)  
    --else
      --world.logInfo(" - no other ring detected above")   
    end    
  end 
  if direction == "down" or direction == "both" then
    findClosestBelow() 
    if #checkRings > 0 then
      -- send signal to closet ring
      ringDistance = pos[2]-ringPos[2]
      --world.logInfo(" - a ring detected, it's my pal #" .. checkRings[1] .. " who is " .. ringDistance .. " below me - sending him signal!" )
      world.callScriptedEntity(checkRings[1], "receivedSignal", strength, "down", state)
    elseif #checkPads > 0 then
      -- send signal to closet pad
      padDistance = pos[2]-padPos[2]
      --world.logInfo(" - a pad detected, it's my pal #" .. checkPads[1] .. " who is " .. padDistance .. " below me - sending him signal!" )
      world.callScriptedEntity(checkPads[1], "receivedSignal", strength, "down", state)
    end
    --if #checkPads == 0 and #checkRings == 0 then
       --world.logInfo(" - no other ring or pad detected below")
    --end   
  end
  -- a signal will have been sent now if a valid receiver detected - power down transmitter!
  self.signalstrength = 0
  self.signaldirection = ""
end

function findClosestAbove()
  pos = entity.position(); pos[1] = pos[1]+self.ringcentrepoint
  local padName = self.devicetier .. "_" .. self.devicesize .. "_gravitonprojectorpad"
  local ringName = self.devicetier .. "_" .. self.devicesize .. "_gravitonprojectorring"
  -------------------------------------------------------------------------------------------------
  -- look for rings/pads above --------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------
  --world.logInfo(" - scanning for rings/pads above me")    
  local checkAreaMin = {pos[1]-self.fieldsize*2,pos[2]+1}
  local checkAreaMax = {pos[1]+self.fieldsize*2,pos[2]+18}
  checkRings = world.objectQuery(checkAreaMin,checkAreaMax,{name=ringName, withoutEntityId=entity.id()})
  if #checkRings > 0 then
    ringPos = world.entityPosition(checkRings[1])
    ringDistance = ringPos[2]-pos[2]
    -- if multiple rings determine closest ring
    if #checkRings > 1 then
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
  checkPads = world.objectQuery(checkAreaMin,checkAreaMax,{name=padName})
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

function findClosestBelow()
  local padName = self.devicetier .. "_" .. self.devicesize .. "_gravitonprojectorpad"
  local ringName = self.devicetier .. "_" .. self.devicesize .. "_gravitonprojectorring"
  -------------------------------------------------------------------------------------------------
  -- look for rings below -------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------
  --world.logInfo(" - scanning for another ring or pad below me.")
  local checkAreaMin = {pos[1]-self.fieldsize*2,pos[2]-18}
  local checkAreaMax = {pos[1]+self.fieldsize*2,pos[2]-1}
  checkRings = world.objectQuery(checkAreaMin, checkAreaMax,{name=ringName, withoutEntityId=entity.id()})
  -- if multiple rings, determine closest ring
  if #checkRings > 0 then
    ringPos = world.entityPosition(checkRings[1])
    ringDistance = pos[2]-ringPos[2]
    if #checkRings > 1 then
      for i= 2,#checkRings do
        ringPos = world.entityPosition(checkRings[i]) 
        iDistance = pos[2]-ringPos[2]
        if iDistance < ringDistance then
          world.logInfo(" - ring #" .. checkRings[i] .. " @ " .. iDistance .. " is closer than ring #" .. checkRings[1] .. " @ " .. ringDistance)
          checkRings[1] = checkRings[i]
          ringDistance = iDistance
        end
        --detected = detected .. " ... #" .. checkRings[i] .. " at distance " .. distance
      end
    end
  end
  -------------------------------------------------------------------------------------------------
  -- look for pads below --------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------
  checkPads = world.objectQuery(checkAreaMin, checkAreaMax,{name=padName})
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
        --detected = detected .. " ... #" .. checkPads[i] .. " at distance " .. distance
      end
    end
  end
  -- if both a ring and pad then determine closest ------------------------------------------------
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
  -- return search results ------------------------------------------------------------------------
  return checkRings, ringDistance, checkPads, padDistance
end

function receivedSignal(strength,direction,state)
  self.gravFieldDown = -1; self.gravFieldUp = -1
  --world.logInfo("Ring #" .. entity.id() .. " here - I picked up an incoming signal!")
  if self.signalwaiting == true and strength < self.signalstrength then
    -- incoming signal weaker than one waiting to be sent
    -- so keep current setting instead
    return
  end
  -- incoming signal received, boost signal and ready it for sending
  self.signalstrength = strength + 1
  self.signalwaiting = true
  self.signaldirection = direction
  -- synchronize setting
  synchronizeDevice(state)
end