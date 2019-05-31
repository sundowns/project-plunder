-- position is a vector with world coordinates (floats)
return function(position)
    assert(position.x and position.y, "Received non-vector position to player entity")

    local scale = 4

    local player =
        Entity():give(_components.transform, position, Vector(0, 0)):give(
        _components.sprite,
        "PLAYER",
        0,
        scale,
        scale,
        0,
        0
    ):give(_components.direction):give(_components.dimensions, 32 * scale, 32 * scale):give(
        _components.controlled,
        {a = "left", left = "left", d = "right", right = "right", space = "jump"}
    ):give(_components.walk):give(_components.air_control):give(_components.jump):give(
        _components.gravity,
        _constants.GRAVITY
    ):give(_components.player_state, "fall"):apply()
    return player
end
