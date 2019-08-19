local icon =
    Component(
    function(e, path)
        assert(path, "received invalid path for icon")
        e.image = love.graphics.newImage(path)
    end
)

return icon
