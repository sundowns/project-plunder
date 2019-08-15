local inventory =
    Component(
    function(e, size)
        e.open = true
        e.size = size
        e.slots = {}
    end
)

return inventory
