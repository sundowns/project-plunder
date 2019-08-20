local air_control =
  Component(
  function(e)
    e.acceleration = _constants.AIRCONTROL_ACCELERATION
    e.max_speed = _constants.AIRCONTROL_MAX_SPEED
    e.x_velocity = 0
  end
)

-- This is triggered every key_poll, that is there is an 'assumed delta' equal to the polling rate
function air_control:move(modifier)
  self.x_velocity = self.x_velocity + self.acceleration * modifier
  if math.abs(self.x_velocity) > self.max_speed then
    self.x_velocity = self.max_speed * modifier
  end
end

return air_control
