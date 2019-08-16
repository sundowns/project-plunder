local item_manager = System({_components.item, "ALL"}, {_components.item, _components.transform, "DROPPED"})

function item_manager.init(_)
end

function item_manager.entityAdded(_, _)
    -- check random_string id's don't collide with any existing ones. if it does, generate another
end

function item_manager.draw(_)
    -- for i = 1, self.DROPPED.size do
    --     local inventory = self.ALL:get(i):get(_components.inventory)
    --     if self.current_open_inventory and self.current_open_inventory.id == inventory.id then
    --         local offset =
    --             Vector(
    --             INVENTORY_SCREEN_OFFSET_RATIO.x * love.graphics.getWidth(),
    --             INVENTORY_SCREEN_OFFSET_RATIO.y * love.graphics.getHeight()
    --         )
    --         local cell_width = INVENTORY_CELL_SIZE
    --         for j = 0, inventory.size - 1 do
    --             if j % INVENTORY_SLOTS_PER_ROW == 0 then
    --                 offset.y = offset.y + cell_width
    --                 offset.x = INVENTORY_SCREEN_OFFSET_RATIO.x * love.graphics.getWidth()
    --             end
    --             love.graphics.setColor(0.6, 0.6, 0.6, 1)
    --             love.graphics.setLineWidth(4)
    --             love.graphics.rectangle("line", offset.x, offset.y, cell_width, cell_width)
    --             love.graphics.setLineWidth(10)
    --             love.graphics.setColor(0.6, 0.6, 0.6, 0.8)
    --             love.graphics.rectangle("fill", offset.x, offset.y, cell_width, cell_width)
    --             offset.x = offset.x + cell_width
    --         end
    --     end
    -- end
    _util.l.resetColour()
end

function item_manager.update(_, _)
    -- print(dt)
end

return item_manager
