function init()
  script.setUpdateDelta(3)
  rescuePosition = mcontroller.position()
  --world.logInfo("--- Dumping rescuePosition ---");
  --world.logInfo(dump(rescuePosition))
  --world.logInfo("--- Dumping ENV ---");
  --world.logInfo(dump(_ENV))
  --world.logInfo("--- Dumping self ---");
  --world.logInfo(dump(self))
  --world.logInfo("--- Dumping entity ---");
  --world.logInfo(dump(entity))
  --world.logInfo("--- Dumping world ---");
  --world.logInfo(dump(world))
  --world.logInfo("--- Dumping tech ---");
  --world.logInfo(dump(tech))
end

function update(dt)
  animator.setFlipped(mcontroller.facingDirection() == -1)
  if status.resourcePercentage("health") < 0.099 then
	world.logInfo("Rescuing!")
	mcontroller.setPosition(rescuePosition)
	status.setResourcePercentage("health", 0.100)
  end
  --world.logInfo("Health: " .. status.resourcePercentage("health"))
end

function uninit()
  
end



-- Dumps value as a string
-- 
-- Basic usage: dump(value)
-- e.g. world.logInfo(dump(_ENV))
--
-- @param value The value to be dumped.
-- @param indent (optional) String used for indenting the dumped value.
-- @param seen (optional) Table of already processed tables which will be
--                        dumped as "{...}" to prevent infinite recursion.
function dump(value, indent, seen)
	if type(value) ~= "table" then
		if type(value) == "string" then
			return string.format('%q', value)
		else
			return tostring(value)
		end
	else
		if type(seen) ~= "table" then
			seen = {}
		elseif seen[value] then
			return "{...}"
		end
		seen[value] = true
		indent = indent or ""
		if next(value) == nil then
			return "{}"
		end
		local str = "{"
		local first = true
		for k,v in pairs(value) do
			if first then
				first = false
			else
				str = str..","
			end
			str = str.."\n"..indent.."  ".."["..dump(k).."] = "..dump(v, indent.."  ")
		end
		str = str.."\n"..indent.."}"
		return str
	end
end