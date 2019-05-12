-- position is a vector with world coordinates (floats)
return function(position)
    assert(position.x and position.y, "Received non-vector position to player entity")
    local player =
        Entity():give(_components.transform, position, Vector(200, 0)):give(_components.sprite, "PLAYER", 0, 4, 4, 0, 0):give(
        _components.direction
    ):apply()
    return player
end
