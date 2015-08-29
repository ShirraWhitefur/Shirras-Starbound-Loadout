function init(virtual)
	self.animationCooldown = -1
	self.dead = false
	storage.chest = storage.chest or "none"
	storage.chestSize = storage.chestSize or 0
	storage.chestAddress = storage.chestAddress or {0,0}
	storage.heldItems = storage.heldItems or {}
	entity.setInteractive(true)
end

function update(dt)
	if self.dead then 
		world.breakObject(entity.id())
		return false
	end
	if not storage.loadPoly then --just to make sure the chest gets loaded too...
		local pos = entity.position()
		storage.loadPoly = {pos[1] - 5, pos[2] - 20, pos[1] + 5, pos[2] + 3}
	end
	world.loadRegion(storage.loadPoly)
	if storage.chest ~= "none" and storage.chest ~= nil then 
		hyperContents = world.getProperty("hyperStorageContents-"..tostring(storage.chestSize)) or {} --what's in the storage network
		beaconContents = storage.heldItems or {} --what does the beacon remember
		if world.entityExists(storage.chest) and peaslyDeepCompare(world.entityPosition(storage.chest), storage.chestAddress) then --chest exists, and is at right location (loading entityId swapping has to be resolved)
			chestContents = world.containerItems(storage.chest) or {} --and what we find in the chest
			--world.logInfo("H: %s, B: %s, C: %s", hyperContents, beaconContents, chestContents)
			if not peaslyDeepCompare(beaconContents, chestContents) then --if chest ~= beacon, then chest has been altered; storage must change
				storage.heldItems = world.containerItems(storage.chest)
				--world.logInfo("H: %s, B: %s, C: %s", hyperContents, beaconContents, chestContents)
				sendSyncSignal()		
			elseif not peaslyDeepCompare(beaconContents, hyperContents) then --if chest == beacon and != storage, then storage has altered; chest must change
				--world.logInfo("H: %s, B: %s, C: %s", hyperContents, beaconContents, chestContents)
				acceptSyncSignal()
			end
		elseif recoverNewChestId() then
			--leeway for entityId shift when loading
		else
			--a chest has been destroyed! this will dump all items from network
			--world.logInfo("Chest %s at %s lost!", storage.chest, storage.chestAddress)
			storage.heldItems = {}
			removeFromPeerList()
			sendSyncSignal()
			storage.chest = "none"
			storage.chestSize = 0
			storage.chestAddress = {0,0}
		end
	else
		getSharedChest()
	end
	if self.animationCooldown < -1 then --handle the lighting
	elseif self.animationCooldown > 0 then
		self.animationCooldown = self.animationCooldown - dt
	elseif self.animationCooldown <= 0 then
		entity.setAnimationState("static", "idle")
		self.animationCooldown = -2
	end
end

function die()
	if not storage.chest or storage.chest == "none" then return false end
	local shouldTake = false
	if tableLength(world.getProperty("hyperStoragePeers-"..tostring(storage.chestSize))) > 1 then shouldTake = true end --is there another chest on the network? if so, this chest needs to lose the items
		removeFromPeerList()
	if shouldTake then 
		world.containerTakeAll(storage.chest) 
	else --also good to purge the storage when the network dies
		world.setProperty("hyperStorageContents-"..storage.chestSize, {}) 
	end
end

function recoverNewChestId()
	if storage.chest ~= "none" then
		local reviveChestList = world.objectQuery(storage.chestAddress, 1)
		for i,j in ipairs(reviveChestList) do
			if world.containerSize(j) and peaslyDeepCompare(world.entityPosition(j), storage.chestAddress) then --looks where the chest was, sees if a chest is there
				--world.logInfo("Chest recovered at %s: %s -> %s", storage.chestAddress, storage.chest, j)
				storage.chest = j
				storage.chestSize = world.containerSize(j)
				return true
			end
		end
	end
end

function getSharedChest()
	if storage.chest ~= "none" and world.entityExists(storage.chest) and tableLength(world.getProperty("hyperStoragePeers-"..tostring(storage.chestSize))) > 0 then --this is for the manual beacon reset
		world.containerTakeAll(storage.chest)
	end
	storage.chest = "none"
	storage.chestSize = 0
	storage.chestAddress = {0,0}
	local tempGlobalItems = {}
	local tempChestItems = {}
	local dropItems = {}
	local nearChests = world.objectLineQuery(entity.position(), {entity.position()[1], entity.position()[2] - 10}, {order = "nearest"})
	for i,j in ipairs(nearChests) do
		if world.containerSize(j) ~= nil then 
			--world.logInfo("Beacon %s has acquired Chest %s at %s", entity.id(), j, world.entityPosition(j))
			storage.chest = j 
			storage.chestSize = world.containerSize(j)
			storage.chestAddress = world.entityPosition(j)
			if not addToPeerList() then 
				storage.chest = none
				storage.chestSize = 0
				storage.chestAddress = {0,0}
				self.dead = true
				return false
			end
			tempGlobalItems = world.getProperty("hyperStorageContents-"..tostring(storage.chestSize)) or {}
			tempChestItems = world.containerItems(j) --snag the chest contents
			world.containerTakeAll(j)
			sortedPlaceItems(j, tempGlobalItems) --first we put the hyperstorage in
			for u,v in pairs(tempChestItems) do
				table.insert(dropItems, world.containerAddItems(j, v)) --then try to add any new items
			end
			--world.logInfo("Excess items: %s", dropItems)
			for n,m in pairs(dropItems) do
				if type(m.name) == "string" and type(m.count) == "number" and type(m.parameters) == "table" then
					world.spawnItem(m.name, world.entityPosition(j), m.count, m.data) --and drop what can't fit
				end
			end
			storage.heldItems = world.containerItems(storage.chest)
			sendSyncSignal()
			break 
		end
	end
end

function onInteraction(args)
	--getSharedChest()
	entity.setAnimationState("static", "pulse")
	self.animationCooldown = 3
end

function sortedTakeItems(chest) --keeps the slots accurate
	local retTab = {}
	for i=1, world.containerSize(chest) do
		retTab[i] = world.containerTakeAt(chest, i-1)
	end
	return retTab
end

function sortedPlaceItems(chest, items) --keeps the slots accurate
	for i,j in pairs(items) do
		if j and type(j) == "table" and tableLength(j) > 0 then
			world.containerPutItemsAt(chest, j, i-1)
		end
	end
end

function turnOn()
	entity.setAnimationState("static", "on")
	self.animationCooldown = 1
end

function isSharingBeacon()
	return true
end

function sendSyncSignal()
	if storage.chestSize and storage.chestSize > 0 then
		--world.logInfo("Chest at %s sending Sync", storage.chestAddress)
		world.setProperty("hyperStorageContents-"..tostring(storage.chestSize), storage.heldItems)
		turnOn()
	end
end

function acceptSyncSignal()
	if storage.chestSize and storage.chestSize > 0 then
		world.containerTakeAll(storage.chest)
		--world.logInfo("Chest at %s taking Sync", storage.chestAddress)
		storage.heldItems = world.getProperty("hyperStorageContents-"..tostring(storage.chestSize)) or {}
		sortedPlaceItems(storage.chest, storage.heldItems)
		turnOn()
	end
end

function addToPeerList() --a list of what chests are on the network, prevents double-dipping with beacons and handles last-chest cases
	local peerListAddress = "hyperStoragePeers-"..tostring(storage.chestSize)
	local peerList = world.getProperty(peerListAddress) or {}
	--world.logInfo("Peers:%s + %s", peerList, table.tostring(storage.chestAddress))
	if peerList[table.tostring(storage.chestAddress)] and #world.objectQuery(peerList[table.tostring(storage.chestAddress)], 0.1, {callScript = "isSharingBeacon", callScriptResult = true}) >= 1 then
		--world.logInfo("Duplicate Hyperstorage Beacon detected!")
		return false
	end
	peerList[table.tostring(storage.chestAddress)] = entity.position()
	world.setProperty(peerListAddress, peerList)
	return true
end

function removeFromPeerList()
	local peerListAddress = "hyperStoragePeers-"..tostring(storage.chestSize)
	local peerList = world.getProperty(peerListAddress) or {}
	--world.logInfo("Peers:%s - %s", peerList, table.tostring(storage.chestAddress))
	peerList[table.tostring(storage.chestAddress)] = nil
	world.setProperty(peerListAddress, peerList)
end

function tableLength(tab)
	local retVal = 0
	if type(tab) ~= "table" then return -1 end
	for i,j in pairs(tab) do
		retVal = retVal + 1
	end
	return retVal
end

function peaslyDeepCompare(a1, a2)   
	if type(a1) ~= type(a2) then 
		return false 
	end
	if type(a1) ~= "table" then 
		return a1 == a2 
	end
	if tableLength(a1) ~= tableLength(a2) then
		return false
	end
	for i,b in pairs(a1) do
		c = a2[i]
		if type(b) ~= type(c) then 
			return false
		elseif type(b) == "table" and (tableLength(b) ~= tableLength(c) or not peaslyDeepCompare(b, c)) then
			return false
		elseif type(b) == "number" and b ~= c then
			return false
		elseif type(b) == "string" and b ~= c then
			return false
		end
	end
	return true
end

function nullStrip(input)
	local output = {}
	local iterator = 1
	if type(input) ~= "table" then return {input} end
	for i,j in pairs(input) do
		if type(i) == "number" and j ~= nil then
			output[iterator] = j
			iterator = iterator + 1
		elseif j ~= nil then
			output[i] = j
		end
	end
	return output
end

----------Thank you lua-users.org/wiki

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end