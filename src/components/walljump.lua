local walljump =
    Component(
    function(e)
        e.jump_x_velocity = _constants.WALLJUMP_X_ACCELERATION
        e.jump_y_velocity = _constants.WALLJUMP_Y_ACCELERATION
        e.is_locked_out = false
        e.lockout_direction = nil
        e.timer = Timer.new()
    end
)

function walljump:jump(entity)
    local direction = entity:get(_components.direction)
    local air_controlled = entity:get(_components.air_control)
    local transform = entity:get(_components.transform)
    local multiplier = 1
    local lockout_direction = "left"

    if direction.value == "RIGHT" then
        multiplier = -1
        lockout_direction = "right"
    end

    air_controlled.x_velocity = self.jump_x_velocity * multiplier
    transform.velocity.y = -self.jump_y_velocity
    self:lockout(lockout_direction)
end

function walljump:lockout(direction)
    self.is_locked_out = true
    self.lockout_direction = direction
    self.timer:after(
        0.3,
        function()
            self.is_locked_out = false
            self.lockout_direction = nil
        end
    )
end

function walljump:update(dt)
    self.timer:update(dt)
end

return walljump
