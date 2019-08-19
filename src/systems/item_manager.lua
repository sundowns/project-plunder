local item_manager =
  System(
  {_components.item, "ALL"},
  {_components.item, _components.transform, _components.collides, "DROPPED"},
  {_components.pickup_items, _components.transform, "CAN_PICKUP"}
)

local items_only_filter = function(other)
  if other.type == "item" then
    return true
  else
    return false
  end
end

function item_manager:init()
  self.collision_world = nil
  self.item_registry = {}
  self._identifier_map = {} -- used for reverse lookup (key -> index in registry)
  self:register_item("chest")
end

function item_manager:register_item(identifier)
  assert(self._identifier_map[identifier] == nil, "Attempted to re-register existing item: " .. identifier)
  local new_index = #self.item_registry + 1
  self.item_registry[new_index] = identifier
  self._identifier_map[identifier] = new_index -- map the identifier -> index for reverse lookup
  print("Registered [" .. new_index .. "] - " .. self.item_registry[new_index])
end

function item_manager:spawn_item(identifier, position)
  assert(identifier, "Received invalid identifier to spawn_item: " .. identifier)
  assert(position and position.x and position.y, "Received non-vector argument for position to spawn_item")
  assert(self._identifier_map[identifier], "Attempted to spawn unregistered item: " .. identifier)

  -- this is awesome as long as item entities dont require additional unique parameters
  self:getInstance():addEntity(_entities[identifier](position, self._identifier_map[identifier]))
end

function item_manager:set_collision_world(collision_world)
  self.collision_world = collision_world
end

function item_manager:update(_)
  for i = 1, self.CAN_PICKUP.size do
    self:check_for_pickups(self.CAN_PICKUP:get(i))
  end
end

function item_manager.draw(_)
end

function item_manager:check_for_pickups(e)
  assert(e:has(_components.collides), "Checking for pickups from entity with no collision component")
  assert(e:has(_components.transform), "Checking for pickups from entity with no transform component")

  -- get this entities hitbox.
  local collides = e:get(_components.collides)
  local transform = e:get(_components.transform)

  -- check the entity for collisions (filter to just items)
  local x, y = transform.position.x + collides.offset.x, transform.position.y + collides.offset.y
  local items, len = self.collision_world:queryRect(x, y, collides.width, collides.height, items_only_filter)

  local items_collided_with = {}
  -- if there's a collision, grab the inventory from this entity & insert (i guess?)
  for i = 1, len do
    if items[i].owner then
      table.insert(items_collided_with, items[i].owner)
    end
  end

  for _, entity in pairs(items_collided_with) do
    local item = entity:get(_components.item)
    print("picking up item: " .. item.id)
    --[[ TODO: actually consume the item
      - remove position component
      - remove from collision world,
      - add to inventory ]]
    --
  end
end

return item_manager
