function init()
  animator.setParticleEmitterOffsetRegion("snow", mcontroller.boundBox())
  animator.setParticleEmitterActive("snow", true)
  
  script.setUpdateDelta(5)

  self.tickDamagePercentage = 0.015
  self.tickTime = 1.0
  self.tickTimer = self.tickTime
end

function update(dt)
  mcontroller.controlModifiers({
      groundMovementModifier = -0.4,
      runModifier = -0.5,
      jumpModifier = -0.3
    })

  mcontroller.controlParameters({
      normalGroundFriction = 0.675
    })
    
  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 2,
        damageSourceKind = "nitrogenweapon",
        sourceEntityId = entity.id()
      })
  end

  effect.setParentDirectives("fade=0000AA="..self.tickTimer * 0.4)
end

function uninit()

end