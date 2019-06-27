local walljump =
    Component(
    function(e)
        e.jump_x_velocity = _constants.WALLJUMP_X_ACCELERATION
        e.jump_y_velocity = _constants.WALLJUMP_Y_ACCELERATION
    end
)

function walljump:jump(entity)
    local direction = entity:get(_components.direction)
    local air_controlled = entity:get(_components.air_control)
    local transform = entity:get(_components.transform)
    local multiplier = 1

    if direction.value == "RIGHT" then
        multiplier = -1
    end

    air_controlled.x_velocity = self.jump_x_velocity * multiplier
    transform.velocity.y = -self.jump_y_velocity
end

return walljump
