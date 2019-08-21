-- #position (optional) is an vector with world coordinates (vec<float>)
return function(position, item_registry_index)
  local chest =
    Entity():give(_components.sprite, "CHEST", 0.65, 0.65):give(_components.visible):give(
    _components.gravity,
    _constants.GRAVITY,
    _constants.GRAVITY_DECELERATION
  ):give(_components.item, item_registry_index):give(
    _components.collides,
    _constants.ITEM_WIDTH,
    _constants.ITEM_HEIGHT,
    Vector(0, 0), -- offset relative to transform (arbitrary numbers that look nice atm)
    "item",
    "world"
  ):give(_components.icon, "resources/icons/chest.png"):give(_components.grabbable)

  -- TODO: some kind of colour-bleeding-outwards effect?
  -- chest:give(_components.point_light, 0.5, nil, _constants.ITEM_LIGHT_SOURCE_RADIUS)

  if position then
    chest:give(_components.transform, position, Vector(0, 0))
  end

  return chest:apply()
end
