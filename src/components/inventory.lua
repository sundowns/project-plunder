local inventory =
    Component(
    function(e, size)
        e.size = size
        e.slots = {}
        for i = 1, size do
            e.slots[i] = {occupied = false, item = nil}
        end
    end
)

function inventory:add(new)
    assert(new, "Received null item to inventory:add")
    local target_slot = nil
    for i = 1, self.size do
        if not self.slots[i].occupied then
            target_slot = i
        end
    end
    if target_slot then
        self.slots[target_slot].occupied = true
        self.slots[target_slot].item = new
    else
        return false
    end
end

return inventory
