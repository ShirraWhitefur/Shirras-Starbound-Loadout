Experiment #1:
Here I wanted to make the pet chooseable this basically involved figuring out how the pet spawned.
Ended up finding out the pet spawner script was attached to the tech station.
Though simply moving the pet spawner script was not enough. 

As you may notice if you moved only the pet spawner script and made no changesevery time you destroy and place the object a different type of pet would spawn.
In order to combat this I stored the pet.params upon uninitalization of the object.
That way the same pet would spawn each time. 

Experiment #2: 
Here I wanted the pet to sleep in their own pet Spawner.
This was made unncessarily difficult because of the random naming convention
where some pets include the word pet while some don't. 
Also my Pet Houses followed a separate naming convention where the first letter of the pet is capitalized. (not too smart on my part) 

In order to tackle this I needed to do some fancy string manipulation. 
monType = world.monsterType(entity.id())
	if string.find(monType, "pet") then
		monType = string.sub(monType,4)
		monType = string.gsub(monType,"^%l",string.upper)
		monType = "pethouse"..monType
	else
		monType = string.gsub(monType,"^%l",string.upper)
		monType = "pethouse"..monType
	end
	
the first thing I needed to do was get the monster type of the pet before manipulating it.
now I had to first find out if the word pet was even in the name.
Thankfully CF kept all the pets in the beginning of the word and not mix and matched it where some are in the front and some are in the back.
Which meant I only needed to "confirm" the word pet existed. 
As you may remember from the Lua tutorials if the value is not 0 or nil it is always true. So I really did not care what the value of the location was.
I only cared if the value was true or not. 

So if the value was true, I needed to remove the word pet.
Next I needed to capitalize the first letter of the word in all cases.
finally I needed to concatenate the word pethouse with the new capitalized pet name. 


