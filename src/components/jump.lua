local jump =
    Component(
    function(e)
        e.jump_velocity = _constants.JUMP_ACCEL
        e.falling_trigger_velocity = 3
        e.y_velocity = 0
    end
)

function jump:jump()
    self.y_velocity = self.jump_velocity
end

function jump:update(dt, gravity, multiplier)
    self.y_velocity = self.y_velocity - gravity.strength * multiplier * dt
end

return jump
