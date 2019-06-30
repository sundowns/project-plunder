-- position is a vector with world coordinates (floats)
return function(position)
    assert(position.x and position.y, "Received non-vector position to player entity")

    local player =
        Entity():give(_components.transform, position, Vector(0, 0)):give(_components.sprite, "PLAYER"):give(
        _components.direction
    ):give(_components.dimensions, _constants.PLAYER_WIDTH, _constants.PLAYER_HEIGHT):give(
        _components.controlled,
        {a = "left", d = "right", space = "jump", mouse1 = "target_light"}
    ):give(_components.walk):give(_components.air_control):give(_components.jump):give(
        _components.gravity,
        _constants.GRAVITY,
        _constants.GRAVITY_DECELERATION
    ):give(
        _components.movement_state,
        {
            default = {
                {duration = 1}
            },
            walk = {
                {duration = 1}
            },
            jump = {
                {duration = 1}
            },
            fall = {
                {duration = 1}
            }
        },
        "fall"
    ):give(
        _components.collides,
        _constants.PLAYER_WIDTH,
        _constants.PLAYER_HEIGHT,
        Vector(6, 12) -- offset relative to transform (arbitrary numbers that look nice atm)
    ):give(_components.camera_target):apply()
    return player
end
