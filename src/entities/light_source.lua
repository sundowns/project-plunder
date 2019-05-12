-- position is a vector with world coordinates (floats)
return function(position, encircle_target_entity)
    assert(position.x and position.y, "Received non-vector position to player light_source")
    local light_source =
        Entity():give(_components.transform, position, Vector(0, 0)):give(
        _components.point_light,
        0.8,
        _constants.COLOURS.TORCHLIGHT,
        150
    ):give(_components.encircle, 120, position, encircle_target_entity):apply()
    return light_source
end
