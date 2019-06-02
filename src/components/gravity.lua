local gravity =
    Component(
    function(e, strength, deceleration)
        e.strength = strength
        e.deceleration = deceleration
    end
)

return gravity
