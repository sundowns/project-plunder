local inventory_manager =
    System({_components.inventory, "ALL"}, {_components.inventory, _components.controlled, "PLAYER"})

local INVENTORY_SCREEN_OFFSET_RATIO = Vector(0.1, 0.1)
local INVENTORY_CELL_SIZE_RATIO = nil

function inventory_manager:init()
    INVENTORY_CELL_SIZE_RATIO =
        (INVENTORY_SCREEN_OFFSET_RATIO.x * 2 / 8 * love.graphics.getWidth()) / love.graphics.getWidth()
    for i = 1, self.ALL.size do
        local inventory = self.ALL:get(i):get(_components.inventory)
        for j = 1, inventory.size do
            inventory.slots[j] = {occupied = false, item = nil}
        end
    end

    self.current_open_inventory = nil
end

function inventory_manager:entityAdded(e)
    -- check random_string id's don't collide with any existing ones. if it does, generate another
    local new_inventory = e:get(_components.inventory)
    for i = 1, self.ALL.size do
        if new_inventory.id == self.ALL:get(i):get(_components.inventory).id then
            new_inventory:generate_new_id()
        end
    end
end

function inventory_manager:action_pressed(action, entity)
    if entity:has(_components.inventory) then
        self:toggle_inventory(action, entity)
    end
end

function inventory_manager.action_held(_, _, _)
end

function inventory_manager:toggle_inventory(action, entity)
    assert(action)
    assert(entity)
    if action ~= "toggle_inventory" then
        return
    end

    local inventory = entity:get(_components.inventory)
    if (self.current_open_inventory and self.current_open_inventory.id == inventory.id) then
        -- this inventory is already open, lets close it
        self.current_open_inventory = nil
    else
        -- open it!
        self.current_open_inventory = inventory
    end
end

-- function inventory_manager:add_item(new)
--     assert(new, "Received null item to inventory:add")
--     local target_slot = nil
--     for i = 1, self.size do
--         if not self.slots[i] then
--             target_slot = i
--         end
--     end
--     if target_slot then
--         self.slots[target_slot] = new
--     else
--         print("Failed to add item to inventory. No appropriate inventory slot found")
--         return false
--     end
-- end

-- TODO: Wrap inventory display dynamically
function inventory_manager:draw_ui()
    for i = 1, self.ALL.size do
        local inventory = self.ALL:get(i):get(_components.inventory)
        if self.current_open_inventory and self.current_open_inventory.id == inventory.id then
            local offset =
                Vector(
                INVENTORY_SCREEN_OFFSET_RATIO.x * love.graphics.getWidth(),
                INVENTORY_SCREEN_OFFSET_RATIO.y * love.graphics.getHeight()
            )
            local cell_width = INVENTORY_CELL_SIZE_RATIO * love.graphics.getWidth()
            for j = 1, inventory.size do
                love.graphics.setColor(0.6, 0.6, 0.6, 1)
                love.graphics.setLineWidth(4)
                love.graphics.rectangle("line", offset.x + cell_width * (j - 1), offset.y, cell_width, cell_width)
                love.graphics.setLineWidth(10)
                love.graphics.setColor(0.6, 0.6, 0.6, 0.5)
                love.graphics.rectangle("fill", offset.x + cell_width * (j - 1), offset.y, cell_width, cell_width)
            end
        end
    end
    _util.l.resetColour()
end

return inventory_manager
