local oldtileMaterials = tileMaterials

function tileMaterials()
  oldtileMaterials()
  -- world.logInfo("fu_tilematerials")
  -- ["materialName"] = {{EphemeralEffects to apply},
  --  groundMovementModifier, runModifier, jumpModifier,      <-- mcontroller.controlModifiers
  --  normalGroundFriction, groundForce, slopeSlidingFactor,  <-- mcontroller.controlParameters 
  --  groundSoftness}
  -- ["anormaltile"] = {{},0,0,0,14,100,0,1}
  self.matCheck["mud"] = {{"fumudslow"},0,0,0,14,100,0,0.75}
  self.matCheck["clay"] = {{"fumudslow"},0,0,0,14,100,0,0.75}
  self.matCheck["sand"] = {{"jungleslow"},0,0,0,14,100,0,0.9}
  self.matCheck["rainbowsand"] = {{"jungleslow"},0,0,0,14,100,0,0.2}
  self.matCheck["glowingsand"] = {{"glow"},0,0,0,14,100,0,0.2} 
  self.matCheck["crystalsand"] = {{"jungleslow"},0,0,0,14,100,0,0.9}
  self.matCheck["glasssand"] = {{"jungleslow"},0,0,0,14,100,0,0.9}
  self.matCheck["redsand"] = {{"jungleslow"},0,0,0,14,100,0,0.9}
  self.matCheck["jungledirt2"] = {{"jungleslow"},0,0,0,14,100,0,1}
  self.matCheck["swampdirtff"] = {{"jungleslow"},0,0,0,14,100,0,1}
  self.matCheck["frozenwater"] = {{"iceslip"},0,0,0,14,100,0,1}
  self.matCheck["ice"] = {{"iceslip"},0,0,0,14,100,0,1}
  self.matCheck["iceblock1"] = {{"iceslip"},0,0,0,14,100,0,1}
  self.matCheck["iceblock2"] = {{"iceslip"},0,0,0,14,100,0,1}
  self.matCheck["iceblock3"] = {{"iceslip3"},0,0,0,14,100,0,0.2}
  self.matCheck["iceblock4"] = {{"iceslip2"},0,0,0,14,100,0,0.2}
  self.matCheck["snow"] = {{"snowslow"},0,0,0,14,100,0,1}
  self.matCheck["slush"] = {{"slushslow"},0,0,0,14,100,0,1}
  self.matCheck["slime"] = {{"slimestick"},0,0,0,14,100,0,0.75}
  self.matCheck["slime2"] = {{"slimestick"},0,0,0,14,100,0,0.75}
  self.matCheck["magmatile"] = {{"burning"},0,0,0,14,100,0,1}
  self.matCheck["magmatile2"] = {{"burning"},0,0,0,14,100,0,1}
  self.matCheck["blackslime"] = {{"slimestick","weakpoison"},0,0,0,14,100,0,0.65}
  self.matCheck["spidersilkblock"] = {{"webstick"},0,0,0,14,100,0,0.32}
  self.matCheck["irradiatedtile"] = {{"radiationburn"},0,0,0,14,100,0,1}
  self.matCheck["irradiatedtile2"] = {{"radiationburn"},0,0,0,14,100,0,1}
  self.matCheck["irradiatedtile3"] = {{"radiationburn"},0,0,0,14,100,0,1}
  self.matCheck["protorock"] = {{"ffextremeradiation"},0,0,0,14,100,0,1.3}
  self.matCheck["bioblock"] = {{"regenerationminor"},0,0,0,14,100,0,1.1}
  self.matCheck["bioblock2"] = {{"regenerationminor"},0,0,0,14,100,0,1.2}
  self.matCheck["biodirt"] = {{"regenerationminor"},0,0,0,14,100,0,0.85}
  self.matCheck["metallic"] = {{"metalspeed"},0,0,0,14,100,0,1.3}
  self.matCheck["asphalt"] = {{"metalspeed"},0,0,0,14,100,0,1.4}
  self.matCheck["cloudblock"] = {{"lowgrav"},0,0,0,14,100,0,0.2}
  self.matCheck["raincloud"] = {{"lowgrav"},0,0,0,14,100,0,0.2}

          
end