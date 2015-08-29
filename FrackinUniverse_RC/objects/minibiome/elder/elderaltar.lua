local contents
 
function init(args)
	if self.craftDelay == nil then
		self.craftDelay = 4
	end
	if self.mythosType == nil then
		self.mythosType = "eldertome"
	end
end
 
 
 
function elderCheck()
    local contents = world.containerItems(entity.id())
	self.doElder = false
	if contents[3].name == "nutrientpaste" then
			self.mythosType = "elderrelic2"
			self.doElder = true
	end
	if contents[3].name == "preciouscomb" then
			self.mythosType = "honeyjar"
			self.doElder = true
	end
	if contents[3].name == "junglecomb" then
			self.mythosType = "honeyjar"
			self.doElder = true
	end
	if contents[3].name == "forestcomb" then
			self.mythosType = "honeyjar"
			self.doElder = true
	end
	if contents[3].name == "morbidcomb" then
			self.mythosType = "redhoneyjar"
			self.doElder = true
	end
	if contents[3].name == "mooncomb" then
			self.mythosType = "honeyjar"
			self.doElder = true
	end
	if contents[3].name == "coppercomb" then
			self.mythosType = "honeyjar"
			self.doElder = true
	end
	if contents[3].name == "ironcomb" then
			self.mythosType = "honeyjar"
			self.doElder = true
	end
	if contents[3].name == "silvercomb" then
			self.mythosType = "honeyjar"
			self.doElder = true
	end
	if contents[3].name == "goldcomb" then
			self.mythosType = "honeyjar"
			self.doElder = true
	end
	if contents[3].name == "titaniumcomb" then
			self.mythosType = "honeyjar"
			self.doElder = true
	end
	if contents[3].name == "aridcomb" then
			self.mythosType = "honeyjar"
			self.doElder = true
	end
	if contents[3].name == "redcomb" then
			self.mythosType = "redhoneyjar"
			self.doElder = true
	end
	if contents[3].name == "arcticcomb" then
			self.mythosType = "snowhoneyjar"
			self.doElder = true
	end
	if contents[3].name == "solariumcomb" then
			self.mythosType = "solariumhoneyjar"
			self.doElder = true
	end
	if contents[3].name == "mythicalcomb" then
			self.mythosType = "mythicalhoneyjar"
			self.doElder = true
	end
	if contents[3].name == "flowercomb" then
			self.mythosType = "floralhoneyjar"
			self.doElder = true
	end
	if contents[3].name == "minercomb" then
			self.mythosType = "honeyjar"
			self.doElder = true
	end
	if contents[3].name == "volcaniccomb" then
			self.mythosType = "hothoneyjar"
			self.doElder = true
	end
	if contents[3].name == "godlycomb" then
			self.mythosType = "mythicalhoneyjar"
			self.doElder = true
	end
	if contents[3].name == "nocturnalcomb" then
			self.mythosType = "nocturnalhoneyjar"
			self.doElder = true
	end
	if contents[3].name == "plutoniumcomb" then
			self.mythosType = "plutoniumhoneyjar"
			self.doElder = true
	end
	if contents[3].name == "radioactivecomb" then
			self.mythosType = "radioactivehoneyjar"
			self.doElder = true
	end
	return self.mythosType
end
 
function update(dt)
    contents = world.containerItems(entity.id())
        if not contents[2] then
                return
        end
        if not contents[3] then
                return
        end
	if contents[3] and contents[2] then
		processElder()
	end
end
 
function processElder()
    elderCheck()
	if self.doElder == true then
		if self.craftDelay > 0 then
			self.craftDelay = self.craftDelay - 1
		elseif self.craftDelay <= 0 then
			self.craftDelay = 2
		end
	else
		return nil
	end
	if self.doElder == true then 
	if self.craftDelay == 1 then
		if world.containerConsume(entity.id(), { name= contents[3].name, count = 1, data={}}) == true and
			world.containerConsume(entity.id(), { name= contents[3].name, count = 1, data={}}) == true then
			world.containerAddItems(entity.id(), { name= self.mythosType, count = 1, data={}})
		end
	else
		return
	end
	end
end