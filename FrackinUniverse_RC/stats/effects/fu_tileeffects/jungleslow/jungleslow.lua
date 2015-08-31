function init()
  local slows = status.statusProperty("slows", {})
  slows["jungleslow"] = 0.8
  status.setStatusProperty("slows", slows)
end

function update(dt)
  mcontroller.controlModifiers({
      runModifier = -0.05
    })
end

function uninit()
  local slows = status.statusProperty("slows", {})
  slows["jungleslow"] = nil
  status.setStatusProperty("slows", slows)
end