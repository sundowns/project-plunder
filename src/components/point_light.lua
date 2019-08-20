local point_light =
  Component(
  function(e, strength, colour, radius)
    e.strength = strength
    e.colour =
      colour or
      {
        1,
        1,
        1
      }
    e.radius = radius or 300
  end
)

return point_light
