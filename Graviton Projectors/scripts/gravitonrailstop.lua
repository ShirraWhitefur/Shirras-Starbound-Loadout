function init(virtual)
  if virtual then return end
  
  self.signalwaiting = false
  self.signalstrength = 0
  self.signaldirection = ""
  self.signalrequest = ""
  self.dt = 0

  local currentState = entity.animationState("gravrailState")
  local currentLeftState = string.sub(currentState,1,string.find(currentState," ")-1)
  local currentRightState = string.sub(currentState,string.find(currentState," ")+1)
  if currentLeftState ~= "off" then
    entity.setOutboundNodeLevel(0,true)
  else
    entity.setOutboundNodeLevel(0,false)
  end
  if currentRightState ~= "off" then
    entity.setOutboundNodeLevel(1,true)
  else
    entity.setOutboundNodeLevel(1,false)
  end    
  onNodeConnectionChange()
  
end
    
function update(dt)
  local pos = entity.position(); 
  if self.signalwaiting == true then readySignal(self.signaldirection) end
  if entity.animationState("gravrailState") == "off onRight" or entity.animationState("gravrailState") == "onRight onRight" or entity.animationState("gravrailState") == "onLeft onRight" then
    local startPoint = {pos[1]+3,pos[2]+1}
    local endPoint = {pos[1]+28,pos[2]+1}
    local checkCollision = world.collisionBlocksAlongLine(startPoint,endPoint,"Static",1) 
    if #checkCollision > 0 then
      local gravrail = world.objectQuery({(checkCollision[1][1])+2,(checkCollision[1][2])-1},1,{name="gravitonrail"})
      local gravrailstop = world.objectQuery({(checkCollision[1][1])+2,(checkCollision[1][2])-1},1,{name="gravitonrailstop"})
      local pos2 = nil
      if #gravrail > 0 then pos2 = world.entityPosition(gravrail[1]) end
      if #gravrailstop > 0 then pos2 = world.entityPosition(gravrailstop[1]) end
      if not pos2 then setGravRailBeamRight(false,false,false,false,false) goto onLeftBeam end
      if pos[2] ~= pos2[2] then setGravRailBeamRight(false,false,false,false,false) goto onLeftBeam end
      setGravRailBeamRight(world.distance(pos2,pos)[1]>5,world.distance(pos2,pos)[1]>10,world.distance(pos2,pos)[1]>15,world.distance(pos2,pos)[1]>20,world.distance(pos2,pos)[1]>25)
      local region = { pos[1]-1.5, pos[2]+2.5, checkCollision[1][1]-1, pos[2]+3.25 }
      entity.setForceRegion(region, {40, world.gravity(pos)*2.5})
    else
      setGravRailBeamRight(false,false,false,false,false)
    end
  end
  ::onLeftBeam::
  if entity.animationState("gravrailState") == "onLeft off" or entity.animationState("gravrailState") == "onLeft onRight" or entity.animationState("gravrailState") == "onLeft onLeft" then
    local startPoint = {pos[1]-3,pos[2]+1}
    local endPoint = {pos[1]-28,pos[2]+1}
    local checkCollision = world.collisionBlocksAlongLine(startPoint,endPoint,"Static",1)
    if #checkCollision > 0 then
      local gravrail = world.objectQuery({checkCollision[1][1]-2,checkCollision[1][2]-1},1,{name="gravitonrail"})
      local gravrailstop = world.objectQuery({checkCollision[1][1]-2,checkCollision[1][2]-1},1,{name="gravitonrailstop"})
      local pos2 = nil
      if #gravrail > 0 then pos2 = world.entityPosition(gravrail[1]) end
      if #gravrailstop > 0 then pos2 = world.entityPosition(gravrailstop[1]) end
      if not pos2 then setGravRailBeamLeft(false,false,false,false,false) goto onLeft end
      if pos[2] ~= pos2[2] then setGravRailBeamLeft(false,false,false,false,false) goto onLeft end
      setGravRailBeamLeft(world.distance(pos,pos2)[1]>5,world.distance(pos,pos2)[1]>10,world.distance(pos,pos2)[1]>15,world.distance(pos,pos2)[1]>20,world.distance(pos,pos2)[1]>25)
    else
      setGravRailBeamLeft(false,false,false,false,false)
    end
  end
  ::onLeft::
  if entity.animationState("gravrailState") == "off onLeft" or entity.animationState("gravrailState") == "onRight onLeft" or entity.animationState("gravrailState") == "onLeft onLeft" then
    local startPoint = {pos[1]+3,pos[2]+1}
    local endPoint = {pos[1]+28,pos[2]+1}
    local checkCollision = world.collisionBlocksAlongLine(startPoint,endPoint,"Static",1)
    if #checkCollision > 0 then
      local gravrail = world.objectQuery({(checkCollision[1][1])+2,(checkCollision[1][2])-1},1,{name="gravitonrail"})
      local gravrailstop = world.objectQuery({(checkCollision[1][1])+2,(checkCollision[1][2])-1},1,{name="gravitonrailstop"})
      local pos2 = nil
      if #gravrail > 0 then pos2 = world.entityPosition(gravrail[1]) end
      if #gravrailstop > 0 then pos2 = world.entityPosition(gravrailstop[1]) end
      if not pos2 then return end
      if pos[2] ~= pos2[2] then return end
      local region = { pos[1]+3.5, pos[2]+2.5, checkCollision[1][1]+4.5, pos[2]+3.25 }
      entity.setForceRegion(region, {-40, world.gravity(pos)*2.5})
    end
  end
end

function onInteraction(args)
  if (entity.isInboundNodeConnected(0) and entity.isInboundNodeConnected(1)) then
    return
  end
  cycleSetting(args.source[1])
end

function onNodeConnectionChange(args)
  entity.setInteractive(not entity.isInboundNodeConnected(0))
  if entity.isInboundNodeConnected(0) then
    onInboundNodeChange({level = entity.getInboundNodeLevel(0)})
  end
end

function onInboundNodeChange(args)
  local currentState = entity.animationState("gravrailState")
  local currentLeftState = string.sub(currentState,1,string.find(currentState," ")-1)
  local currentRightState = string.sub(currentState,string.find(currentState," ")+1) 
  if args.level then
    if args.node == 0 then
      if currentLeftState == "onLeft" then
        entity.setAnimationState("gravrailState", "off " .. currentRightState)
      end
    else
      if currentRightState == "onLeft" then
        entity.setAnimationState("gravrailState", currentLeftState .. " off")
      end
    end
    cycleSetting(args.node-1)
  end
end

function cycleSetting(direction)
  setGravRailBeamRight(false,false,false,false,false)
  setGravRailBeamLeft(false,false,false,false,false)
  local pos = entity.position()
  local currentState = entity.animationState("gravrailState")
  local currentLeftState = string.sub(currentState,1,string.find(currentState," ")-1)
  local currentRightState = string.sub(currentState,string.find(currentState," ")+1)
  if direction < 0 then
    self.signaldirection = "left"
    if currentLeftState == "off" then
      entity.setAnimationState("gravrailState", "onRight " .. currentRightState)
      entity.playSound("onSounds")
      self.signalrequest = "onRight"
      entity.setOutboundNodeLevel(0,true)
    elseif currentLeftState == "onRight" then
      entity.setAnimationState("gravrailState", "onLeft "  .. currentRightState)
      entity.playSound("onSounds")
      self.signalrequest = "onLeft"
      entity.setOutboundNodeLevel(0,true)
    elseif currentLeftState == "onLeft" then
      entity.setAnimationState("gravrailState", "off "  .. currentRightState)
      entity.playSound("offSounds")
      self.signalrequest = "off"
      entity.setOutboundNodeLevel(0,false)
    end
  else
    self.signaldirection = "right"
    if currentRightState == "off" then
      entity.setAnimationState("gravrailState", currentLeftState .. " onRight")
      entity.playSound("onSounds")
      self.signalrequest = "onRight"
      entity.setOutboundNodeLevel(1,true)
    elseif currentRightState == "onRight" then
      entity.setAnimationState("gravrailState", currentLeftState .. " onLeft")
      entity.playSound("onSounds")
      self.signalrequest = "onLeft"
      entity.setOutboundNodeLevel(1,true)
    elseif currentRightState == "onLeft" then
      entity.setAnimationState("gravrailState", currentLeftState .. " off")
      entity.playSound("offSounds")
      self.signalrequest = "off"
      entity.setOutboundNodeLevel(1,false)
    end  
  end
  self.signalwaiting = true
  self.signalstrength = 1
end

function synchronizeDevice(direction,state)
  local currentState = entity.animationState("gravrailState")
  if direction == "left" then
    local currentLeftState = string.sub(currentState,1,string.find(currentState," ")-1)
    --world.logInfo(currentLeftState .. " + request:" .. state.. " = [" .. currentLeftState .. " " .. state .. "]")
    entity.setAnimationState("gravrailState", currentLeftState .. " " .. state)
    if state == "off" then
      entity.playSound("offSounds")
      entity.setOutboundNodeLevel(0,false)
    else
      entity.playSound("onSounds")
      entity.setOutboundNodeLevel(0,true)
    end
  else
    local currentRightState = string.sub(currentState,string.find(currentState," ")+1)
    --world.logInfo("request: " .. state .. " + " .. currentRightState .. " = [" .. state .. " " .. currentRightState .. "]")
    entity.setAnimationState("gravrailState", state .. " " .. currentRightState)
    if state == "off" then
      entity.playSound("offSounds")
      entity.setOutboundNodeLevel(1,false)
    else
      entity.playSound("onSounds")
      entity.setOutboundNodeLevel(1,true)
    end
  end
  setGravRailBeamRight(false,false,false,false,false)
  setGravRailBeamLeft(false,false,false,false,false)

end

function readySignal(direction)
  local pos = entity.position();
  ownId = entity.id()
  self.signalwaiting = false
  if direction == "right" or direction == "both" then
    signalarearight = world.loadRegion({pos[1],pos[2]-2,pos[1]+35,pos[2]+2})
  end
  if direction == "left" or direction == "both" then
    signalarealeft = world.loadRegion({pos[1]-35,pos[2]-2,pos[1],pos[2]+2})
  end
  if signalarearight == false or signalarealeft == false then
    -- world area has not yet loaded, delay searching/sending signal
    self.signalwaiting = true
  else
    local currentState = entity.animationState("gravrailState")
    local currentLeftState = string.sub(currentState,1,string.find(currentState," ")-1)
    local currentRightState = string.sub(currentState,string.find(currentState," ")+1)
    if direction == "right" then
      sendSignal(self.signalstrength, direction, currentRightState)
    elseif direction == "left" then
      sendSignal(self.signalstrength, direction, currentLeftState)
    end
  end  
end

function sendSignal(strength, direction, request)
  local pos = entity.position();
  -------------------------------------------------------------------------------------------------
  -- check for gravrail/gravrail stop in signal direction -----------------------------------------
  -------------------------------------------------------------------------------------------------
  if direction == "right" then
    local checkRail = findNextRight()
    if checkRail then
      world.callScriptedEntity(checkRail, "receivedSignal", strength, "right", request)
    end
  end 
  if direction == "left" then
    local checkRail = findNextLeft() 
    if checkRail then
      world.callScriptedEntity(checkRail, "receivedSignal", strength, "left", request)
    end
  end
  -- a signal will have been sent now if a valid receiver detected - power down transmitter!
  self.signalstrength = 0
  self.signaldirection = ""
end

function findNextRight()
  local pos = entity.position()
  local startPoint = {pos[1]+3,pos[2]+1}
  local endPoint = {pos[1]+28,pos[2]+1}
  local checkCollision = world.collisionBlocksAlongLine(startPoint,endPoint,"Static",1) 
  if #checkCollision > 0 then
    local gravrail = world.objectQuery({(checkCollision[1][1])+2,(checkCollision[1][2])-1},1,{name="gravitonrail"})
    local gravrailstop = world.objectQuery({(checkCollision[1][1])+2,(checkCollision[1][2])-1},1,{name="gravitonrailstop"})
    local pos2 = nil
    if #gravrail > 0 then pos2 = world.entityPosition(gravrail[1]) end
    if #gravrailstop > 0 then pos2 = world.entityPosition(gravrailstop[1]) end
    if not pos2 then return nil end
    if pos[2] ~= pos2[2] then return nil end
    if #gravrail > 0 then return gravrail[1] end
    if #gravrailstop > 0 then return gravrailstop[1] end
  else
    return nil
  end
end

function findNextLeft()
  local pos = entity.position()
  local startPoint = {pos[1]-3,pos[2]+1}
  local endPoint = {pos[1]-28,pos[2]+1}
  local checkCollision = world.collisionBlocksAlongLine(startPoint,endPoint,"Static",1) 
  if #checkCollision > 0 then
    local gravrail = world.objectQuery({(checkCollision[1][1])-2,(checkCollision[1][2])-1},1,{name="gravitonrail"})
    local gravrailstop = world.objectQuery({(checkCollision[1][1])-2,(checkCollision[1][2])-1},1,{name="gravitonrailstop"})
    local pos2 = nil
    if #gravrail > 0 then pos2 = world.entityPosition(gravrail[1]) end
    if #gravrailstop > 0 then pos2 = world.entityPosition(gravrailstop[1]) end
    if not pos2 then return nil end
    if pos[2] ~= pos2[2] then return nil end
    if #gravrail > 0 then return gravrail[1] end
    if #gravrailstop > 0 then return gravrailstop[1] end
  else
    return nil
  end
end

function receivedSignal(strength,direction,request)
  if self.signalwaiting == true and strength < self.signalstrength then
    -- incoming signal weaker than one waiting to be sent
    -- so keep current setting instead
    return
  end
  -- incoming signal received, boost signal and ready it for sending
  self.signalstrength = strength + 1
  self.signalwaiting = true
  self.signaldirection = direction
  -- set state as requested by signal
  synchronizeDevice(direction,request)
end

function setGravRailBeamRight(b1,b2,b3,b4,b5)
  entity.setParticleEmitterActive("gravrailBeamRight1",b1)
  entity.setParticleEmitterActive("gravrailBeamRight2",b2)
  entity.setParticleEmitterActive("gravrailBeamRight3",b3)
  entity.setParticleEmitterActive("gravrailBeamRight4",b4)
  entity.setParticleEmitterActive("gravrailBeamRight5",b5)
end

function setGravRailBeamLeft(b1,b2,b3,b4,b5)
  entity.setParticleEmitterActive("gravrailBeamLeft1",b1)
  entity.setParticleEmitterActive("gravrailBeamLeft2",b2)
  entity.setParticleEmitterActive("gravrailBeamLeft3",b3)
  entity.setParticleEmitterActive("gravrailBeamLeft4",b4)
  entity.setParticleEmitterActive("gravrailBeamLeft5",b5)
end