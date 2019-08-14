local inventory = System({_components.inventory})

function inventory:init()
end

function inventory:action_pressed(action, entity)
    if entity:has(_components.inventory) then
    -- self:jump(action, entity)
    end
end

return inventory
