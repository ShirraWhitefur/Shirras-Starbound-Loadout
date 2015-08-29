function init()
  script.setUpdateDelta(5)
  self.tickDamagePercentage = 0.0001
  self.tickTime = 5.0
  self.tickTimer = self.tickTime
  activateVisualEffects()
  self.timers = {}
  for i = 1, 4 do
    self.timers[i] = math.random() * 2 * math.pi
  end  
end


function activateVisualEffects()
  local statusTextRegion = { 0, 1, 0, 1 }
  animator.setParticleEmitterOffsetRegion("statustext", statusTextRegion)
  animator.burstParticleEmitter("statustext")
end

function update(dt)
  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "poison",
        sourceEntityId = entity.id()
      })
  end
  for i = 1, 4 do
    self.timers[i] = self.timers[i] + dt
    if self.timers[i] > (2 * math.pi) then self.timers[i] = self.timers[i] - 2 * math.pi end

    local lightAngle = math.cos(self.timers[i]) * 120 + (i * 90)
    animator.setLightPointAngle("light"..i, lightAngle)
  end
end


function uninit()
  
end