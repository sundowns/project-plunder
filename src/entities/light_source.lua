-- position is a vector with world coordinates (floats)
return function(position, encircle_target_entity)
    assert(position.x and position.y, "Received non-vector position to player light_source")
    local light_source =
        Entity():give(_components.transform, position, Vector(0, 0)):give(
        _components.point_light,
        1,
        _constants.COLOURS.TORCHLIGHT,
        130
    ):give(_components.encircle, 150, position, encircle_target_entity):apply()
    return light_source
end
