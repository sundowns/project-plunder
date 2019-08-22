local inventory_manager =
  System(
  {_components.inventory, "ALL"},
  {
    _components.toolbar,
    _components.toolbar,
    "TOOLBAR"
  },
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

local function draw_slot(origin, slot, slot_size, slots_per_row, is_selected)
  _util.l.resetColour()
  local offset =
    Vector(slot_size * ((slot.index - 1) % slots_per_row), (math.ceil(slot.index / slots_per_row) - 1) * slot_size)
  love.graphics.setColor(_constants.COLOURS.INVENTORY_SLOT_OUTLINE)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle("line", origin.x + offset.x, origin.y + offset.y, slot_size, slot_size)
  love.graphics.setLineWidth(10)
  if is_selected then
    love.graphics.setColor(_constants.COLOURS.INVENTORY_SLOT_SELECTED)
  else
    love.graphics.setColor(_constants.COLOURS.INVENTORY_SLOT)
  end
  love.graphics.rectangle("fill", origin.x + offset.x, origin.y + offset.y, slot_size, slot_size)

  _util.l.resetColour()

  if slot.item then
    if slot.item:has(_components.icon) then
      local icon = slot.item:get(_components.icon).image
      local scale = slot_size / icon:getWidth()
      love.graphics.draw(icon, origin.x + offset.x, origin.y + offset.y, 0, scale, scale, 0, 0)
    else
      print("Missing icon for item in inventory slot: " .. slot.index .. "")
    end
  end
end

-- inventory_manager system
function inventory_manager:init()
  self.timer = Timer.new()
  INVENTORY_CELL_SIZE =
    (love.graphics.getWidth() * (1 - _constants.INVENTORY_SCREEN_OFFSET_RATIO.x * 2) /
    _constants.INVENTORY_SLOTS_PER_ROW)
  self.current_open_inventory = nil
end

function inventory_manager.resize(_, w, _)
  INVENTORY_CELL_SIZE = (w * (1 - _constants.INVENTORY_SCREEN_OFFSET_RATIO.x * 2) / _constants.INVENTORY_SLOTS_PER_ROW)
end

function inventory_manager:item_picked_up(item, actor)
  local consumed = false
  if actor:has(_components.toolbar) then
    consumed = self:add_item_to_inventory(item, actor:get(_components.toolbar))
  end
  if not consumed and actor:has(_components.inventory) then
    consumed = self:add_item_to_inventory(item, actor:get(_components.inventory))
  end

  if consumed then
    item:remove(_components.transform):remove(_components.visible):apply()
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

-- TODO: add some sort of sensible 'subscription' mechanism for input callbacks!!!
function inventory_manager:action_pressed(action, entity)
  if not entity:has(_components.inventory) and not entity:has(_components.toolbar) then
    return
  end
  if action == "toggle_inventory" then
    self:toggle_inventory(entity)
  elseif action == "drop_item" then
    self:drop_item(entity)
  elseif _util.s.starts_with(action, "select") then
    local index = tonumber(string.match(action, "%d+"))
    assert(index, "Received an invalid selection index to toolbar")
    entity:get(_components.toolbar):select(index)
  end
end

-- TODO: this whole function is likely to change with velocity refactor/consolidation
local get_dropped_item_velocity = function(dropper)
  local velocity = _constants.BASE_ITEM_THROWN_VELOCITY:clone()
  if dropper:has(_components.direction) then
    if dropper:get(_components.direction).value == "LEFT" then
      velocity.x = -velocity.x
    end
  end

  if dropper:has(_components.transform) then
    velocity = velocity + (dropper:get(_components.transform).velocity) / 4
  end

  if dropper:has(_components.movement_state) then
    local movement_state = dropper:get(_components.movement_state)
    if movement_state.behaviour.state == "walk" then
      velocity.x = velocity.x + (dropper:get(_components.walk).x_velocity)
    elseif movement_state.behaviour.state == "jump" or movement_state.behaviour == "fall" then
      velocity.x = velocity.x + (dropper:get(_components.air_control).x_velocity)
    end
  end

  -- TODO: we need aerial drag
  -- TODO: set a cap for the velocity
  --   print("x: " .. velocity.x, " y: " .. velocity.y)
  return velocity
end

function inventory_manager:drop_item(entity)
  assert(entity)
  assert(entity:has(_components.transform), "entity with no transform attempted to drop item in the world")
  local item = nil
  -- remove item from slot at given index if it exists
  if entity:has(_components.toolbar) then
    local toolbar = entity:get(_components.toolbar)
    if toolbar.slots[toolbar.selected_index] and toolbar.slots[toolbar.selected_index].item then
      item = toolbar.slots[toolbar.selected_index].item
      toolbar.slots[toolbar.selected_index].item = nil
    end
  end
  if not item and entity:has(_components.inventory) then
    local index = 1
    local inventory = entity:get(_components.inventory)
    if inventory.slots[index] and inventory.slots[index].item then
      item = inventory.slots[index].item
      inventory.slots[index].item = nil
    end
  end

  if item then
    -- drop item into the world
    local transform = entity:get(_components.transform)
    local position = transform.position:clone()
    if entity:has(_components.dimensions) then
      local dimensions = entity:get(_components.dimensions)
      position.x = position.x + dimensions.width / 2
      position.y = position.y + dimensions.height / 2
    end
    local resultant_velocity = get_dropped_item_velocity(entity)
    item:give(_components.transform, position, resultant_velocity):give(_components.visible):give(
      _components.invulnerability
    ):apply()

    self.timer:after(
      _constants.ITEM_DROP_INVULNERABILITY_DURATION,
      function()
        if item:has(_components.invulnerability) then
          item:remove(_components.invulnerability):apply()
        end
      end
    )
  end
end

function inventory_manager:toggle_inventory(entity)
  assert(entity)

  local inventory = entity:get(_components.inventory)
  if (self.current_open_inventory and self.current_open_inventory.id == inventory.id) then
    -- this inventory is already open, lets close it
    self.current_open_inventory = nil
  else
    -- open it!
    self.current_open_inventory = inventory
  end
end

-- inventory could be toolbar or inventory components (just needs size and slots table)
function inventory_manager.add_item_to_inventory(_, item, inventory)
  assert(item, "Received null item to inventory:add")
  assert(inventory and inventory.size and inventory.slots, "Received invalid inventory for `add_item_to_inventory`")
  local target_slot = nil
  for i = 1, inventory.size do
    if not inventory.slots[i].item then
      target_slot = i
      break
    end
  end
  if target_slot then
    inventory.slots[target_slot].item = item
    return true -- item picked up
  else
    return false -- item not picked up
  end
end

function inventory_manager:update(dt)
  self.timer:update(dt)
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
      draw_slot(origin, toolbar.slots[j], INVENTORY_CELL_SIZE, toolbar.size, toolbar.selected_index == j)
    end
  end
  _util.l.resetColour()

  for i = 1, self.ALL.size do
    local entity = self.ALL:get(i)
    local inventory = entity:get(_components.inventory)
    if self.current_open_inventory and self.current_open_inventory.id == inventory.id then
      local origin =
        Vector(
        _constants.INVENTORY_SCREEN_OFFSET_RATIO.x * love.graphics.getWidth(),
        _constants.INVENTORY_SCREEN_OFFSET_RATIO.y * love.graphics.getHeight()
      )
      for j = 1, inventory.size do
        draw_slot(origin, self.current_open_inventory.slots[j], INVENTORY_CELL_SIZE, _constants.INVENTORY_SLOTS_PER_ROW)
      end
    end
  end
  _util.l.resetColour()
end

return inventory_manager
