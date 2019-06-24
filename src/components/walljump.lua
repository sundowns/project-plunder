local walljump =
    Component(
    function(e)
        e.jump_x_velocity = _constants.WALLJUMP_X_ACCELERATION
        e.jump_y_velocity = _constants.WALLJUMP_Y_ACCELERATION
    end
)

function walljump:jump(entity)
    local controlled = entity:get(_components.controlled)
    local air_controlled = entity:get(_components.air_control)
    local transform = entity:get(_components.transform)
    local multiplier = 1

    if controlled.is_held["right"] then
        multiplier = -1
    end

    air_controlled.x_velocity = self.jump_x_velocity * multiplier
    transform.velocity.y = -self.jump_y_velocity
end

return walljump
