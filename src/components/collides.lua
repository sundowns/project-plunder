local collides =
    Component(
    function(e, width, height, offset)
        e.offset = offset or Vector(0, 0)
        assert(e.offset.x and e.offset.y, "received non vector offset to collide component")
        e.width = width
        e.height = height
    end
)

return collides
