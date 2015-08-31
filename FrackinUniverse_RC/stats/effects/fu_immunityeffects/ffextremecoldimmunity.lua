function init()
  effect.setParentDirectives("border=2;0000FF55;00000000")
  effect.addStatModifierGroup({
    {stat = "ffextremecoldImmunity", amount = 1},
    {stat = "biomecoldImmunity", amount = 1}
  })
end

function update(dt)
end

function uninit()
  
end