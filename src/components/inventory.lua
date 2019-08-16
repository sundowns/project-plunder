local inventory =
    Component(
    function(e, size)
        e.id = _util.s.randomString(8)
        e.size = size
        e.slots = {}
    end
)

function inventory:generate_new_id()
    self.id = _util.s.randomString(8)
end

return inventory
