eyeBeamAttack = {}

--------------------------------------------------------------------------------
function eyeBeamAttack.enter()
  if not hasTarget() then
    return nil
  end

  return {
    timer = entity.configParameter("eyeBeamAttack.skillTime", 2),
    damagePerSecond = entity.configParameter("eyeBeamAttack.damagePerSecond", 1600),
    distanceRange = entity.configParameter("eyeBeamAttack.distanceRange"),
    winddownTimer = entity.configParameter("eyeBeamAttack.winddownTime"),
    windupTimer = entity.configParameter("eyeBeamAttack.windupTime"),
    blasting = false
  }
end

--------------------------------------------------------------------------------
function eyeBeamAttack.enteringState(stateData)
  entity.setAnimationState("movement", "idle")
  entity.setAnimationState("firstBeams", "windup")
  entity.setActiveSkillName("eyeBeamAttack")
end

--------------------------------------------------------------------------------
function eyeBeamAttack.update(dt, stateData)
  if not hasTarget() then return true end

  local toTarget = world.distance(self.targetPosition, mcontroller.position())
  local targetDir = util.toDirection(toTarget[1])


  if not stateData.blasting then 
    if math.abs(toTarget[1]) > stateData.distanceRange[2] then
      entity.setAnimationState("movement", "walk")
      move(toTarget, true)
    elseif math.abs(toTarget[1]) < stateData.distanceRange[1] then
      move({-toTarget[1], toTarget[2]}, true)
      entity.setAnimationState("movement", "walk")
      mcontroller.controlFace(targetDir)
    else
      stateData.blasting = true
    end
  else
    mcontroller.controlFace(targetDir)

    -- This part controls the phases of the attack. At the end of each timer expiration
    --   the next animation is started. Then the control falls through to the next phase.

    -- phase 1 - windup (steal underpants)
    if stateData.windupTimer > 0 then
      if stateData.windupTimer == entity.configParameter("eyeBeamAttack.windupTime") then
      entity.setAnimationState("movement", "idle")
      --entity.setAnimationState("firstBeams", "active")
      end
      stateData.windupTimer = stateData.windupTimer - dt
      if stateData.windupTimer  < 0 then
          entity.setLightActive("beam1", true)

          entity.setAnimationState("firstBeams", "active")

      end
      return flase
    -- phase 2 - active (????)
    elseif stateData.timer > 0 then
      eyeBeamAttack.blast(targetDir)
      stateData.timer = stateData.timer - dt
      if stateData.timer < 0 then
        entity.setAnimationState("firstBeams", "winddown")
        entity.setLightActive("beam1", false)

      end
      return false

    -- phase 3 - winddown (profit)
    elseif stateData.winddownTimer > 0 then
      stateData.winddownTimer = stateData.winddownTimer - dt
    else
      stateData.blasting = false
      return true
    end
  end


  return false
end

function eyeBeamAttack.blast(direction)
  local projectileType = entity.configParameter("eyeBeamAttack.projectile.type")
  local projectileConfig = entity.configParameter("eyeBeamAttack.projectile.config")
  local projectileOffset = entity.configParameter("eyeBeamAttack.projectile.offset")
  
  if projectileConfig.power then
    projectileConfig.power = projectileConfig.power * root.evalFunction("monsterLevelPowerMultiplier", entity.level())
  end

  world.spawnProjectile(projectileType, entity.toAbsolutePosition(projectileOffset), entity.id(), {direction, 0}, true, projectileConfig)
end

function eyeBeamAttack.leavingState(stateData)
  entity.setAnimationState("movement", "idle")
  entity.setAnimationState("firstBeams", "idle")
  entity.setActiveSkillName("")
end

