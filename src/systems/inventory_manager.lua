local inventory_manager =
  System(
  {_components.inventory, "ALL"},
  {
    _components.inventory,
    _components.controlled,
    "PLAYER"
  }
)

local INVENTORY_SCREEN_OFFSET_RATIO = Vector(0.2, 0.57)
local INVENTORY_CELL_SIZE = nil
local INVENTORY_SLOTS_PER_ROW = 10

function inventory_manager:init()
  INVENTORY_CELL_SIZE = (love.graphics.getWidth() * (1 - INVENTORY_SCREEN_OFFSET_RATIO.x * 2) / INVENTORY_SLOTS_PER_ROW)
  self.current_open_inventory = nil
end

function inventory_manager.resize(_, w, _)
  INVENTORY_CELL_SIZE = (w * (1 - INVENTORY_SCREEN_OFFSET_RATIO.x * 2) / INVENTORY_SLOTS_PER_ROW)
end

function inventory_manager:item_picked_up(item, actor)
  if actor:has(_components.inventory) then
    self:add_item_to_inventory(item, actor:get(_components.inventory))
  end
end

function inventory_manager:entityAdded(e)
  -- check random_string id's don't collide with any existing ones. if it does, generate another
  local new_inventory = e:get(_components.inventory)
  for i = 1, self.ALL.size do
    if new_inventory.id == self.ALL:get(i):get(_components.inventory).id then
      new_inventory:generate_new_id() -- TODO: repeat until no matches. probably good enough as is for now
    end

    for j = 1, new_inventory.size do
      new_inventory.slots[j] = {occupied = false, item = nil}
    end
  end
end

function inventory_manager.action_held(_, _, _)
end

function inventory_manager:action_pressed(action, entity)
  if entity:has(_components.inventory) then
    self:toggle_inventory(action, entity)
  end
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

function inventory_manager.add_item_to_inventory(_, item, inventory)
  assert(item, "Received null item to inventory:add")
  local target_slot = nil
  for i = 1, inventory.size do
    if not inventory.slots[i].occupied then
      target_slot = i
      break
    end
  end
  if target_slot then
    inventory.slots[target_slot].item = item
    inventory.slots[target_slot].occupied = true
  else
    print("Failed to add item to inventory. No appropriate inventory slot found")
    return false
  end
end

function inventory_manager:draw_ui()
  for i = 1, self.ALL.size do
    local inventory = self.ALL:get(i):get(_components.inventory)
    if self.current_open_inventory and self.current_open_inventory.id == inventory.id then
      local offset =
        Vector(
        INVENTORY_SCREEN_OFFSET_RATIO.x * love.graphics.getWidth(),
        INVENTORY_SCREEN_OFFSET_RATIO.y * love.graphics.getHeight()
      )
      local cell_width = INVENTORY_CELL_SIZE
      for j = 0, inventory.size - 1 do
        if j % INVENTORY_SLOTS_PER_ROW == 0 then
          offset.y = offset.y + cell_width
          offset.x = INVENTORY_SCREEN_OFFSET_RATIO.x * love.graphics.getWidth()
        end
        love.graphics.setColor(0.6, 0.6, 0.6, 1)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle("line", offset.x, offset.y, cell_width, cell_width)
        love.graphics.setLineWidth(10)
        love.graphics.setColor(0.6, 0.6, 0.6, 0.8)
        love.graphics.rectangle("fill", offset.x, offset.y, cell_width, cell_width)
        offset.x = offset.x + cell_width

        for k = 1, #self.current_open_inventory.slots do
          local slot = self.current_open_inventory.slots[k]
          if slot.occupied then
            _util.t.print(slot, 3)
          end
        end
      end
    end
  end
  _util.l.resetColour()
end

return inventory_manager
