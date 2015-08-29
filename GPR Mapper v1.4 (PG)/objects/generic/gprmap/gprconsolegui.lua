--CORE--

function init()
	dir = {}
	dir.cWise = {["up"] = "right", ["right"] = "down", ["down"] = "left", ["left"] = "up"}
	dir.cCWise = {["up"] = "left", ["right"] = "up", ["down"] = "right", ["left"] = "down"}
	dir.vecs = {["up"] = {0,1}, ["right"] = {1,0}, ["down"] = {0,-1}, ["left"] = {-1,0}}
	dir.back = {["up"] = "down", ["right"] = "left", ["down"] = "up", ["left"] = "right"}
	self.colorScheme = {
	[2] = {100, 100, 100, 255}, 
	[1] = {240, 240, 240, 255}, 
	[3] = {7, 0, 153, 255},
	[4] = {55, 198, 201, 255},
	[5] = {240, 40, 0, 1255},
	[6] = {0, 150, 15, 255},
	[7] = {120, 0, 120, 255},
	["grass"] = {40,240,40,255},
	["aegisalt"] = {44, 125, 23, 255},
	["coal"] = {12, 23, 39, 255},
	["copper"] = {201,118,72, 255},
	["corefragment"] = {255, 89, 0, 255},
	["crystal"] = {56, 145, 183, 255},
	["diamond"] = {58, 207, 254,255},
	["gold"] = {204, 162, 46, 255},
	["iron"] = {109, 75, 64, 255},
	["platinum"]= {211,211,207,255},
	["plutonium"] = {206, 14, 190, 255},
	["rubium"] = {196, 37, 58, 255},
	["silverore"] = {206, 207, 219, 255},
	["solarium"] = {237, 223, 30, 255},
	["titanium"]={201, 177, 211, 255},
	["uranium"]= {9, 186, 9, 255},
	["violium"] = {91, 1, 155, 255},
	["player"] ={ 255, 255, 255,255},
	["monster"] ={255, 0, 0, 255},
	["npc"] = {174, 0, 255, 255},
	["chest"] = {40,240,40,255},
	["pod"] = {230, 30, 230, 255},
	["challengedoor"] = {100, 230, 220, 255},
	["trap"] = {230, 200, 0, 255}
	}
	self.modNames = {
	["aegisalt"] = "Aegisalt Ore",
	["aliengrass"] = "Freaky Alien Grass",
	["adridgrass"] = "Arid Grass",
	["ash"] = "Ash",
	["blackash"] = "Black Ash",
	["bone"] = "Bone",
	["charredgrass"] = "Charred Grass",
	["coal"] = "Coal",
	["copper"] = "Copper Ore",
	["corefragment"] = "Core Fragments",
	["crystal"] = "Crystal",
	["crystalgrass"] = "Shiny Crystal Grass",
	["diamond"] = "Diamonds!",
	["fleshgrass"] = "Eew, Flesh Grass",
	["fossil"] = "A Fossil",
	["gold"] = "Gold Ore",
	["grass"] = "Grass",
	["heckgrass"] = "Dammned Grass",
	["hivegrass"] = "Hive Grass",
	["iron"] = "Iron Ore",
	["junglegrass"] = "Jungle Grass",
	["lead"] = "Lead",
	["metal"] = "Metal",
	["moonstone"] = "Moonstone",
	["platinum"] = "Platinum Ore",
	["plutonium"] = "Plutonium",
	["prislite"] = "Prislite",
	["roots"] = "Roots",
	["rubium"] = "Rubium Ore",
	["sand"] = "Sand",
	["savannahgrass"] = "Savannah Grass",
	["silverore"] = "Silver Ore",
	["snow"] = "Snow",
	["solarium"] = "Solarium Ore",
	["sulphur"] = "Sulphur",
	["tar"] = "Tar",
	["tentaclegrass"] = "Tentacle Grass",
	["tilled"] = "Tilled Dirt",
	["thickgrass"] = "Thick Grass",
	["titanium"] = "Titanium",
	["trianglium"] = "Trianglium",
	["undergrowth"] = "Undergrowth",
	["uranium"] = "Uranium Ore",
	["violium"] = "Violium Ore",
	["player"] = "A Player",
	["monster"] = "A Monster",
	["npc"] = "An NPC",
	["chest"] = "A Chest",
	["pod"] = "A Pod",
	["challengedoor"] = "A Challenge Door"
	}
	inputKeys = {
    left = 276,
    right = 275,
    up = 273,
    down = 274,
    w = 119,
    a = 97,
    s = 115,
    d = 100,
	space = 32
    }
	self.scanMatrix = nil
	self.polyList = nil
	self.baseBounds = {-195, -105, 195, 105}
	self.bounds = {-195, -105, 195, 105}
	self.baseCenter = {195, 105}
	self.center = {195, 105}
	self.currentPans = {0, 0}
	self.panDistance = {130, 70}
	self.maxPans = 25
	adjustedBounds = {self.bounds[3] - self.bounds[1], self.bounds[4] - self.bounds[2]}
	self.modPositions = {}
	self.entityPositions = {}
	self.lockInput = true
	self.entityScanCooldown = 0
	self.toolTip = {"coal", {195,105}, 0}
	--world.callScriptedEntity(console.sourceEntity(), "doScan", self.bounds)
	world.sendEntityMessage(console.sourceEntity(), "doScan", self.bounds)
	script.setUpdateDelta(2)
	drawCanvas()	
end

function update(dt)
	if self.polyList == nil and world.entityPosition(console.sourceEntity())~= nil then
		self.scanMatrix = world.getProperty(tostring("GPR Scan List: %s", world.entityPosition(console.sourceEntity())))
		if self.scanMatrix ~= nil then 
			--world.logInfo("Matrix Downloaded")
			--world.callScriptedEntity(console.sourceEntity(), "purgeGlobalStorage")
			world.sendEntityMessage(console.sourceEntity(), "purgeGlobalStorage")
			self.polyList = {}
			makePolyList()
			--world.logInfo("%s", #self.polyList)
			self.scanMatrix = nil
			self.lockInput = false
			script.setUpdateDelta(60)
		end
	end
	if self.entityScanCooldown == 0 then
		self.entityScanCooldown = 0
		entityScan()
	else
		self.entityScanCooldown = self.entityScanCooldown - 1
	end
	drawCanvas()
end

--CANVAS

function canvasClickEvent(position, button, isButtonDown)
	if not isButtonDown then
		--world.logInfo("click")
		for i,j in ipairs(self.entityPositions) do
			if vec2.mag(vec2.sub(position, j[2])) < 4 then
				--world.logInfo(j[1])
				self.toolTip = {j[1], position, 2} 
				drawTip()
				return nil
			end
		end
		for i,j in ipairs(self.modPositions) do
			if vec2.mag(vec2.sub(position, {j[1],j[2]})) < 4 then
				--world.logInfo(j[3])
				self.toolTip = {j[3], position, 2} 
				drawTip()
				return nil
			end
		end
	end
end

function canvasKeyEvent(key, isKeyDown)
	if not isKeyDown and not self.lockInput then
		if key == inputKeys.down or key == inputKeys.s and self.bounds[2] > self.baseBounds[2] - self.maxPans * self.panDistance[2] and world.entityPosition(console.sourceEntity())[2] + self.bounds[2] > 100 then
			panView("down")
		elseif key == inputKeys.left or key == inputKeys.a and self.bounds[1] > self.baseBounds[1] - self.maxPans * self.panDistance[1] then
			panView("left")
		elseif key == inputKeys.up or key == inputKeys.w and self.bounds[4] < self.baseBounds[4] + self.maxPans * self.panDistance[2] and self.polyList ~= {} then
			panView("up")
		elseif key == inputKeys.right or key == inputKeys.d and self.bounds[3] < self.baseBounds[3] + self.maxPans * self.panDistance[1] then
			panView("right")
		elseif key == inputKeys.space then
			panView("center")
		end
	end
end

function panView(direction)
	self.scanMatrix = nil
	self.polyList = nil
	self.lockInput = true
	self.modPositions = {}
	self.entityPositions = {}
	self.toolTip = {"coal", {195,105}, 0}
	if direction == "left" then
		self.bounds = {self.bounds[1] - self.panDistance[1], self.bounds[2], self.bounds[3] - self.panDistance[1], self.bounds[4]}
		self.center = {self.center[1] + self.panDistance[1], self.center[2]}
		self.currentPans = {self.currentPans[1] - 1, self.currentPans[2]}
	elseif direction == "right" then
		self.bounds = {self.bounds[1] + self.panDistance[1], self.bounds[2], self.bounds[3] + self.panDistance[1], self.bounds[4]}
		self.center = {self.center[1] - self.panDistance[1], self.center[2]}
		self.currentPans = {self.currentPans[1] + 1, self.currentPans[2]}
	elseif direction == "up" then
		self.bounds = {self.bounds[1], self.bounds[2] + self.panDistance[2], self.bounds[3], self.bounds[4] + self.panDistance[2]}
		self.center = {self.center[1], self.center[2] - self.panDistance[2]}
		self.currentPans = {self.currentPans[1], self.currentPans[2] + 1}
	elseif direction == "down" then
		self.bounds = {self.bounds[1], self.bounds[2] - self.panDistance[2], self.bounds[3], self.bounds[4] - self.panDistance[2]}
		self.center = {self.center[1], self.center[2] + self.panDistance[2]}
		self.currentPans = {self.currentPans[1], self.currentPans[2] - 1}
	else
		self.bounds = tablecopy(self.baseBounds)
		self.center = tablecopy(self.baseCenter)
		self.currentPans = {0,0}
	end
	world.sendEntityMessage(console.sourceEntity(), "doScan", self.bounds)
	--world.callScriptedEntity(console.sourceEntity(), "doScan", self.bounds)
	drawCanvas(false)
	script.setUpdateDelta(2)
end

function drawCanvas(doLabel)
	if self.polyList ~= nil then
		for i,j in ipairs(self.polyList) do
			console.canvasDrawPoly(j[1], j[2], 1)
		end
		
		console.canvasDrawRect({self.center[1]-1, self.center[2]-1, self.center[1]+1, self.center[2]+3}, self.colorScheme["player"])
		
		if self.modPositions ~= {} then
			for i,j in ipairs(self.modPositions) do
				console.canvasDrawRect({j[1], j[2], j[1]+1, j[2]+1}, colorFromString(j[3]) or {150,255,150,255})
			end
		end
		if self.entityPositions ~= {} then
			for i,j in pairs(self.entityPositions) do
				console.canvasDrawPoly({vec2.add(j[2], {-2, -2}),vec2.add(j[2], {0, 3}),vec2.add(j[2], {2, -2})}, self.colorScheme[j[1]],0.5)
			end
		end
		if self.toolTip ~= nil and self.toolTip[3] > 0 then
			self.toolTip[3] = self.toolTip[3] - 1
			--console.canvasDrawImage("/tiles/mods/"..self.toolTip[1]..".png", vec2.sub(self.toolTip[2], {64, 16}), 1)
			drawTip()
		end
	else
		console.canvasDrawRect({0, 0, adjustedBounds[1]+1, adjustedBounds[2]+1}, {0,0,0,255})
		console.canvasDrawText("LOADING MAP: PLEASE HOLD", {position=vec2.sub(self.baseCenter,{166,-30})}, 25, {255,255,255,255})
	end	
	if doLabel ~= false then
		local sectorText = {"Scanning Sector "..tostring(self.currentPans[1])..","..tostring(self.currentPans[2]),
			"Offset with Distance "..tostring(self.baseCenter[1] - self.center[1]).." X "..tostring(self.baseCenter[2] - self.center[2]).." Y"}
		console.canvasDrawText(sectorText[1], {position={180, 231}}, 8, {200, 200, 200, 255} )
		console.canvasDrawText(sectorText[2], {position={180, 222}}, 8, {117, 117, 117, 255} )
	end
end

function drawTip()
	local toolText = self.modNames[self.toolTip[1]]
	local toolColor = colorFromString(self.toolTip[1])
	local toolConfig = {}
	--if type(root.itemConfig) == "function" then
		-- if toolText == nil then
			-- toolConfig = root.itemType(self.toolTip[1].."ore") 
			-- toolConfig = root.itemConfig(self.toolTip[1].."ore") or {}
			-- toolText = toolConfig.shortdescription
		-- end
		-- if toolText == nil then
			-- toolConfig = root.itemConfig(self.toolTip[1]) or {}
			-- toolText = toolConfig.shortdescription
		-- end
	--end
	if toolText == nil then toolText = self.toolTip[1] end
	if toolColor == nil then toolColor = colorFromString(toolText) or {255,255,255,255} end 
	local backTipBorder = {230,230,230,255}
	local backTipColor = {0,0,0,255}
	if toolColor[1] + toolColor[2] + toolColor[3] < 220 then 
		backTipBorder = {90,90,90,255}
		backTipColor = {200,200,200,255}
	end
	console.canvasDrawRect({1, 189, 122, 210}, backTipBorder)
	console.canvasDrawRect({3, 191, 120, 208}, backTipColor)
	console.canvasDrawText(toolText, {position = {8, 204}, centered = true}, 10, toolColor)
end

function colorFromString(text)
	local outColor = self.colorScheme[text]
	if outColor == nil then
		local tempByte = 0
		outColor = {0,0,0,255}
		for i=1,3 do
			tempByte = math.max(math.min(string.byte(text, i) or 110, 122), 97) - 97
			tempByte = tempByte + math.max(math.min(string.byte(text, i+1) or 110, 122), 97) - 97
			outColor[i] = math.floor(math.max(math.min(tempByte*5, 255), 0))
		end
		for x = 1, 14 do
			if outColor[1] + outColor[2] + outColor[3] > 70 then break end
			local index = math.random(3)
			outColor[index] = outColor[index] + 5
		end
		self.colorScheme[text] = outColor
	end
	return outColor
end

--POLY MANIPULATION

function makePolyList()
	for x = 1, adjustedBounds[1] do
		for y=1, adjustedBounds[2] do
			if type(self.scanMatrix[x][y][1]) == "string" then 
				table.insert(self.modPositions, {x+self.baseBounds[1]+self.baseCenter[1], y+self.baseBounds[2]+self.baseCenter[2], self.scanMatrix[x][y][1]})
			elseif type(self.scanMatrix[x][y][1]) == "number" and self.scanMatrix[x][y][1] ~= 0 and not self.scanMatrix[x][y][2] then craftPoly(x,y,self.scanMatrix[x][y][1])
			end
		end
	end
end

function craftPoly(x, y, iType)
	local timeout = 0
	local pos = {x, y}
	local outPoly = {vec2.add(vec2.add(pos, {self.baseBounds[1], self.baseBounds[2]}), self.baseCenter)}
	local loopComplete = false
	local direction = traceEdge(pos, self.scanMatrix[pos[1]][pos[2]][3], nil)
	local newDirection = nil
	if direction ~= nil then
		while timeout < 20000 do
			self.scanMatrix[pos[1]][pos[2]][2] = true
			pos = vec2.add(pos, dir.vecs[direction])
			if vec2.mag(vec2.sub({x, y}, pos)) == 0 then 
				break 
			end
			newDirection = traceEdge(pos, self.scanMatrix[pos[1]][pos[2]][3], direction)
			if newDirection ~= direction then 
				table.insert(outPoly, vec2.add(vec2.add(pos, {self.baseBounds[1], self.baseBounds[2]}),self.baseCenter)) 
			end
			direction = newDirection
			timeout = timeout + 1 
		end
		outPoly = {outPoly, self.colorScheme[iType]}
		--world.logInfo("%s", outPoly)
		table.insert(self.polyList, outPoly)
	end
end

function traceEdge(pos, iLayer, inVec)
	local left = true
	local up = true
	local right = true
	local down = true
	if pos[1] > 1 then
		left = tryBoundary(iLayer, self.scanMatrix[pos[1]-1][pos[2]][3])
	end
	if pos[2] < adjustedBounds[2] then
		up = tryBoundary(iLayer, self.scanMatrix[pos[1]][pos[2]+1][3])
	end
	if pos[1] < adjustedBounds[1] then
		right = tryBoundary(iLayer, self.scanMatrix[pos[1]+1][pos[2]][3])
	end
	if pos[2] > 1 then
		down = tryBoundary(iLayer, self.scanMatrix[pos[1]][pos[2]-1][3])
	end
	if inVec == nil then 
		if not up and left then return "up" elseif not right and up then return "right" elseif not down and right then return "down" elseif not left and down then return "left" else return nil end
	elseif inVec == "up" then
		if not left then return "left" elseif not up then return "up" elseif not right then return "right" else return "down" end 
	elseif inVec == "right" then
		if not up then return "up" elseif not right then return "right" elseif not down then return "down" else return "left" end 
	elseif inVec == "down" then
		if not right then return "right" elseif not down then return "down" elseif not left then return "left" else return "up" end 
	elseif inVec == "left" then
		if not down then return "down" elseif not left then return "left" elseif not up then return "up" else return "right" end 
	end
end

function tryBoundary(a, b)
	if a == b then return false
	elseif type(a) == "string" and type(b) == "string" then return false
	elseif type(a) == "string" and b == 2 then return false
	elseif a == 2 and type(b) == "string" then return false
	else return true
	end
end

--OTHER

function entityScan()
	--world.callScriptedEntity(console.sourceEntity(), "loadWithinBounds", self.bounds)
	world.sendEntityMessage(console.sourceEntity(), "loadWithinBounds", self.bounds)
	self.entityPositions = {}
	local entityList = world.entityQuery({self.bounds[1]+world.entityPosition(console.sourceEntity())[1], 
		self.bounds[2]+world.entityPosition(console.sourceEntity())[2]}, 
		{self.bounds[3]+world.entityPosition(console.sourceEntity())[1],
		self.bounds[4]+world.entityPosition(console.sourceEntity())[2]})
	local entityType = nil
	
	for i,j in pairs(entityList) do
		entityType = world.entityType(j)
		if self.colorScheme[entityType] ~= nil then
			table.insert(self.entityPositions, {entityType, vec2.add(world.distance(world.entityPosition(j), world.entityPosition(console.sourceEntity())), self.center)})
		elseif entityType == "object" then 
			entityType = world.objectConfigParameter(j, "objectName")
			if string.find(entityType, "chest") ~= nil or string.find(entityType, "Chest") ~= nil then
				table.insert(self.entityPositions, {"chest", vec2.add(world.distance(world.entityPosition(j), world.entityPosition(console.sourceEntity())), self.center)})
			elseif entityType == "statuspod" or string.find(entityType, "dungeonpod") ~= nil then
				table.insert(self.entityPositions, {"pod", vec2.add(world.distance(world.entityPosition(j), world.entityPosition(console.sourceEntity())), self.center)})
			elseif entityType == "challengedoor" or string.find(entityType, "challengedoor") then
				table.insert(self.entityPositions, {"challengedoor", vec2.add(world.distance(world.entityPosition(j), world.entityPosition(console.sourceEntity())), self.center)})
			end
		end
	end
end

--UTILITY

function tablecopy(input)
	if input == nil then return nil end
	if type(input) ~= "table" then 
		local newinput = input
		return newinput 
	end
	local newtab = {}
	for i,j in pairs(input) do
		newtab[i] = tablecopy(j)
	end
	return newtab
end