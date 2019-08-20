local levitation = System({_components.transform, _components.levitating})

function levitation:init()
  self.upwards = false
  self.timer = Timer.new()
  self.movement_speed = 4.5

  self.timer:every(
    1.25,
    function()
      self.upwards = not self.upwards
    end
  )
end

function levitation:update(dt)
  self.timer:update(dt)

  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    local transform = e:get(_components.transform)
    if self.upwards then
      transform.position.y = transform.position.y - self.movement_speed * dt
    else
      transform.position.y = transform.position.y + self.movement_speed * dt
    end
  end
end

return levitation
