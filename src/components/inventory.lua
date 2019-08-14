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
        if not self.slots[i] then
            target_slot = i
        end
    end
    if target_slot then
        self.slots[target_slot] = new
    else
        print("Failed to add item to inventory. No appropriate inventory slot found")
        return false
    end
end

return inventory
