local inventory_manager =
  System(
  {_components.inventory, "ALL"},
  {_components.toolbar, _components.toolbar, "TOOLBAR"},
  {
    _components.inventory,
    _components.toolbar,
    _components.controlled,
    "PLAYER"
  }
)

local INVENTORY_CELL_SIZE = nil

-- Cheeky helper functions for working with slots

local function new_slot(index)
  return {item = nil, index = index}
end

local function draw_slot(origin, slot, slot_size, slots_per_row)
  local offset = Vector(slot_size * (slot.index % slots_per_row), 0)
  love.graphics.setColor(0.6, 0.6, 0.6, 1)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle("line", origin.x + offset.x, origin.y, slot_size, slot_size)
  love.graphics.setLineWidth(10)
  love.graphics.setColor(0.6, 0.6, 0.6, 0.8)
  love.graphics.rectangle("fill", origin.x + offset.x, origin.y, slot_size, slot_size)

  _util.l.resetColour()
  if slot.item then
    if slot.item:has(_components.icon) then
      local icon = slot.item:get(_components.icon).image
      local scale = slot_size / icon:getWidth()
      love.graphics.draw(icon, offset.x, offset.y, 0, scale, scale, slot_size * 2, 0) -- TODO: solve offset when resizing
    else
      print("Missing icon for item in inventory slot: " .. slot.index .. "")
    end
  end
end

-- inventory_manager system
function inventory_manager:init()
  INVENTORY_CELL_SIZE =
    (love.graphics.getWidth() * (1 - _constants.INVENTORY_SCREEN_OFFSET_RATIO.x * 2) /
    _constants.INVENTORY_SLOTS_PER_ROW)
  self.current_open_inventory = nil
end

function inventory_manager.resize(_, w, _)
  INVENTORY_CELL_SIZE = (w * (1 - _constants.INVENTORY_SCREEN_OFFSET_RATIO.x * 2) / _constants.INVENTORY_SLOTS_PER_ROW)
end

function inventory_manager:item_picked_up(item, actor)
  if actor:has(_components.toolbar) then
  -- check toolbar slots
  -- TODO: add to toolbar instead
  end
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
      new_inventory.slots[j] = new_slot(j)
    end
  end

  if e:has(_components.toolbar) then
    local toolbar = e:get(_components.toolbar)
    for i = 1, toolbar.size do
      toolbar.slots[i] = new_slot(i)
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
  for i = 1, self.PLAYER.size do
    local player = self.PLAYER:get(i)
    local toolbar = player:get(_components.toolbar)
    local origin =
      Vector(
      _constants.TOOLBAR_SCREEN_OFFSET_RATIO.x * love.graphics.getWidth(),
      _constants.TOOLBAR_SCREEN_OFFSET_RATIO.y * love.graphics.getHeight()
    )
    for j = 1, toolbar.size do
      draw_slot(origin, toolbar.slots[j], INVENTORY_CELL_SIZE, toolbar.size)
    end
  end
  _util.l.resetColour()

  for i = 1, self.ALL.size do
    local entity = self.ALL:get(i)
    local inventory = entity:get(_components.inventory)
    -- TODO: use draw_slot function!!!!!!
    local offset =
      Vector(
      _constants.INVENTORY_SCREEN_OFFSET_RATIO.x * love.graphics.getWidth(),
      _constants.INVENTORY_SCREEN_OFFSET_RATIO.y * love.graphics.getHeight()
    )
    if self.current_open_inventory and self.current_open_inventory.id == inventory.id then
      for j = 1, inventory.size do
        if (j - 1) % _constants.INVENTORY_SLOTS_PER_ROW == 0 then
          offset.y = offset.y + INVENTORY_CELL_SIZE
          offset.x = _constants.INVENTORY_SCREEN_OFFSET_RATIO.x * love.graphics.getWidth()
        end
        love.graphics.setColor(0.6, 0.6, 0.6, 1)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle("line", offset.x, offset.y, INVENTORY_CELL_SIZE, INVENTORY_CELL_SIZE)
        love.graphics.setLineWidth(10)
        love.graphics.setColor(0.6, 0.6, 0.6, 0.8)
        love.graphics.rectangle("fill", offset.x, offset.y, INVENTORY_CELL_SIZE, INVENTORY_CELL_SIZE)
        offset.x = offset.x + INVENTORY_CELL_SIZE

        _util.l.resetColour()
        local slot = self.current_open_inventory.slots[j]
        if slot.item then
          if slot.item:has(_components.icon) then
            local icon = slot.item:get(_components.icon).image
            local scale = INVENTORY_CELL_SIZE / icon:getWidth()
            love.graphics.draw(icon, offset.x, offset.y, 0, scale, scale, INVENTORY_CELL_SIZE * 2, 0) -- TODO: solve offset when resizing
          else
            print("Missing icon for item in inventory slot: " .. j .. "")
          end
        end
      end
    end
  end
  _util.l.resetColour()
end

return inventory_manager
