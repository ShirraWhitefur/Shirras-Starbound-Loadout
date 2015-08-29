function init()
  animator.setParticleEmitterOffsetRegion("snow", mcontroller.boundBox())
  animator.setParticleEmitterActive("snow", true)
end

function update(dt)
  mcontroller.controlParameters({
        normalGroundFriction = 0.52,
        groundForce = 23.5,
        slopeSlidingFactor = 0.375
    })
end

function uninit()

end