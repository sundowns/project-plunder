local jump =
    Component(
    function(e)
        e.jump_velocity = _constants.JUMP_ACCELERATION
        e.walljump_x_velocity = _constants.WALLJUMP_X_ACCELERATION
        e.walljump_y_velocity = _constants.WALLJUMP_Y_ACCELERATION
        e.falling_trigger_velocity = 3
    end
)
return jump
