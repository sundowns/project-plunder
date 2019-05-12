-- x and y are world coordinates (float)
return function(position)
    assert(position.x and position.y, "Received non-vector position to player entity")
    local player =
        Entity():give(_components.transform, position, Vector(0, 0)):give(_components.sprite, "PLAYER", 0, 2, 2, 0, 0):give(
        _components.direction
    ):apply()
    return player
end
