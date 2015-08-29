function init()
  animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
  animator.setParticleEmitterActive("flames", true)
  effect.setParentDirectives("fade=FF8800=0.2")
  script.setUpdateDelta(5)
  self.tickDamagePercentage = 0.056
  self.tickTime = 1.0
  self.tickTimer = self.tickTime
end



function update(dt)
  mcontroller.controlModifiers({
      groundMovementModifier = -0.35,
      runModifier = -0.30,
      jumpModifier = -0.25
    })
    
  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 2,
        damageSourceKind = "hellfireweapon",
        sourceEntityId = entity.id()
      })
  end
end

function uninit()

end