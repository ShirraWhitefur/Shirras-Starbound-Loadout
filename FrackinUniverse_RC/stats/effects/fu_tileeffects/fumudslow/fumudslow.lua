function init()
  local slows = status.statusProperty("slows", {})
  slows["fumudslow"] = 0.6
  status.setStatusProperty("slows", slows)
end

function update(dt)
  mcontroller.controlModifiers({
      runModifier = -0.2,
      jumpModifier = -0.25
    })
end

function uninit()
  local slows = status.statusProperty("slows", {})
  slows["fumudslow"] = nil
  status.setStatusProperty("slows", slows)
end