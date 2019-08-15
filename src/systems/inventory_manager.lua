local inventory_manager = System({_components.inventory})

local INVENTORY_SCREEN_OFFSET_RATIO = Vector(0.1, 0.9)
local INVENTORY_CELL_SIZE_RATIO = nil
-- local INVENTORY_SLOTS_PER_ROW = 8 -- move to component? -- TODO: Wrap inventory display

-- TODO: toggle inventory with input

function inventory_manager:init()
    INVENTORY_CELL_SIZE_RATIO =
        (INVENTORY_SCREEN_OFFSET_RATIO.x * 2 / 8 * love.graphics.getWidth()) / love.graphics.getWidth()
    for i = 1, self.pool.size do
        local inventory = self.pool:get(i):get(_components.inventory)
        for j = 1, inventory.size do
            inventory.slots[j] = {occupied = false, item = nil}
        end
    end
end

-- function inventory_manager:add(new)
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

function inventory_manager:draw_ui()
    love.graphics.setColor(0.8, 0.5, 0.3, 1)
    for i = 1, self.pool.size do
        -- self.pool:get(i):get(_components.inventory).slots[i] = {occupied = false, item = nil}
        -- local slots = love.graphics.print()
        local inventory = self.pool:get(i):get(_components.inventory)
        if inventory.open then
            local offset =
                Vector(
                INVENTORY_SCREEN_OFFSET_RATIO.x * love.graphics.getWidth(),
                INVENTORY_SCREEN_OFFSET_RATIO.y * love.graphics.getHeight()
            )
            local cell_width = INVENTORY_CELL_SIZE_RATIO * love.graphics.getWidth()
            for j = 1, inventory.size do
                love.graphics.rectangle("line", offset.x + cell_width * (j - 1), offset.y, cell_width, cell_width)
                love.graphics.setColor(0.8, 0.5, 0.3, 0.5)
                love.graphics.rectangle("fill", offset.x + cell_width * (j - 1), offset.y, cell_width, cell_width)
                -- inventory.slots[j] = {occupied = false, item = nil}
            end
        end
    end
    _util.l.resetColour()
end

return inventory_manager
