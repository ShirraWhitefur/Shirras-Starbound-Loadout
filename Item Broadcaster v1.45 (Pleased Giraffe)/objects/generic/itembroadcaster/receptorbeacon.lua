function init(args)
	self.cooldown = -2
	storage.knownPeers = {}
	entity.setInteractive(true)
end

function onInteraction(args)
	entity.setAnimationState("static", "pulse")
	self.cooldown = 2
end

function turnOn()
	entity.setAnimationState("static", "on")
	self.cooldown = 1
end

function returnBeaconHandshake(caller)
	local tempVar = 0
	self.foundChests = {}
	self.excludeChests = {}
	local nearBroadcasters = world.objectQuery({entity.position()[1], entity.position()[2]+5}, 30, {callScript = "isBroadcastBeacon", callScriptResult = true})
	--world.logInfo("%s", nearBroadcasters)
	for u,v in ipairs(nearBroadcasters) do
		tempVar = world.callScriptedEntity(v, "returnChest")
		--world.logInfo("%s", tempVar)
		if tempVar ~= nil then
			self.excludeChests[tempVar] = true
		end
	end
	local nearChests = world.objectQuery(entity.position(), 15, {order = "nearest"})
	for i,j in ipairs(nearChests) do
		if world.containerSize(j) ~= nil and self.excludeChests[j] == nil then
			table.insert(self.foundChests, {j, entity.id()})
		end
	end
	--world.logInfo("BeaconHandshake: %s, %s", beacon, self.foundChests)
	if caller ~= nil and tableLength(entity.getInboundNodeIds(0)) == 0 then
		world.callScriptedEntity(caller, "acknowledgeBeaconPeers", self.foundChests)
	else
		for i,j in pairs(entity.getInboundNodeIds(0)) do
			world.callScriptedEntity(i, "acknowledgeBeaconPeers", self.foundChests)
		end
	end
end


function update(dt)
	world.loadRegion({entity.position()[1]-15, entity.position()[2]-15,entity.position()[1]+15,entity.position()[2]+15})
	if self.cooldown > 0 then
		self.cooldown = self.cooldown - dt
	elseif self.cooldown > -2 then
		entity.setAnimationState("static", "idle")
		self.cooldown = -2
	end
end

function tableLength(tab)
	local retVal = 0
	for i,j in pairs(tab) do
		retVal = retVal + 1
	end
	return retVal
end

function die()

end