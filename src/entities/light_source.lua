-- position is a vector with world coordinates (floats)
return function(position)
    assert(position.x and position.y, "Received non-vector position to player light_source")
    local light_source =
        Entity():give(_components.transform, position, Vector(0, 0)):give(
        _components.point_light,
        0.75,
        _constants.COLOURS.TORCHLIGHT,
        50
    ):apply()
    return light_source
end
