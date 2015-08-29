function init()
	self.scanMatrix = {}
	retryScan = false
	self.bounds = {-195,-105,195,105}
	liquidIndex = {
		[6] = 4, ["healingliquid"] = 4, [10] = 4, ["liquidnitrogen"] = 4,
		[2] = 5, ["lava"] = 5, [8] = 5, ["corelava"] = 5,
		[3] = 6, ["poison"] = 6,
		[11] = 7, ["fuel"] = 7, [5] = 7, ["liquidoil"] = 7
	}
	
	message.setHandler("doScan", function(_,_, bounds)
      doScan(bounds)
    end)
	message.setHandler("purgeGlobalStorage", function()
      purgeGlobalStorage()
    end)
	message.setHandler("loadWithinBounds", function(_,_, bounds)
      loadWithinBounds(bounds)
    end)
	
end

function update(dt)
	if retryScan then
		doScan()
	end
end

function doScan(bounds)
	--world.logInfo("Beginning Scan")
	if bounds ~= nil then self.bounds = bounds end	
	if loadWithinBounds(self.bounds) then
		purgeGlobalStorage()
		populateMatrix()
		--world.logInfo("%s:%s of %s:%s", self.scanMatrix[1][1], self.scanMatrix[#self.scanMatrix][#self.scanMatrix[1]], #self.scanMatrix, #self.scanMatrix[1])
		world.setProperty(tostring("GPR Scan List: %s", entity.position()), self.scanMatrix)
		retryScan = false
	else
		retryScan = true
	end
end

function populateMatrix()
	--world.logInfo("Populating Matrix")
	local adjustedBounds = {self.bounds[3] - self.bounds[1], self.bounds[4] - self.bounds[2]}
	for x=1, adjustedBounds[1] do
		self.scanMatrix[x] = {}
		for y=1, adjustedBounds[2] do
			self.scanMatrix[x][y] = getTile({self.bounds[1] + x,self.bounds[2] + y})
		end
	end
end

function loadWithinBounds(bounds)
	local realBounds = {bounds[1]+entity.position()[1], bounds[2]+entity.position()[2], bounds[3] +entity.position()[1], bounds[4]+entity.position()[2]}
	return world.loadRegion(realBounds)
end

function purgeGlobalStorage()
	world.setProperty(tostring("GPR Scan List: %s", entity.position()), nil)
end

function getTile(inPos)
	local position = vec2.add(entity.position(), inPos)
	local isMod = world.mod(position, "foreground")
	local isBackMod = world.mod(position, "background")
	local isTile = world.material(position, "foreground")
	local isBack = world.material(position, "background")
	local isLiquid = world.liquidAt(position)
	if isMod ~= nil then 
		return {isMod, true, 1}
	elseif isBackMod ~= nil and isTile then
		return {isBackMod, true, 1}
	elseif isBackMod ~= nil then
		return {isBackMod, true, 2}
	elseif isLiquid ~= nil then
		return {liquidIndex[isLiquid[1]] or 3, false, 3}
	elseif isTile ~= nil and isTile ~= false then
		return {2, false, 1}
	elseif isBack ~= nil and isBack ~= false then
		return {1, false, 2}
	else
		return {0, false, 0}
	end
end

function die()
	world.setProperty(tostring("GPR Scan List: %s", entity.position()), nil)
end