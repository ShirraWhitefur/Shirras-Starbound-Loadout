# CLeF - Things To Do In Starbound
Starbound content restoration and gameplay overhaul project

Version 53 (2015/08/28) DEVELOPMENT BUILD
----------

Known to work with:
- [Stable] Pleased Giraffe (August 26)
- [Nightly] Glad Giraffe (August 26)


Installation
------------

Warning! If you have previous version installed, please delete any directories or .modpak files which match "cl*f*" pattern.

Copy the following directories into "starbound/giraffe_storage/mods/" directory:

Required:

+ CLeF - Common. Core mod files common for all supported game versions

Optional (consult "Gameplay changes" section for details):

+ CLeF - Extra. Core mod files incompatible/overlapping functionality with third-parties

+ CLeF - Sandbox. Restores more sandbox gameplay, yet also removes certain restrictions (some people might find it "cheaty"). Strongly recommended for people who like Koala builds over Giraffe


Overview
--------

Are you looking for sandbox gameplay? You've come to the right place.

CF has severely crippled Starbound in Giraffe "updates" and removed as much that associated it with Terraria as they could. Hence, this modification was born.

CLeF is a community effort to address and revert most of unwanted changes, as well as introduce balance tweaks, enhancements and a good portion of entirely new content. ;) It also addresses the poor game's performance on relatively slow hardware and improves it.

Please take a couple of minutes to read the list of changes this mod has to offer. Also, see the full list of authors and included mods at the end of the description.


Frequently Asked Questions
--------------------------

Q: Will you add back Temperature and Hunger mechanics?

A: There are two separate mods which do this:

* http://community.playstarbound.com/resources/2953/ - Hunger & Thirst (by Image_Not_Available)

* http://community.playstarbound.com/resources/2475/ - Temperature Returns (by xxswatelitexx)

Sadly, I can't permanently add them to CLeF, because, once installed, they cannot be uninstalled without the entire savegame wipe. Also, the temperature mod have no means of displaying the required data, since the game's UI lacks of custom HUD indication support.


Q: So, I've repaired my ship and decided to move to another planet in the local system. I'm clicking "GO" and nothing happens.

A: You'll have to fuel your ship first (lava, coal, core fragment ore or even oil will do the trick). Please keep in mind the intraspace travel is no longer free. The fuel cost simply doesn't show up on Tier 2 ships (without repaired FTL drive) due to a bug.


Q: I can't access fuel hatch! My character has stuck at his starter planet! I was playing as custom race.

A: It's impossible for me to fix custom races due to random mod load order and the fact .png definition files cannot be incrementally patched. Please ask the author of that race to move working fuel hatch from Tier 3 ship to Tier 2 (I've asked some of them, and you can find their races in "Recommended mods" section).

Also, you can fix it on your own - open <racename>t2blocks.png and copy fuel hatch pixel (orange-red at the top of a blue block) from <racename>t3blocks.png. Note you'll have to delete your shipworld, otherwise the fix won't be applied (don't forget to take everything you don't want to lose with you).


Q: Wait, a single pixel change? Wouldn't this affect vanilla progression?

A: Yes, it is a single pixel change, which does not affect progression in any way. Even if player will have working fuel hatch, he won't be able to travel past the local solar system, because FTL drive is not working at Tier 2 ship regardless if fuel hatch is available or not.

Besides, Chucklefish might change their mind regarding the fuel and you'll be forced to make that single pixel change anyway.


Q: Okay, I beat the UFO boss. Where's the rest of the quests?

A: The rest of the quests are integrated into Outpost NPC's questlines:

* [Added in v22] Bone Dragon boss is integrated into Outpost Mute Glitch's quest line.

* [Added in v42] Jelly boss is integrated into Outpost Apex Scientist's quest line.

* [Added in v48] Fatal Circuit robot boss is integrated into Outpost Glitch Mercenary's and Penguin Promoter's quest lines.

This mod is work-in-progress. Please be patient.


Q: Will I be able to play on vanilla servers if I'll install this mod?

A: Short answer: no. Long answer: any mod which makes changes to .config files or adds new objects will not be compatible with vanilla servers.


Q: What's with the name? Are you telling us to choke the developers?

A: It's both pun and an allegory. The fish is already dead.


Help wanted
-----------

I have little to no knowledge in Lua, so this prevents me from re-implementing lots of things. I would really appreciate your help.

Also, if you've noticed another feature, object or armor that was removed by Chucklefish and want it back, please tell me immediately!


Known bugs
----------

+ The game prevents patching of items/defaultparameters.config, hence a complete replacement file is used instead. CLeF will conflict with any mods that replace it.

+ CLeF will conflict with any mod which adds "learnBlueprintsOnPickup" variable to items/objects. The solution is to move the above-mentioned variable from CLeF and insert contents of variable into problematic mod's patch.


Glossary
--------

* [N] - new feature / addon
* [M] - modified restoration
* [R] - restored feature
* [F] - fix


Gameplay changes
----------------

+ [N] Liquid Slime can be harvested and placed. Also replaced Slime status effect icon to match the style of new liquid item

+ [M] Green Slime can be crafted from 2 Liquid Slime in Crafting Table

+ [R] Restored Alien Juice liquid definition (id:4) and liquid item

+ [R] Restored Liquid Nitrogen definitions (id:10)

+ [N] Implemented more liquid interactions (also added all interactions from Lava to Core lava. Yes, you can harvest it too):

 - Healing Water + Water => Healing Water
 - Healing Water + Poison => Water
 - Healing Water + Erchius Fuel => Water
 - Swamp Water + Water => Swamp Water
 - Swamp Water + Poison => Poison
 - Swamp Water + Healing Water => Water
 - Alien Juice + Water => Alien Juice
 - Alien Juice + Poison => Alien Juice
 - Alien Juice + Tar => Alien Juice
 - Alien Juice + Healing Water => Alien Juice
 - Alien Juice + Milk => Alien Juice
 - Alien Juice + Coffee => Alien Juice
 - Alien Juice + Erchius Fuel => Alien Juice
 - Alien Juice + Swamp Water => Alien Juice
 - Liquid Slime + Water => Liquid Slime
 - Liquid Slime + Poison => Liquid Slime
 - Liquid Slime + Tar => Liquid Slime
 - Liquid Slime + Healing Water => Liquid Slime
 - Liquid Slime + Alien Juice => Liquid Slime
 - Liquid Slime + Milk => Liquid Slime
 - Liquid Slime + Coffee => Liquid Slime
 - Liquid Slime + Erchius Fuel = Liquid Slime
 - Liquid Slime + Swamp Water => Liquid Slime
 - (Core) Lava + Healing water => Magma rock
 - (Core) Lava + Alien juice => Magma rock
 - (Core) Lava + Poison => Magma rock
 - (Core) Lava + Coffee => Magma rock
 - (Core) Lava + Swamp water => Magma rock
 - (Core) Lava + Liquid Slime => Magma rock

+ [M] Renamed "Coffee Seed" into "Raw Coffee Beans". You can roast them in Microwave or Campfire and get consumable "Coffee Beans"

+ [F] Blocks of Erchius Crystals will drop Erchius Crystals (instead of placeholder crystals)

+ [F] Toy (Lego) Blocks no longer fall when placed. Now it's possible to build colourful plastic castles

+ [F] Book Blocks act like platforms and can be passed through

+ [M] Recoloured Titanium Ore and Titanium Bars to be more distinguishable from Silver and Iron

+ [R] Diamond ore will spawn instead of "perfectly cut" diamonds in unvisited worlds (diamonds will still spawn in treasure chests)

+ [M] Diamond can be crafted in Alloy Furnace from 2 diamond ores (recipe learned on picking up the diamond ore, was 4 diamond ores in EK and removed entirely in UG)

+ [R] Stone Axe, Stone Pickaxe and Stone Hoe can be crafted at Crafting Table. Note that Stone Pickaxe cannot be repaired.

+ [N] Emerald Ore will spawn in previously unvisited worlds with the same conditions as Diamond Ore, including the Rock Deposites and treasure chests

+ [N] Emerald can be crafted from 2 Emerald Ore in Alloy Furnace

+ [N] Emerald Glass can be crafted from 2 Fine Sand (or Sand) blocks and 1 Emerald Ore in Alloy Furnace (material id: 8764)

+ [N] Emerald Block can be crafted from 2 Emeralds (or 4 Emerald Ore) in Crafting Table (material id: 8766)

+ [N] Emerald Drill and Emerald Pickaxe can be crafted from Emeralds in Metalwork Station and the Replicator (Sci-Fi Anvil)

+ [N] Dread Block can be crafted from 2 Dreadwing Wreckage (material id: 8767)

+ [N] Hi-tech Drill and Hi-tech Pickaxe can be crafted from Dreadful Blocks in Metalwork Station and the Replicator (Sci-Fi Anvil)

+ [R] Restored pickaxe crafting recipes

+ [R] All pickaxes (except Stone Pickaxe) and drills have EK's durability values (which means they won't break so fast), block radius, tile damage and material costs (except pixel requirements):
 - Copper Drill     (d: 1000 -> 3000, b: 2 -> 3, d: 1.5 -> 2.9)
 - Silver Drill     (d: 1000 -> 3500, b: 2 -> 3, d: 2.0 -> 3.1)
 - Golden Drill     (d: 1000 -> 4000, b: 2 -> 3, d: 2.5 -> 3.3)
 - Diamond Drill    (d: 1000 -> 4500, b: 2 -> 3, d: 3.5 -> 3.7)
 - Emerald Drill    (d: 5000, b: 3, d: 4.0)
 - Platinum Drill   (d: 1000 -> 5500, b: 2 -> 3, d: 3.0 -> 4.3)
 - Hi-tech Drill    (d: 6000, b: 4, d: 5.0)
 - Stone Pickaxe    (d: 3500, b: 3, d: 2.0, cannot be repaired)
 - Copper Pickaxe   (d:  200 -> 4000)
 - Silver Pickaxe   (d:  200 -> 4500)
 - Golden Pickaxe   (d:  200 -> 5000)
 - Diamond Pickaxe  (d:  350 -> 5500)
 - Emerald Pickaxe  (d: 6000)
 - Platinum Pickaxe (d: 200 -> 6500)
 - Hi-tech Pickaxe  (d: 9001, b: 4, d: 4.2)

+ [R] Drills and pickaxes can be repaired with bars, ore and diamonds (open your inventory, equip tool, select ore/bar/diamond and right-click on the tool icon)

+ [R] Restored unique look for Wire Tool and Paint Tool

+ [N] Chainsaw can be crafted via Metalwork Station for 6 Durasteel Bar and 12 Steel Bar

+ [N] Core fragment ore can be crafted in Alloy Furnace from 10 Lava and 1 Oil (recipe learned on picking the Lava)

+ [N] Molten Core can be crafted from 2 iron bars and 10 core fragments (the recipe added to stone furnace upon pickup, originally was dropped by UFO boss in EK)

+ [R] Metalwork station requires 1 Molten Core to craft (same as in EK)

+ [M] Portable 3D Printer can be crafted at Research Station for 2000 pixels, 10 durasteel bars and 2 diamonds (was removed in UG)

+ [M] Added Old Stone Furnace and Old Alloy Furnace (unlike the UG's workbench-based versions, these are container-based and significantly cheaper)

+ [R] Coal can be crafted from 10 Unrefined Wood in Stone Furnace (recipe learned on picking up the Wood)

+ [N] Erchius Crystal can be crafted from 8 Liquid Erchius Fuel and 1 Diamond in Alloy Furnace (recipe learned on picking up the Erchius Fuel)

+ [N] Core fragment gives 10 points of fuel (seriously, what that pile of blasted glowing stones is even good for?!)

+ [N] Erchius Crystal gives 10 points of fuel (same as above)

+ [N] Oil gives 1 point of fuel (it's flammable IRL, so why not?)

+ [N] Lava gives 1 point of fuel (because it's basically the source of core fragments)

+ [R] Coal gives 2 points of fuel (same as in EK, 0 in UG)

+ [N] Teleporter Core can be crafted from 2 Iron Bars and 3 Diamonds

+ [M] All vanilla teleporters from "2-Stop Teleshop" can be crafted via Iron Crafting Table. Each requires 1 Teleporter Core and 1 Circuit board to craft (also, all of them can be safely placed and removed without object's destruction. Also included proper descriptions for each teleporter type). Other requirements vary:

 - Executive  : 3 Diamonds, 6 Durasteel Bars and 6 Glass Blocks
 - Brass      : 2 Diamonds, 10 Liquid Oil, 5 Copper Bars and 4 Glass Blocks
 - Futuristic : 2 Diamonds, 6 Silver Bars and 6 Glass Blocks
 - Scientific : 5 Steel Bars, 5 Durasteel Bars and 2 Glass Blocks
 - Stone      : 25 Cobblestone and 2 Glass Blocks
 - Tomb       : 10 Golden Bars, 4 Rubium Ore and 2 Glass Blocks
 - Wooden     : 1 Diamond, 50 Wood Planks, 3 Steel Bars and 2 Glass Blocks

+ [N] Orange Teleporter Core can be crafted from 2 Iron Bars, 4 Core Fragment Ores and 1 Diamond

+ [N] Added Portable Teleporter object. Can be crafted via Iron Crafting Table for 1 Orange Teleporter Core, 1 Circuit Board, 2 Durasteel Bars and 2 Glass Blocks

+ [M] Instant teleportation! Removed fullscreen teleport animation (causes epilepsy and slows down the game. Chucklefish, what were you thinking?!)

+ [M] Replaced teleport effect sprites with blue versions based on original Rho's design

+ [R] The player will start from forest planet (same as in EK, was "Garden" in UG). This largely increases variety in comparison with bland "Lush / Garden" worlds

+ [F] The starter planet lookup values are 5/100 (same as in EK, was 100/300 in UG). Also removed requirement for "Ancient Gateway" dungeon world, since it's always generated in every planetary system. Also removed requirement for "small" world type. This makes the first run universe generation to only take 2 minutes instead of 15(!!) on my machine

+ [M] Intraspace travel takes 5 points of fuel (was 50 in EK, 0 in UG made little to no sense, but...)

+ [F] Fixed inability to fuel your ship for vanilla races when starting a new game (required because intraspace travels are not free anymore)

+ [M] Interspace travel takes 300 points maximum (was 200 in EK and up to 1000 in UG, which is unreal and would leave you with depleted engine. This seems to be the reason (beside the coal not being a "fuel" anymore) why intraspace travel was made cost free in UG, otherwise you'd stuck forever if landed on anything but the Moon or Outpost planet)

+ [N] Limit for items per cell changed to 9999 (was 1000 in EK/UG. Everybody wants to be super greedy sometimes :3 )

+ [N] Removed 1000 items limit for Rope

+ [R] Butterfly Boost tech is available upon upgrading ship to Tier 4 (aka Sparrow Class. Requires quest data purge or playing as new character)

+ [M] Un-nerfed Morph Ball tech. It consumes 20 points of energy (was 35 in EK and 65 in UG)

+ [R] Iron Beacon is available for crafting. As a result, the Penguin UFO boss can be summoned in open space (moved to its own quest location in UG)

+ [R] Quest "CLeF Tutorial #9.1.1: The First Contact". Automatically assigned upon crafting or picking up the Old Distress Beacon. Reward: 11-900 pixels

+ [M] Dreadwing Codex matches the old-new progression. Also, the boss will drop 5 Molten Core, 21 Core Fragment Ore and 1 Dreadwing Codex

+ [N] Quest "Wreckage of the Dreadwing". Automatically assigned upon picking up the Dreadwing's Wreckage

+ [M] Upon completing the "Dreadwing" quest, penguin will give 50 Matter Item, which can be used to craft Bonus Armour (otherwise the material for it is nowhere to be found)

+ [R] Decoy Princess is available for crafting. As a result, the Bone Dragon boss can be summoned (disabled in UG)

+ [N] Added decorative Decoy Princess Scheme object. Given by "Mute" Glitch upon starting "Bad To The Bone" quest

+ [N] Quest "Bad To The Bone". Given by "Mute" Glitch at Outpost for players with Tier 5 ship

+ [R] Peanut Butter Trap is available for crafting. As a result, the Jelly boss can be summoned (disabled in SG)

+ [N] Quest "Food For Thought". Given by Apex Scientist at Outpost for players with Tier 3 ship

+ [N] Farmable Peanut Seeds can be planted and will drop Peanut Seed or Peanuts

+ [N] Wild Peanut Seeds will spawn in Garden and Forest biomes on the previously unvisited worlds

+ [N] Consumable Peanuts can be grown with farmable Peanut Seeds

+ [N] Butter can be crafted from Coconut Milk

+ [N] Peanut Butter can be crafted from Butter and Peanuts

+ [N] (Large) Cardboard Box can be crafted from (88) 42 Paper sheets

+ [N] Peanut Butter Trap can be crafted from 1 Peanut Butter, 1 Large Cardboard Box and 1 Wood

+ [N] Questline "Fatal Circuit". Given by Mercenary Glitch and Penguin Promoter at Outpost for players with Tier 3 ship

+ [R] Brain extractor and all robot parts are available for crafting. As a result, you can summon Fatal Circuit, the old robot boss (was removed in UG and replaced by Penguin Bot)

+ [N] Fatal Circuit drops quest item - shorted out Broken Fatal Claw dagger with weak stats

+ [N] Cooking recipe "Brain Stew". Cooked from Wheat, Pearlpea, Corn and Inferior Brain

+ [N] Cooking recipe "Brain Pie. Cooked from Mashed Potato, Inferior Brain and Superior Brain

+ [N] Decorative "Monster's Brain in a Jar" item can be crafted from 1 Inferior Brain, 1 Glass Block and 1 Iron Bar at Crafting Table (recipe learned upon picking up Inferior Brain)

+ [N] Power Loom, a modern replacement for Spinning Wheel, can be crafted in Metalwork Station for 8 Steel Bars

+ [R] Re-added developer clothing sets (can be crafted via Yarn Spinner):
 - Ban's set
 - Bartwe's glasses
 - George's set
 - Kyren's set
 - Molly's set
 - Rhopunzel's set
 - Tiy's set

+ [R] Re-added armour sets:
 - Slime set (requires 25 Green Slimes per item and 10-15 Fabric, recipes learned upon Green Slime pickup)
 - Lagoon set (can be bought for 7500 pixels, available from the start)
 - Diamond set (requires 19 Diamonds and 6 Durasteel Bars, crafted at Metalwork Station)
 - Copper set (requires 5-15 Copper Bars, crafted at Metalwork Station, recipes learned upon Copper Bar pickup)
 - Silver set (recipes learned upon Silver Bar pickup)
 - Golden set (recipes learned upon Gold Bar pickup)
 - Platinum set (recipes learned upon Platinum Bar pickup)
 - Matter set (aka Bonus set) (recipes learned upon Matter Item pickup)
 - Original Pioneer set (recipes learned upon Titanium Bar pickup)

+ [R] Re-added misc clothing:
 - Terrifying Wings (requires 16 Fabric, 4 Rubium Ore and 2 Iron Bars, available from the start)

+ [F] Slime armour can be spawned in different colours

+ [M] Slime furniture recipes auto-learned upon Green Slime pickup

+ [F] Fixed learning of recipe for Ice Block on Ice pickup

+ [M] Ice furniture recipes auto-learned on Ice Block pickup

+ [M] Mole and Frog merchant objects have proper icons and breakable. Also, both have Novakid lines, and the Mole has proper descriptions

+ [M] The maximum number of possible dungeons per vanilla surface biome changed to 7 (was 1 in SG)

+ [F] Reduced lag at the Outpost:
 - Patched animation and script delta values of NPCs and objects to higher delay values
 - Removed extra light effects from hanging lights and arcade machine
 - Forced monitors to be turned off by default

+ [R] Infinity Express, Penguin Bay, Sign Store, Sign Dispenser, Terramart and Treasured Trophies can be taken and printed for pixels

+ [R] Mining Drill Console, Mining Drill Machine, Water Drop Source, Acid Drop Source, Escape Radar Dish, Mining Power Sign, No Way Out Graffiti, Decorative Root Set, Secret Symbol Set, The Way Is blocked Graffiti and Turn Back Graffiti can be taken and printed for pixels

+ [R] Vending Machine can be used as 32-slot storage container (was 16-slot storage in EK)

+ [N] Water Cooler can be used as 16-slot storage container

+ [N] Outpost Water Cooler can be used as 9-slot storage container

+ [N] Water and Healing water will spawn in Water Cooler and Outpost Water cooler in previously unvisited worlds

+ [M] Removed protection from randomly generated dungeons. Explaination: they weren't designed to use shields in the first place, and lots of players has already experienced problems with being unable to even access their front entrances, "thanks" to randomly generated ground obstacles, which also went under protection of the shield

+ [M] In order to compensate the protection removal, Tesla Spikes now have 20 points of "health" and much harder to harvest as a result

+ [R] Restored Outpost microdungeons spawning on all planets

+ [N] Moon biome surface spawns:
 - Expanded mini-outpost bunker
 - Restored and optimized Apex Sci-Fi Dungeon
 - Unfinished Wreck dungeon

+ [N] Moon biome underground spawns:
 - Outpost microdungeons
 - USCM microdungeons
 - Asteroid field microdungeons

+ [M] Flare and Glowstick projectiles no longer disappear when hitting monsters or spikes

+ [M] Standing Turret can be safely placed and removed without object's destruction

+ [R] Unused vanilla weapons added to treasure pools:
 - Burst Rifle
 - Cellzapper
 - Globe Launcher
 - Shattergun
 - Stinger Gun

+ [M] Changed monster_surprise sound effect for randomly generated monsters to:
 - Small Biped - angstyhead_small_turnhostile.wav
 - Small Quadruped - teethyhead_small_turnhostile.wav
 - Large Biped - powlhead_turnhostile.wav
 - Large Quadruped - angstyhead_turnhostile.wav
 - Huge Biped - dragonboss_death.wav
 - Miniboss Biped - arrowhead_turnhostile.wav
 - Miniboss Quadruped - canine_turnhostile.wav

+ [M] Reworked initial S.A.I.L. dialogues to look more credible and humorous:
 - Apex - Windows 8
 - Avian - Zork
 - Floran - DOS variation
 - Glitch - parodies Linux
 - Human - Windows NT 5.x
 - Hylotl - Commodore 64
 - Novakid - PFUDOR

+ [R] Window borders are colourless again

+ [M] Navigation sub-window texture changed to blue (was light-blue in EK)

+ [N] More zoom levels (from 1.0 to 10, with 0.5 step) and screen resolutions:
 - 640 x 480
 - 800 x 600
 - 1024 x 576
 - 1360 x 768
 - 3200 x 1080
 - 3200 x 1200
 - 3200 x 1536
 - 3840 x 1080
 - 3840 x 1200
 - 3840 x 1536
 - 4096 x 2160

+ [F] Performance patch: added optimized Hobo true-type font (58 KiB and ~50000 points versus 86 Kib and ~90000 points) with fixed cyrillic characters (officially part of the game since Spirited Giraffe builds)

+ [M] Replaced Chucklefish icon and logo animation with recoloured & shaded version (also fixed "u" which strongly resembled "v")

+ [M] All tutorial quests replaced with new descriptive ones which better match the mod's progression and cover the most of its important changes. Old tutorial questline is no longer used nor called


Extra addon changes
-------------------

Incompatible with "Enhanced Storage":

+ [M] Glitch Bucket can be used as 9-slot storage container

+ [M] Metal, Radioactive, Sewage and Toxic Waste barrels can be used as 12-slot storage containers

+ [M] Glitch Juice Keg can be used as 24-slot storage containers

+ [M] Apex Blood Bank, Sewer Tank and Outpost Tank can be used as 48-slot storage containers


Sandbox addon changes
---------------------

+ [M] Removed protection from all mission-generated (and outpost) dungeons

+ [M] Removed pixel and ore drops on "Casual" and "Normal" in order to compensate the removal of auto-return to ship on "Save & Quit"

+ [N] Extra zoom levels (from 0.5 to 1, with 0.1 step)

+ [R] No slowdown when running backwards (just like in EK)

+ [R] Removed "nude" and re-added "invisible" status effect for tent objects (as a side-effect, they no longer show bugged lit sprite which sometimes was floating in the air when player got up. Same as in EK)

+ [N] Limit for items per cell changed to 99999

+ [M] Modified Hobo Lesser font with more compact number glyphs, in order to properly display more than 9999 items per cell

+ [N] Block radius for placing changed to 4 (was 2 in EK/xG)

+ [M] Removed 1 maxStack limit for:

 - Axes (Stone, Ice)
 - Hoes (Copper, Stone)
 - Pickaxes (Stone, Copper, Silver, Golden, Diamond, Emerald, Platinum, Hi-Tech)
 - Drills (Stone, Copper, Silver, Golden, Diamond, Emerald, Platinum, Hi-Tech)
 - Flashlight (Normal, Green, Red, Yellow)
 - Mining Lantern
 - Slime Hand Grapple
 - Grappling Hook
 - Swinging Vine
 - Chainsaw
 - Bug Net


To-do list
----------

Seamlessly integrate the old quests and boss fights back into game:

+ Restore Jelly (DONE!)

+ Restore Fatal Circuit (DONE! Needs animation definition fixes)

+ Restore Bone Dragon (DONE! Needs some path/collision fixes)

+ Restore Tentacle Comet (broken, needs Lua coding and quest scripting)

Bring back biome variety:

+ Restore all removed biomes and mini-biomes

+ Restore removed microdungeons

+ The moons with more life and loot underneath, not just a stinky fuel

+ Barren worlds with realistic core, undercaves and stuff

Bunch of other stuff I tend to forget...


Contributors (they are awesome, all of them)
--------------------------------------------

These people has (in)directly contributed a huge amount of fixes and/or significant improvements. In alphabetical order:

* Grover Cures Houses (repairable tools flag)
* Kawa (JSON stuff, modding tips and tricks)
* LoPhatKao (Lua coding and major fixes for bosses, restored monster sound effects! ^o^)
* Rhyssia (initial Fatal Circuit fixes, which kick-started more stuff)
* Sayter (major fixes for Jelly Boss)
* TanzNukeTerror (several improvements I was too lazy to do on my own)
* Varixai (modding tips and tricks)
* XNicoX14 (alternative repairs mechanism and inspiration ^u^)
* xxswatelitexx (JSON stuff, modding tips and tricks)


Third-party mods merged with CLeF
---------------------------------

Note: THIS IS NOT A MODPACK, as the merged mods are not simply copy-pasted, but rebalanced, rearranged and tightly integrated with the rest of the content, hence they WILL CONFLICT WITH ORIGINAL MODS.

+ http://community.playstarbound.com/resources/2142/ - Emeralds! (by Serverator)
+ http://community.playstarbound.com/resources/2498/ - More Screen Resolutions (by eurosat7)
+ http://community.playstarbound.com/resources/2633/ - Lava Fuel Mod (by XNicoX14)
+ http://community.playstarbound.com/resources/2635/ - Prepare for Glory! (by LegendXCarisso) - Removed until further notice
+ http://community.playstarbound.com/resources/2640/ - Apex Grind Again (by eurosat7)
+ http://community.playstarbound.com/resources/2644/ - Craftable Chainsaw (by XNicoX14)
+ http://community.playstarbound.com/resources/2648/ - Repair Tools (by XNicoX14)
+ http://community.playstarbound.com/resources/2696/ - Developer Clothing Sets (by Lucaine)
+ http://community.playstarbound.com/resources/2705/ - Loom (by I Said No)
+ http://community.playstarbound.com/resources/2728/ - Swamp & Lagoon Armor Returned (by Campaigner)
+ http://community.playstarbound.com/resources/2811/ - Original Pioneer Armor (by Snigery)
+ http://community.playstarbound.com/resources/2832/ - Dreadwing Block (by shardshunt)
+ http://community.playstarbound.com/resources/2927/ - Slime Armour Colours Mod (by shadowd15)
+ http://community.playstarbound.com/resources/2939/ - Discernible Titanium Ore (by MetalTxus)
+ http://community.playstarbound.com/resources/2948/ - Moar Dungeons (by G4M5T3R)
+ http://community.playstarbound.com/resources/2949/ - Outpost Lag Reduction (by LoPhatKao)
+ http://community.playstarbound.com/resources/2978/ - Screams (by LoPhatKao)
+ http://community.playstarbound.com/resources/2995/ - It's over 9000 (by SoulOfSorin)
+ http://community.playstarbound.com/resources/2999/ - Static Toy Block (by IllidanS4)
+ http://community.playstarbound.com/resources/3049/ - Platform Books (by TanzNukeTerror)
+ http://community.playstarbound.com/resources/3058/ - Portable 3D Printer (by TanzNukeTerror)
+ http://community.playstarbound.com/resources/3070/ - Paint and Wire Tool restoration (by TanzNukeTerror)
+ http://community.playstarbound.com/resources/3077/ - Reliable Flares (by Oberic)
+ http://community.playstarbound.com/resources/3079/ - Vanilla Gun Activator (by Oberic)

Version history
---------------

- 2015/08/28 v53 - refactored and cloned CLeF-specific boss quest items & recipes (also they talk! :D)
- 2015/08/26 v52 - moved to August 25 Stable support, removed May 8 Stable support, confirmed August 26 Nightly support, added "piercing" variable to flares and glowsticks (thanks to Oberic), updated dungeon count patch (bug report and patch by MikkelManDK, thank you!), restored sounds for Dragon Boss and Fatal Circuit (in .ogg), unused vanilla weapons added to treasure pool (thanks to Oberic), restored Sci-Fi and Outpost microdungeons (also added to moon biome generation pool along with human microdungeons), added expanded Outpost mini-dungeon to Moon biome surface, resolved liquids collision with Frackin' Universe, updated NoLag code (by LoPhatKao, thank you! ^u^)
- 2015/08/21 v51 - moved to August 19 Nightly/Unstable support, restored classic Wire and Paint tool look (based on mod by TanzNukeTerror, thank you ^u^), updated outpost/mission hasObjectItem patch, updated breakable merchant object patch, added movable patch for Standing Turret
- 2015/08/20 v50 - restored portable 3d printer object (thanks to TanzNukeTerror), added modified Hobo font for Sandbox plugins, removed maxStack limit for all craftable tools in Sandbox addons, restored pickaxe recipes in Nightly
- 2015/08/09 v49 - moved to August 8 Nightly support, restored Bone Dragon's behaviour and attacks (thank you, LoPhatKao! ^o^), added back sounds for Fatal Circuit and Bone Dragon (Lua coding contributed by LoPhatKao, thank you! ^w^), updated decoloured inventory for Nightly
- 2015/08/07 v48 - moved to July 31 Nightly support, temporarily splitted Sandbox plugin into Stable and Nightly versions, fixed Jelly Boss (thank you, Sayter!) and Fatal Circuit's behaviour, Book blocks turned into platform (thanks to TanzNukeTerror), moved learning of robot recipes to Brain Extractor pickup, moved learning of Artificial Brain to Superior Brain pickup, added 5-stage questline for Glitch Mercenary and Penguin Promoter ("The Brain Hunter" quest merged into it), added Broken Fatal Claw dagger (thanks to Kawa for giving me the idea ^w^)
- 2015/07/17 v47 - de-coloured Frogg's Furnishing in Nightly, fixed crash for 42-slot container (reported by Anonfox123), added proper description to Avian God Wings (no means to craft it yet)
- 2015/07/12 v46 - moved to July 10 Nightly support, fixed emerald ore distribution values, restored learning of Ice Block recipe on Ice pickup, added learning of ice furniture recipes on Ice Block pickup, rewritten drill and pickaxe descriptions to reflect mod's mechanics, merged in recolour for Titanium Ore and Titanium Bars (thanks to MetalTxus), fixed NoLag code for July 10 Nightly (some code splitted again)
- 2015/07/07 v45 - moved to July 1 Nightly support, patched toy (Lego) block to be static (thanks to IllidanS4), added craftable dreadwing blocks (thanks to shardshunt), added craftable hi-tech pickaxe and hi-tech drill
- 2015/06/27 v44 - replaced all tutorial missions with new descriptive ones which better match the mod's progression
- 2015/06/21 v43 - updated NoLag code (by LoPhatKao), merged in Screams code (by LoPhatKao), added proper stats to Copper Armour set, changed pixel price of Lagoon Armour set, rebalanced mining tools' durability, Wild Peanut Seed plant now spawns on Garden and Forest biomes, changed initial SAIL messages to resemble real operating systems
- 2015/06/15 v42 - added Peanut Plant, Peanut Seed, consumable Peanuts, treasure pool for Peanut Plant, craftable Peanut Butter consumable, recipe for butter from coconut milk, craftable Cardboard Box 16-slot container, craftable Large Cardboard box 42-slot container, Peanut Butter trap craftable from Peanut Butter and Large Cardboard Box, Food For Thought quest given by Apex Scientists at the Outpost, restored quests and beacon script functioning in Nightly, removed annoying humming from Vending Machine
- 2015/06/10 v41 - updated NoLag code (by LoPhatKao), added recipe for Batwings backpack, added treasure pool for Water Coolers and patched dungeon files, added CM spawn recipe for Liquid Slime
- 2015/05/30 v40 - nerfed emerald distribution & fixed emerald glass tiles, fixed 2Stop Teleshop NoLag patch bug, updated shipblock PNGs, removed protection from challenge rooms in Sandbox addon
- 2015/05/28 v39 - changed maximum possible dungeons per planet to 7 instead of 1 (based on mod by G4M5T3R), integrated lag fix for the Outpost NPCs and objects (thanks to mod by LoPhatKao), interface decolour for Nightly redone from scratch, more storage containers, restored container functionality for Vending Machine, Cheats renamed to Sandbox
- 2015/05/25 v38 - allow Slime Armour to spawn in different colours (based on mod by shadowd15), patched vanilla Nightly liquidslime item to match CLeF's original implementation, restored alien juice and liquid nitrogen in Nightly, re-compressed .png files with custom image converter
- 2015/05/18 v37 - outpost and mission objects can be taken and printed for pixels again, replaced blue.png with remix of version from 666 UG
- 2015/05/16 v36 - added support for PG-0 Nightly (it seems no resource version is supplied anymore), de-coloured UI, new dungeons unprotected in Cheats addon, 99999 item limit for Cheats addon
- 2015/05/14 v35 - dropped support for 66x-2 Stable, rebuild and added more liquid interactions, added placeable liquid slime, added green slime blob recipe, replaced slime status effect icon
- 2015/05/13 v34 - restored UG 666 tent effects for Cheat addon, moved barrel containers to Extra addon (incompatible with Enhanced Storage)
- 2015/05/12 v33 - removed battle music patch (for now), added Emerald Glass and Emerald Blocks, barrels converted into storage containers, replaced teleport sprites with original blue Rho's concepts
- 2015/05/09 v32 - added whole bunch of Emerald-themed items, objects, tools and recipes (partially based on mod by Serverator), added Refinery recipe for Diamond Ore
- 2015/05/07 v31 - fixed generic metal armour recipes (reported by Hatsya Souji), moved copper armour recipes to Anvil instead of Metalwork Station
- 2015/05/05 v30 - moved to SG 679 Stable support, Frog and Mole merchant objects now have proper icons, descriptions, and also breakable
- 2015/04/29 v29 - added Fatal Circuit files (not used yet), fixed beacon scripts, restored Impervium Bars (no purpose yet)
- 2015/04/25 v28 - added SG 677 Stable support, changed teleport delay timing a bit
- 2015/04/21 v27 - fixed incorrect Erchius Crystal recipe (reported by crushinblue), added copper armour recipe, re-added slime and lagoon armour recipes, changed the way common metal armour recipes are learned, slime furniture recipe learning now attached to Green Slime pickup
- 2015/04/18 v26 - changed starter world lookup to "forest" biome and removed planet size restriction, speeded up first run universe generation and world lookup, removed support for 670 - 673 Nightly
- 2015/04/10 v25 - added support for Spirited Giraffe, more liquid interactions, removed fullscreen teleport animation
- 2015/03/28 v24 - restored original Pioneer armour set (requested by Snigery), craftable teleporters and teleporter cores
- 2015/03/24 v23 - added option to install on both Stable and Nightly, patched teleporter object to be craftable and transferable, added portable teleporter, added cheats
- 2015/03/22 v22 - added Wreckage of Dreadwing quest, patched Dreadwing quest to obtain matteritem and Bonus Armour, added Bad To The Bone quest and Decoy Princess Schematics decorative object. Bone Dragon boss is now integrated into quest line
- 2015/03/21 v21 - added Power Loom object (based on mod by I Said No), added reworked Chucklefish icon and logo animation
- 2015/03/17 v20 - erchius crystal from liquid fuel and diamonds, erchius crystal as fuel, does not deserve a separate version number
- 2015/03/16 v20 - balanced pixel prices for old furnaces, blocks of Erchius Crystals drop Erchius Crystals
- 2015/03/15 v19 - added Old Stone Furnace, Old Alloy Furnace and Monster's Brain in a Jar, renamed Distress Beacon and fixed quest descriptions
- 2015/03/04 v18 - added Creative Mode spawn recipes for every restored/implemented item, re-added stone tools (axe, pickaxe and hoe), added recipe for vanilla diamond armor, fixed links to restored vanilla armour sets (silver, golden, platinum, matter)
- 2015/03/03 v17 - removed "wellfed" effect from CLeF consumables, added plain Popcorn consumable and recipe for cooking and kitchen categories, cloned and repainted distress beacon object in order to remove possible collisions with other mods, removed recipe for vanilla distress beacon
- 2015/02/28 v16 - restored classic repair functionality (thanks to Grover Cures Houses), removed "repair" recipes, renamed Coffee Seed to Raw Coffee Beans, Raw Coffee Beans to Coffee Beans via campfire/microwave, slime armor now requires 1 slime block per item
- 2015/02/27 v15 - re-added swamp & lagoon armour sets (based on mod by Campaigner)
- 2015/02/26 v14 - re-integrated "The First Contact" quest, Dreadwing UFO drops 5 Molten Core and 21 Core Fragment Ore. restored battle music (based on mod by LegendXCarisso)
- 2015/02/25 v13 - restored Butterfly Boost tech, fixed description of Morph Ball tech
- 2015/02/24 v12 - moved developer clothes recipe to tier1 items in player.config.patch, removed plantfibre.item.patch. fixes bunch of "learned how to craft..." messages which covered the entire screen
- 2015/02/23 v11 - changed liquid interactions, core lava will now act like normal lava
- 2015/02/21 v10 - added missing .matmod patch, removed diamond ore from treasure pools
- 2015/02/20 v9 - added optimized Hobo font with fixed cyrillic characters
- 2015/02/19 v8 - re-added developer clothing sets (based on mod by Lucaine)
- 2015/02/18 v7 - balance: added 2 iron bar requirement for molten core, added new screen resolutions and zoom levels (based on mod by eurosat7), removed shield protection from randomly generated dungeons (thanks to eurosat7), diamond ore returns
- 2015/02/16 v6 - added craftable chainsaw, added repairable pickaxes and drills (based on mods by XNicoX14)
- 2015/02/15 v5 - un-nerfed morph ball tech, core fragment ore from 10 Lava and 1 Oil, Lava gives 1 fuel, Coal from 10 Wood
- 2015/02/15 v4 - ported to current .patch system, reorganized mod directory structure, added "The Brain Hunter" quest, removed Rope limit
- 2015/02/13 v3 - unlocked old armours, fixed inability to access fuel tank in tier2 ships
- 2015/02/12 v2 - added brain recipes
- 2015/02/10 v1 - first release


License
-------

This modification has been released under Creative Commons Attribution Share-Alike 4.0 International license terms.

You don't need to ask my permission to modify or integrate this mod or any part of it into other modpacks, but please release the resulting material under the exact same license terms, so the other people would enjoy it. Thank you. ^_^