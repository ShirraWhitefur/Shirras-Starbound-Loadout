function binInventoryChange()
  if entity.id() then
    local container = entity.id()
    local frames = entity.configParameter("binFrames", 9)
    local fill = math.ceil(frames * fillPercent(container))
    if self.fill ~= fill then
      self.fill = fill
      entity.setAnimationState("fill", tostring(fill))
    end
  end
end

function fillPercent(container)
  if type(container) ~= "number" then return nil end
  local size = world.containerSize(container)
  local count = 0
  for i = 0,size,1 do
    local item = world.containerItemAt(container, i)
    if item ~= nil then
      count = count + 1
    end
  end
  return (count/size)
end