function init()
  status.setPersistentEffects("ancientprotectionTech", {{stat = "biomeheatImmunity", amount = 1}, {stat = "ancientheatImmunity", amount = 1}, {stat = "biomecoldImmunity", amount = 1}, {stat = "biomeradiationImmunity", amount = 1}, {stat = "breathProtection", amount = 1}})
end

function input(args)
  return nil
end

function uninit()
  status.clearPersistentEffects("ancientprotectionTech")
end