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
end

function item_manager:set_collision_world(collision_world)
  self.collision_world = collision_world
end

function item_manager:entityAdded(e)
end

function item_manager:entityRemoved(e)
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
  -- local actualX, actualY, cols, len = self.collision_world:queryRect(collides, x, y, items_only_filter)
  local items, len = self.collision_world:queryRect(x, y, collides.width, collides.height, items_only_filter)

  local items_collided_with = {}
  -- if there's a collision, grab the inventory from this entity & insert (i guess?)
  for i = 1, len do
    local owning_entity = items[i].owner
    if items[i].owner then
      table.insert(items_collided_with, items[i])
    end
  end

  if #items_collided_with > 0 then
    print("collided with " .. #items_collided_with .. " item(s)")
  end
end

return item_manager
