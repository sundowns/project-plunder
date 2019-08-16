-- #position (optional) is an vector with world coordinates (vec<float>)
return function(position)
    local chest =
        Entity():give(_components.transform, position, Vector(0, 0)):give(_components.sprite, "CHEST", 0.65, 0.65):give(
        _components.levitating
    ):give(_components.item)

    -- chest:give(_components.point_light, 0.5, nil, _constants.ITEM_LIGHT_SOURCE_RADIUS)

    if position then
        chest:give(_components.transform, position, Vector(0, 0))
    end

    return chest:apply()
end
