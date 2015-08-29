function init(args)

end

function update(args)

end

function returnHandshake(iD)
	if world.containerSize(entity.id()) ~= nil then
		world.callScriptedEntity(iD, "acknowledgePeer", entity.id())
	end
end

function isReceptorChest()
	return true
end

function revertSelf()
	world.logInfo("R reverting")
	self.params = {}
	self.params.storedItems = world.containerTakeAll(entity.id())
	self.params.facing = entity.direction()
	self.params.location = entity.position()
	self.params.name = entity.configParameter("objectName")
	entity.smash()
	world.logInfo("%s", world.spawnMonster("broadcastscriptmonster", {self.params.location[1], self.params.location[2]+1}, {broadcastProperties = self.params}))
end

function die()

end