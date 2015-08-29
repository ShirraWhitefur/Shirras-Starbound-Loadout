function init(args)
	entity.setInteractive(true)
	entity.setAllOutboundNodes(entity.animationState("switchState") == "on")
end

function onInteraction(args)
	if entity.animationState("switchState") == "off" and entity.isOutboundNodeConnected(0) then
		entity.setAnimationState("switchState", "on")
		entity.playSound("on");
		entity.setAllOutboundNodes(true)
	else
		entity.setAnimationState("switchState", "off")
		entity.playSound("off");
		entity.setAllOutboundNodes(false)
	end
end
