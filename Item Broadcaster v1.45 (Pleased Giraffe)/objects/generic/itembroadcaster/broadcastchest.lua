function init(args)
	prep()
end

function prep()
	self.size = world.containerSize(entity.id())
	if self.size ~= nil then
		storage.heldItems = world.containerItems(entity.id())
		storage.knownPeers = {}
		self.pause = false
		self.hasPrepped = true
	end
end

function update(args)
	if self.size ~= nil then
		if self.pause == true then
			storage.heldItems = world.containerTakeAll(entity.id())
			distributeItems()
			for i,j in ipairs(storage.heldItems) do
				world.containerAddItems(entity.id(), j)
			end
			storage.heldItems = world.containerItems(entity.id())
			self.pause = false
		end
		if deepCompare(storage.heldItems, world.containerItems(entity.id())) == false then		
			storage.heldItems = world.containerItems(entity.id())
			local hasItems = false
			for i,j in ipairs(storage.heldItems) do
				if j ~= "null" then
				 hasItems = true
				 break
				end
			end
			if hasItems == true then
				broadcastHandshake()
				self.pause = true
			end
		end
	elseif self.hasPrepped ~= true then
		prep()
	end
end

function broadcastHandshake()
	storage.knownPeers = {}
	world.objectQuery(entity.position(), 100, {callScript = "returnHandshake", callScriptArgs = {entity.id()}, order = "nearest"})
end

function acknowledgePeer(iD)
	table.insert(storage.knownPeers, iD)
end

function revertSelf()
	self.params = {}
	self.params.storedItems = world.containerTakeAll(entity.id())
	self.params.facing = entity.direction()
	self.params.location = entity.position()
	self.params.name = entity.configParameter("objectName")
	entity.smash()
	world.spawnMonster("broadcastscriptmonster", {self.params.location[1], self.params.location[2]+1}, {broadcastProperties = self.params})
end

function isBroadcastChest()
	return true
end

function distributeItems()
	local testitem = {}
	for i,chest in ipairs(storage.knownPeers) do
		for j,item in ipairs(storage.heldItems) do
			if item ~= nil then
				testitem.count = 1
				testitem.name = item.name
				testitem.data = item.data
				if world.containerAvailable(chest, testitem) >= 1 then
					storage.heldItems[j] = world.containerAddItems(chest, item)
				end
			end
		end
	end
end

function deepCompare(tab1, tab2)
	if type(tab1) ~= type(tab2) then return false 
	elseif type(tab1) ~= "table" then return tab1 == tab2
	elseif #tab1 ~= #tab2 then return false end
	for i,j in ipairs(tab1) do
		if deepCompare(j, tab2[i]) == false then return false end
	end
	return true
end

function die()

end