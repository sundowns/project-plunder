local encircle =
    Component(
    function(e, radius, origin, target_entity)
        assert(radius, "Radius not specified for encircle component")
        assert(origin and origin.x and origin.y, "Received non-vector value for encirle origin")
        e.radius = radius
        e.origin = origin
        e.target_entity = target_entity
    end
)

function encircle:update_origin(new_origin)
    self.origin = new_origin
end

return encircle
