local contents
 
function init(args)
	if self.craftDelay == nil then
		self.craftDelay = 2
	end
 	if itemchance1 == nil then 
		itemchance1 = 1
	end
	rarestitem = 0.30
	rareitem = 0.35
	uncommonitem = 0.60
	normalitem = 0.70	
	commonitem = 0.80
end
 
 
 
function deciding()
    contents = world.containerItems(entity.id())
		self.dualOutput = false
		self.comboutput1 = contents[5].name
		itemchance1 = 1
		if contents[5].name == "godlycomb" then
			self.comboutput1 = "matteritem"
			itemchance1 = rareitem
		end
		if contents[5].name == "normalcomb" then
			self.comboutput1 = "waxchunk"
			itemchance1 = commonitem
		end
		if contents[5].name == "preciouscomb" then
			self.comboutput1 = "diamond"
			itemchance1 = rarestitem
		end
		if contents[5].name == "nocturnalcomb" then
			self.comboutput1 = "waxchunk"
			itemchance1 = commonitem
		end
		if contents[5].name == "aridcomb" then
			self.comboutput1 = "goldensand"
			itemchance1 = commonitem
		end
		if contents[5].name == "redcomb" then
			self.comboutput1 = "redwaxchunk"
			itemchance1 = commonitem
		end
		if contents[5].name == "junglecomb" then
			self.comboutput1 = "goldenleaves"
			itemchance1 = commonitem
		end
		if contents[5].name == "minercomb" then
			self.comboutput1 = "coalore"
			itemchance1 = uncommonitem
		end
		if contents[5].name == "arcticcomb" then
			self.comboutput1 = "frozenwaxchunk"
			itemchance1 = normalitem
		end
		if contents[5].name == "mythicalcomb" then
			self.comboutput1 = "liquidhealing"
			itemchance1 = rareitem
		end
		if contents[5].name == "radioactivecomb" then
			self.comboutput1 = "uraniumore"
			itemchance1 = rareitem
		end
		if contents[5].name == "plutoniumcomb" then
			self.comboutput1 = "plutoniumore"
			itemchance1 = rareitem
		end
		if contents[5].name == "solariumcomb" then
			self.comboutput1 = "solariumore"
			itemchance1 = rareitem
		end
		if contents[5].name == "suncomb" then
			self.comboutput1 = "sulphur"
			itemchance1 = rareitem
		end
		if contents[5].name == "silkcomb" then
			self.comboutput1 = "beesilk"
			itemchance1 = uncommonitem
		end
		if contents[5].name == "volcaniccomb" then
			self.comboutput1 = "liquidlava"
			itemchance1 = uncommonitem
		end
		if contents[5].name == "forestcomb" then
			self.comboutput1 = "goldenwood"
			itemchance1 = commonitem
		end
		if contents[5].name == "morbidcomb" then
			self.comboutput1 = "ghostlywax"
			self.comboutput2 = "bees_bonedust"
			itemchance1 = commonitem
			itemchance2 = normalitem
			self.dualOutput = true
			return
		end
		if contents[5].name == "mooncomb" then
			self.comboutput1 = "hematite"
			itemchance1 = uncommonitem
		end
		if contents[5].name == "flowercomb" then
			if math.random(3) == 1 then
				self.comboutput1 = "petalred"
				itemchance1 = commonitem
			end
			if math.random(3) == 2 then
				self.comboutput1 = "petalyellow"
				itemchance1 = commonitem
			end
			if math.random(3) == 3 then
				self.comboutput1 = "petalblue"
				itemchance1 = commonitem
			end
		end
		if contents[5].name == "coppercomb" then
			self.comboutput1 = "copperore"
			itemchance1 = rareitem
		end
		if contents[5].name == "ironcomb" then
			self.comboutput1 = "ironore"
			itemchance1 = rarestitem
		end
		if contents[5].name == "silvercomb" then
			self.comboutput1 = "silverore"
			itemchance1 = rarestitem
		end
		if contents[5].name == "goldcomb" then
			self.comboutput1 = "goldore"
			itemchance1 = rarestitem
		end
		if contents[5].name == "titaniumcomb" then
			self.comboutput1 = "titaniumore"
			itemchance1 = rarestitem
		end
end
 
function update(dt)
        contents = world.containerItems(entity.id())
        if not contents[5] then
				entity.setAnimationState("centrifuge", "idle")
                return
        end
	if contents[5] then
        deciding()
		workingCombs()
		entity.setAnimationState("centrifuge", "working")
	end
end
 
function workingCombs()
	if self.craftDelay > 0 then
		self.craftDelay = self.craftDelay - 1
	elseif self.craftDelay <= 0 then
		self.craftDelay = 2
	end
	
	if self.craftDelay == 1 then
		world.containerConsume(entity.id(), { name= contents[5].name, count = 1, data={}})
		if math.random(100)/100 <= itemchance1 then
			world.containerAddItems(entity.id(), { name= self.comboutput1, count = 1, data={}})
		end
		if 	self.dualOutput == true then
			if math.random(100)/100 <= itemchance2 then
				world.containerAddItems(entity.id(), { name= self.comboutput2, count = 1, data={}})
			end
		end
	else
		return
	end
end