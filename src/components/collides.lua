local collides =
    Component(
    function(e, width, height, offset, type, collides_with)
        assert(type, "missing type for collides component")
        if not collides_with then
            collides_with = "player,items,world"
        end
        e.offset = offset or Vector(0, 0)
        e.width = width
        e.height = height
        e.type = type
        e.collides_with = collides_with
        e.owner = nil
    end
)

function collides:set_owner(owner)
  self.owner = owner
end

return collides
