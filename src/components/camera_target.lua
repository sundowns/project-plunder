local camera_target =
    Component(
    function(e)
        e.id = _util.s.randomString(8) -- replace with uuid library?
        e.camera = Camera(0, 0)
    end
)

return camera_target
