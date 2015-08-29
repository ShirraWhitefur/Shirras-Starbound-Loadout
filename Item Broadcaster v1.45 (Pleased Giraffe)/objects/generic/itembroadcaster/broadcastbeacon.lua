function init(args)
	self.cooldown = -2
	self.pause = false
	storage.heldItems = {}
	storage.knownPeers= {}
	storage.chest = "none"
	entity.setInteractive(true)
end

function getBroadcastChest()
	storage.chest = "none"
	local nearChests = world.objectLineQuery(entity.position(), {entity.position()[1], entity.position()[2] - 10}, {order = "nearest"})
	for i,j in ipairs(nearChests) do
		if world.containerSize(j) ~= nil then storage.chest = j break end
	end
end

function onInteraction(args)
	getBroadcastChest()
	--entity.scaleGroup("pulse", {1,1})
	entity.setAnimationState("static", "pulse")
	self.cooldown = 2
end

function isBroadcastBeacon()
	return true
end

function returnChest()
	return storage.chest
end

function turnOn()
	entity.setAnimationState("static", "on")
	self.cooldown = 1
end

function update(dt)
	if storage.chest ~= "none" and storage.chest ~= nil then
		if world.entityExists(storage.chest) and world.containerSize(storage.chest) ~= nil then
			if self.pause == true then
				storage.heldItems = world.containerTakeAll(storage.chest)
				distributeItems()
				for i,j in pairs(storage.heldItems) do
					world.containerAddItems(storage.chest, j)
				end
				storage.heldItems = world.containerItems(storage.chest)
				self.pause = false
			end
			if table.tostring(storage.heldItems) ~= table.tostring(world.containerItems(storage.chest)) then		
				local hasItems = false
				for i,j in pairs(world.containerItems(storage.chest)) do
					if j ~= nil then
					   hasItems = true
					   break
					end
				end
				if hasItems == true then
					--world.logInfo("Running")
					sendBeaconHandshake()
					self.pause = true
				end
			end
			world.loadRegion({world.entityPosition(storage.chest)[1]-5, world.entityPosition(storage.chest)[2]-1,entity.position()[1]+5,entity.position()[2]+1})
		else
			storage.chest = "none"
		end
	else
		getBroadcastChest()
	end
	if self.cooldown > 0 then
		self.cooldown = self.cooldown - dt
	elseif self.cooldown > -2 then
		entity.setAnimationState("static", "idle")
		self.cooldown = -2
	end
end

function sendBeaconHandshake()
	storage.knownPeers = {}
	--world.logInfo(table.tostring(entity.getOutboundNodeIds(0)))
	if tableLength(entity.getOutboundNodeIds(0)) >= 1 then
		for i,j in pairs(entity.getOutboundNodeIds(0)) do
			world.callScriptedEntity(i, "returnBeaconHandshake")
		end
	else
		--world.logInfo("Bigscan")
		world.objectQuery(entity.position(), 100, {callScript = "returnBeaconHandshake", callScriptArgs = {entity.id()}})
	end
	--world.logInfo("BeaconHandshake Recieved: %s", storage.knownPeers)
end

function acknowledgeBeaconPeers(iDs)
	--make sure not to send to a containe ron the same hyperstorage network
	local chestSize = world.containerSize(storage.chest)
	local hyperList = world.getProperty("hyperStoragePeers-"..tostring(chestSize)) or {}
	for i,j in ipairs(iDs) do
		if tableLength(hyperList) < 2 or not hyperList[table.tostring(world.entityPosition(storage.chest))] or not hyperList[table.tostring(world.entityPosition(j[1]))] then
			table.insert(storage.knownPeers, j)
		end
	end
end

function distributeItems()
	local testitem = {}
	for i,chest in ipairs(storage.knownPeers) do
		local peerSend = false
		for j,item in ipairs(storage.heldItems) do
			if item ~= nil then
				testitem.count = 1
				testitem.name = item.name
				testitem.data = item.data
				if world.containerAvailable(chest[1], testitem) >= 1 then
					turnOn()
					world.callScriptedEntity(chest[2], "turnOn")
					storage.heldItems[j] = world.containerAddItems(chest[1], item)
					local sentItem1 = world.spawnItem("broadcastbeaconsignal", vec2.add(world.entityPosition(storage.chest), {0.5, 0.5}), 1)
					world.takeItemDrop(sentItem1, entity.id())
					local sentItem2 = world.spawnItem("broadcastbeaconsignal", vec2.add(entity.position(), {0.5,0.5}), 1)
					world.takeItemDrop(sentItem2, chest[2])
					local sentItem3 = world.spawnItem("broadcastbeaconsignal", vec2.add(world.entityPosition(chest[2]), {0.5,0.5}), 1)
					world.takeItemDrop(sentItem3, chest[1])
				end
			end
		end
	end
end

function tableLength(tab)
	local retVal = 0
	if type(tab) ~= "table" then return -1 end
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

function tableLength(tab)
	local retVal = 0
	for i,j in pairs(tab) do
		retVal = retVal + 1
	end
	return retVal
end

vec2 = {}
function vec2.add(a,b) 
	return {a[1] + b[1], a[2] + b[2]}
end

function die()

end