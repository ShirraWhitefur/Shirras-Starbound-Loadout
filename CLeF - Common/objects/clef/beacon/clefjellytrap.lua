function goodReception()
  if world.underground(entity.position()) then
    return false
  end
  
  local ll = entity.toAbsolutePosition({ -4.0, 1.0 })
  local tr = entity.toAbsolutePosition({ 4.0, 32.0 })
  
  local bounds = {0, 0, 0, 0}
  bounds[1] = ll[1]
  bounds[2] = ll[2]
  bounds[3] = tr[1]
  bounds[4] = tr[2]
  
  return not world.rectTileCollision(bounds, {"Null", "Block", "Dynamic"})
end

function init()
  entity.setInteractive(true)
end

function onInteraction(args)
  if not goodReception() then
    return { "ShowPopup", { message = "Nope. Better place it on the surface." } }
  else
    entity.smash()
    world.spawnProjectile("regularexplosion2universal", entity.toAbsolutePosition({ 0.0, 1.0 }))
    world.spawnMonster("jellyboss", entity.toAbsolutePosition({ 0.0, 40.0 }), { level = 4 })
    world.spawnMonster("skeyejelly", entity.toAbsolutePosition({ 20.0, 40.0 }), { level = 4 })
    world.spawnMonster("skeyejelly", entity.toAbsolutePosition({ -20.0, 40.0 }), { level = 4 })
  end
end

function hasCapability(capability)
  return false
end
