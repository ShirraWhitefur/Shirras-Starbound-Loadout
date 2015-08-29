function init()
  local slows = status.statusProperty("slows", {})
  slows["slushslow"] = 0.3
  status.setStatusProperty("slows", slows)
end

function update(dt)
      mcontroller.controlParameters({
        normalGroundFriction = 1,
        groundForce = 25,
        slopeSlidingFactor = 0.162
        })
  mcontroller.controlModifiers({
        groundMovementModifier = -0.20,
        runModifier = -0.275,
        jumpModifier = -0.2
    })
end

function uninit()
  local slows = status.statusProperty("slows", {})
  slows["slushslow"] = nil
  status.setStatusProperty("slows", slows)
end





