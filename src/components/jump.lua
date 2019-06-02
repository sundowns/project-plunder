local jump =
    Component(
    function(e)
        e.jump_velocity = _constants.JUMP_ACCELERATION
        e.falling_trigger_velocity = 3
        -- e.y_velocity = 0
    end
)

-- function jump:jump()
--     -- self.y_velocity = self.jump_velocity
-- end

-- function jump:update(dt, gravity_strength, multiplier)
--     -- self.y_velocity = self.y_velocity - gravity_strength * multiplier * dt
-- end

return jump
