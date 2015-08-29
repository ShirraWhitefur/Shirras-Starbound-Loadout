function init()
  local slows = status.statusProperty("slows", {})
  slows["snowslow"] = 0.53
  status.setStatusProperty("slows", slows)
end

function update(dt)
  mcontroller.controlModifiers({
        groundMovementModifier = -0.275,
        runModifier = -0.275,
        jumpModifier = -0.2
    })
end

function uninit()
  local slows = status.statusProperty("slows", {})
  slows["snowslow"] = nil
  status.setStatusProperty("slows", slows)
end





