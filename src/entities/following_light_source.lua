-- position is a vector with world coordinates (floats)
return function(position, encircle_target_entity, light_colour, radius)
  assert(position.x and position.y, "Received non-vector position to player following_light_source")
  local following_light_source =
    Entity():give(_components.transform, position, Vector(0, 0)):give(_components.point_light, 1, light_colour, radius):give(
    _components.encircle,
    125,
    position,
    encircle_target_entity
  ):apply()
  return following_light_source
end
