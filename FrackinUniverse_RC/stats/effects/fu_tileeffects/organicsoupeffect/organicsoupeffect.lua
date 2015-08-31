function init()
  effect.setParentDirectives("border=2;0088FF99;00000000")
  if mcontroller.velocity()[2] <= 10 then
    mcontroller.setYVelocity(10.0)
  end
  effect.addStatModifierGroup({{stat = "fallDamageMultiplier", basePercentage = -1}})
end

function update(dt)
  mcontroller.controlParameters({
      bounceFactor = 0.9
    })
end

function uninit()
  
end