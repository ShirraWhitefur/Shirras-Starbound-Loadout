function init()
  effect.addStatModifierGroup({{stat = "fallDamageMultiplier", basePercentage = -1}})
  animator.setParticleEmitterOffsetRegion("sparkles", mcontroller.boundBox())
  animator.setParticleEmitterActive("sparkles", true)
  effect.setParentDirectives("fade=6688FF;0.03?border=2;6688FF20;00000000")
  self.riseSpeedLimit = 100
  self.fallSpeedLimit = -100
end

function update(dt)
  if not mcontroller.onGround() then
    effect.modifyDuration(1)
  else
    effect.expire()
  end
  local position = mcontroller.position()
  local velocity = mcontroller.velocity()
  if velocity[2] > self.riseSpeedLimit then
    mcontroller.setYVelocity(self.riseSpeedLimit)
  end
  if velocity[2] < self.fallSpeedLimit then
    mcontroller.setYVelocity(self.fallSpeedLimit)
  end
end

function uninit()
end
