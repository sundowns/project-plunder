-- position is a vector with world coordinates (floats)
return function(position, light_colour, radius)
    assert(position.x and position.y, "Received non-vector position to player static_light_source")
    local static_light_source =
        Entity():give(_components.transform, position, Vector(0, 0)):give(
        _components.point_light,
        1,
        light_colour,
        radius
    ):give(_components.sprite, "TORCH"):apply()
    return static_light_source
end