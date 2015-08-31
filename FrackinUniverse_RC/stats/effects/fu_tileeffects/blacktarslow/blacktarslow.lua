function init()
  activateVisualEffects()
  local slows = status.statusProperty("slows", {})
  slows["tarslow"] = 0.55
  status.setStatusProperty("slows", slows)
end

function update(dt)
  mcontroller.controlModifiers({
      groundMovementModifier = -0.55,
      runModifier = -0.55,
      jumpModifier = -0.55
    })
end

function activateVisualEffects()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
  effect.setParentDirectives("fade=300030=0.8")
  local statusTextRegion = { 0, 1, 0, 1 }
  animator.setParticleEmitterOffsetRegion("statustext", statusTextRegion)
  animator.burstParticleEmitter("statustext")
end

function uninit()
  local slows = status.statusProperty("slows", {})
  slows["tarslow"] = nil
  status.setStatusProperty("slows", slows)
end