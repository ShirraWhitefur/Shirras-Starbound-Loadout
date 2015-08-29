function update(dt)
    animator.setParticleEmitterOffsetRegion("healing", mcontroller.boundBox())
    animator.setParticleEmitterActive("healing", true)
end

function heal(damage)
end

function selfDamage(notification) --take damage
    if (status.resourcePercentage("health") <= 0.15) then --checks health level, change 0.1 to whatever below 1

    status.modifyResource("health", notification.damage / 2)
    
    status.clearPersistentEffects("brainreboot")
    --cleanup - removes itself after use
    effect.expire()
    end
    world.loginfo("This is working")
end

function clear()
end