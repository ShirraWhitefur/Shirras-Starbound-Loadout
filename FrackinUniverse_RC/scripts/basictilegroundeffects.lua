local oldInit = init
local oldUpdate = update

function init()
  oldInit()
  self.tempJumpControl = false
  tileMaterials()
end

function update(dt)
  if not mcontroller.onGround() and self.tempJumpControl == true then
    if self.jumpModifier ~= 0 then mcontroller.controlModifiers({jumpModifier = self.jumpModifier}) end
  end
  
  local groundSoftness = 1
  
  if mcontroller.onGround() then
    self.tempControl = false
    self.jumpModifier = 0
    groundMat = groundContact()
    if self.matCheck[groundMat] then
      for i, effect in ipairs(self.matCheck[groundMat][1]) do
        status.addEphemeralEffects{{effect = self.matCheck[groundMat][1][i]}}
      end
      mcontroller.controlModifiers({
          groundMovementModifier = self.matCheck[groundMat][2],
          runModifier = self.matCheck[groundMat][3],
          jumpModifier = self.matCheck[groundMat][4]
        })
      mcontroller.controlParameters({
          normalGroundFriction = self.matCheck[groundMat][5],
          groundForce = self.matCheck[groundMat][6],
          slopeSlidingFactor = self.matCheck[groundMat][7]
        })
      if jumpModifier ~= 0 then
        self.tempJumpControl = true
        self.jumpModifier = self.matCheck[groundMat][4]
      end
      groundSoftness = self.matCheck[groundMat][8]
    end    
  end

  --reworked fall damage check to apply groundSoftness
  local minimumFallDistance = 14
  local fallDistanceDamageFactor = 3
  local minimumFallVel = 40
  local baseGravity = 80
  local gravityDiffFactor = 1 / 30.0

  local curYVelocity = mcontroller.yVelocity()

  local yVelChange = curYVelocity - self.lastYVelocity
  if self.fallDistance > minimumFallDistance and yVelChange > minimumFallVel  and mcontroller.onGround() then
    local damage = (self.fallDistance - minimumFallDistance) * fallDistanceDamageFactor * groundSoftness
    damage = damage * (1.0 + (world.gravity(mcontroller.position()) - baseGravity) * gravityDiffFactor)
    damage = damage * status.stat("fallDamageMultiplier")
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = damage,
        damageSourceKind = "falling",
        sourceEntityId = entity.id()
      })
    -- set self.fallDistance to 0 to prevent normal fall damage check from triggering additional damage
    self.fallDistance = 0
  end
  
	oldUpdate(dt)
end

function groundContact()
  local mpos = mcontroller.position()
  local position = {mpos[1],math.floor(mpos[2])}
  local groundMat = world.material(vec2.add({position[1],position[2]}, {0,-3}), "foreground")
  world.debugLine(position, {position[1], position[2]-3}, "green")
  if groundMat == false then
    if math.ceil(mpos[1]-0.5) == math.floor(mpos[1]) then
      groundMat = world.material(vec2.add(position, {-1,-3}), "foreground")
      world.debugLine(position, {position[1]-1, position[2]-3}, "green")
    else
      groundMat = world.material(vec2.add(position, {1,-3}), "foreground")
      world.debugLine(position, {position[1]+1, position[2]-3}, "green")
    end
  end
  if groundMat == false then
    local stoodOnObject = world.objectQuery(vec2.add({position[1],position[2]}, {0,-3.5}), 0.1, {order = "nearest"})
    if stoodOnObject == false then
      if math.ceil(mpos[1]-0.5) == math.floor(mpos[1]) then
        stoodOnObject = world.objectQuery(vec2.add(position, {-1,-3.5}), 0.1, {order = "nearest"})
      else
        stoodOnObject = world.objectQuery(vec2.add(position, {1,-3.5}), 0.1, {order = "nearest"})
      end
    end
    if #stoodOnObject >= 1 then
      stoodOn = tostring(world.entityName(stoodOnObject[1]))
      world.debugText(stoodOn,{position[1]-(string.len(stoodOn)*0.25),position[2]-3.5},"green")
    end
  else
    world.debugText(tostring(groundMat),{position[1]-(string.len(tostring(groundMat))*0.25),position[2]-3.5},"green")
  end
  return groundMat,stoodOn or false
end

function tileMaterials()
  -- world.logInfo("tilematerials")
  self.matCheck = {
    -- ["materialName"] = {{EphemeralEffects to apply},
    --  groundMovementModifier, runModifier, jumpModifier,      <-- mcontroller.controlModifiers
    --  normalGroundFriction, groundForce, slopeSlidingFactor,  <-- mcontroller.controlParameters 
    --  groundSoftness}
    -- ["anormaltile"] = {{},0,0,0,14,100,0,1}
    --["cloudblock"] = {{},-0.2,-0.2,0.25,8.0,100,0.0,0.25},
    --["mud"] = {{},-0.5,-0.5,-0.25,6.0,20,0.2,0.75},
    --["clay"] = {{},-0.5,-0.5,-0.25,6.0,20,0.2,1},
    --["sewage"] = {{},-0.5,-0.5,-0.25,6.0,20,0.2,0.75},
    --["tar"] = {{},-0.75,-0.75,-0.5,8.0,75,0.2,0.75},
    --["frozenwater"] = {{},0,0,0,0.25,10,0.25,1},
    --["ice"] = {{},0,0,0,0.5,10,0.5,1},
    --["iceblock"] = {{},0,0,0,0.5,10,0.5,1},
    --["slime"] = {{},-0.5,-0.5,-0.25,12.0,20,0.2,0.75},
    --["slush"] = {{},-0.3,-0.3,-0.3,1.0,20,0.5,0.75},
    --["snow"] = {{},-0.2,-0.2,-0.2,12.0,75,0.2,0.75},
    --["spidersilkblock"] = {{},0,0,0,14,100,0.0,0.5},
    ["cloudblock"] = {{},0,0,0,14,100,0,1},
    ["mud"] = {{},0,0,0,14,100,0,1},
    ["clay"] = {{},0,0,0,14,100,0,1},
    ["sewage"] = {{},0,0,0,14,100,0,1},
    ["tar"] = {{},0,0,0,14,100,0,1},
    ["frozenwater"] = {{},0,0,0,0.25,10,0.25,1},
    ["ice"] = {{},0,0,0,0.5,10,0.5,1},
    --["iceblock"] = {{},0,0,0,0.5,10,0.5,1},
    ["slime"] = {{},0,0,0,14,100,0,1},
    ["slush"] = {{},0,0,0,14,100,0,1},
    ["snow"] = {{},0,0,0,14,100,0,1},
    ["spidersilkblock"] = {{},0,0,0,14,100,0,1},
  }
end