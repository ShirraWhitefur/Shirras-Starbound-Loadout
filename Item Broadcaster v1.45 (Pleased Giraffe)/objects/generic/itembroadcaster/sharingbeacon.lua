function init(virtual)
	self.cooldown = -1
	self.pause = false
	self.dead = false
	storage.chest = storage.chest or "none"
	storage.heldItems = storage.heldItems or {}
	storage.knownPeers = storage.knownPeers or {}
	if not virtual and tableLength(storage.knownPeers) > 0 then
		for iD, pos in pairs(storage.knownPeers) do
			world.logInfo("%s, %s", pos[1], pos[2])
			world.loadRegion({pos[1]-5, pos[2]-10, pos[1]+5, pos[2]+0})
		end
	end
	entity.setInteractive(true)
	storage.wirenetwork = false
end

function getSharedChest()
	if storage.chest ~= "none" and world.entityExists(storage.chest) and tableLength(storage.knownPeers) > 0 then
		world.containerTakeAll(storage.chest)
	end
	storage.chest = "none"
	local tempItems = {}
	local dropItems = {}
	local nearChests = world.objectLineQuery(entity.position(), {entity.position()[1], entity.position()[2] - 10}, {order = "nearest"})
	for i,j in ipairs(nearChests) do
		if world.containerSize(j) ~= nil then 
			--world.logInfo("Beacon %s has acquired Chest %s", entity.id(), j)
			storage.chest = j 
			tempItems = nullStrip(world.containerTakeAll(j))
			updatePeers()
			for u,v in pairs(tempItems) do
				table.insert(dropItems, nullStrip(world.containerAddItems(j, v)))
			end
			--world.logInfo("Excess items: %s", dropItems)
			for n,m in pairs(dropItems) do
				if type(m.name) == "string" and type(m.count) == "number" and type(m.data) == "table" then
					world.spawnItem(m.name, world.entityPosition(j), m.count, m.data) 
				end
			end
			sendSyncSignal()
			break 
		end
	end
end

function onInteraction(args)
	getSharedChest()
	entity.setAnimationState("static", "pulse")
	self.cooldown = 6
end

function isSharingBeacon()
	if self.dead then return false end
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

function onInboundNodeChange(args)

end

function onOutboundNodeChange(args)

end

function turnOn()
	entity.setAnimationState("static", "on")
	self.cooldown = 18
end

function returnChest()
	return storage.chest
end

function update(args)
	if self.dead then return true end
	if storage.chest ~= "none" and storage.chest ~= nil then
		if world.entityExists(storage.chest) then
			if table.tostring(storage.heldItems) ~= table.tostring(nullStrip(world.containerItems(storage.chest))) then		
				--world.logInfo("Beacon %s has detected content change in chest %s", entity.id(), storage.chest)
				--world.logInfo("%s, %s", table.tostring(storage.heldItems),table.tostring(nullStrip(world.containerItems(storage.chest))))
				storage.heldItems = nullStrip(world.containerItems(storage.chest))
				acknowledgeBeaconSyncSignal(storage.heldItems)
				sendSyncSignal()
			end
			world.loadRegion({world.entityPosition(storage.chest)[1]-5, world.entityPosition(storage.chest)[2]-1,entity.position()[1]+5,entity.position()[2]+1})
		else
			--world.logInfo("Beacon %s has lost chest %s", entity.id(), storage.chest)
			storage.chest = "none"
			storage.heldItems = {}
			sendSyncSignal()
			for i,j in pairs(storage.knownPeers) do
				world.callScriptedEntity(i, "removePeer", entity.id())
			end
			storage.knownPeers = {}
		end
	else
		getSharedChest()
	end
	if self.cooldown > 0 then
		self.cooldown = self.cooldown - 1
	elseif self.cooldown == 0 then
		entity.setAnimationState("static", "idle")
		self.cooldown = -1
	end
end

function sendSyncSignal()
	--world.logInfo("Beacon %s is sending the item stack %s to peers %s", entity.id(), storage.heldItems, storage.knownPeers)
	for i,j in pairs(storage.knownPeers) do
		world.callScriptedEntity(i, "acknowledgeBeaconSyncSignal", storage.heldItems)
	end
	turnOn()
end

function updatePeers()
	--world.logInfo("Beacon %s is checking for peers", entity.id())
	storage.knownPeers = {}
	-- if entity.isOutboundNodeConnected(0) or entity.isInboundNodeConnected(0) >= 1 then
		-- for i,j in ipairs(entity.getOutboundNodeIds(0)) do
			-- world.callScriptedEntity(j[1], entity.id(), world.containerSize(storage.chest), true)
		-- end
		-- for u,v in ipairs(entity.getInboundNodeIds(0)) do
			-- world.callScriptedEntity(v[1], entity.id(), world.containerSize(storage.chest), true)
		-- end
	-- else
		world.objectQuery(entity.position(), 3000, {callScript = "acknowledgeBeaconSharePeers", callScriptArgs = {entity.id(), world.containerSize(storage.chest), true, false}})
	--end
	turnOn()
end

function acknowledgeBeaconSharePeers(iD, slots, sendback, wiresignal)
	if self.dead then return false end
	if iD ~= entity.id() and wiresignal == storage.wirenetwork then
		if storage.chest ~= "none" and storage.chest ~= nil then
			if slots == world.containerSize(storage.chest) then
				--world.logInfo("Beacon %s has recognized peer %s", entity.id(), iD)
				storage.knownPeers[iD] = world.entityPosition(iD)
				if sendback then 
					--world.logInfo("..and reciprocates")
					world.callScriptedEntity(iD, "acknowledgeBeaconSharePeers", entity.id(), slots, false, false) 
					world.callScriptedEntity(iD, "acknowledgeBeaconSyncSignal", storage.heldItems)
				end
			end
		end
	end
end

function removePeer(iD)
	if storage.knownPeers ~= {} then
		storage.knownPeers[iD] = nil
	end
end

function acknowledgeBeaconSyncSignal(newItems)
	if self.dead then return false end
	if storage.chest ~= "none" and storage.chest ~= nil then
		--world.logInfo("Beacon %s has recieved item stack %s", entity.id(), newItems)
		turnOn()
		world.containerTakeAll(storage.chest)
		for i,j in ipairs(newItems) do
			world.containerAddItems(storage.chest, j)
		end
		storage.heldItems = nullStrip(world.containerItems(storage.chest))
	end
end

function tableLength(tab)
	local retVal = 0
	for i,j in pairs(tab) do
		retVal = retVal + 1
	end
	return retVal
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

function die()
	local shouldTake = false
	for i,j in pairs(storage.knownPeers) do
		if world.callScriptedEntity(i, "returnChest") ~= "none" then shouldTake = true end
		world.callScriptedEntity(i, "removePeer", entity.id())
	end
	if shouldTake then world.containerTakeAll(storage.chest) end
	self.dead = true
end