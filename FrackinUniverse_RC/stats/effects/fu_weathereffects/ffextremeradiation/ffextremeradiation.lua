function init()
  animator.setParticleEmitterOffsetRegion("lights", mcontroller.boundBox())
  animator.setParticleEmitterActive("lights", true)
  effect.setParentDirectives("fade=00FFBB=0.15")
  script.setUpdateDelta(5)
  self.tickDamagePercentage = 0.032
  self.tickTime = 1.0
  self.tickTimer = self.tickTime

end



function update(dt)
  mcontroller.controlModifiers({
      groundMovementModifier = -0.10,
      runModifier = -0.20,
      jumpModifier = -0.15
    })
    
  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "hellfireweapon",
        sourceEntityId = entity.id()
      })
  end
end

function uninit()

end