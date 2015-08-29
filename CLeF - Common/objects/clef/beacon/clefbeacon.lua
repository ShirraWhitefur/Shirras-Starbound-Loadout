
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

function init(args)
  entity.setInteractive(true)
  if not goodReception() then
    entity.setAnimationState("beaconState", "idle")
  else
    entity.setAnimationState("beaconState", "active")
  end
end

function onInteraction(args)
  if not goodReception() then
    entity.setAnimationState("beaconState", "idle")
    return { "ShowPopup", { message = "No signal! Please make sure nothing is blocking it." } }
  else
    entity.setAnimationState("beaconState", "active")
    world.spawnProjectile("regularexplosion2universal", entity.toAbsolutePosition({ 0.0, 1.0 }))
    entity.smash()
    world.spawnMonster("penguinUfo", entity.toAbsolutePosition({ 0.0, 32.0 }), { level = 1 })
  end
end

function hasCapability(capability)
  return false
end
