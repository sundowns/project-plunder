local jump =
    Component(
    function(e)
        e.base_jump_velocity = _constants.JUMP_ACCEL
        e.base_jump_decay = _constants.JUMP_DECAY
        e.jump_velocity = e.base_jump_velocity
        e.jump_decay = e.base_jump_decay
        e.falling_trigger_velocity = -120
        e.fall_speed_modifier = 13.5
        e.y_velocity = 0
    end
)

function jump:jump()
    self.y_velocity = self.base_jump_velocity
    self.jump_decay = self.base_jump_decay
end

function jump:decay(dt)
    local fall_speed_modifier = 1
    if self.y_velocity < self.falling_trigger_velocity then
        fall_speed_modifier = self.fall_speed_modifier
    end

    self.y_velocity = self.y_velocity - self.base_jump_decay * (fall_speed_modifier * dt)
end

return jump
