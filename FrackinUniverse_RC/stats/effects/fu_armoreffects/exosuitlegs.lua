function init()
  script.setUpdateDelta(5)
end

function update(dt)
  mcontroller.controlModifiers({
    groundMovementModifier = 0.3,
	runModifier = 0.3,
	jumpModifier = 0.3
  })
end

function uninit()

end
