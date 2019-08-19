local collider = System({_components.collides, _components.transform, "ALL"})

function collider:init()
    self.collision_world = nil
end

function collider:set_collision_world(collision_world)
    self.collision_world = collision_world
end

function collider:entityAdded(e)
    local position = e:get(_components.transform).position
    local collides = e:get(_components.collides)
    collides:set_owner(e)
    self.collision_world:add(collides, position.x, position.y, collides.width, collides.height)
end

function collider:entityRemoved(e)
    self.collision_world:remove(e:get(_components.collides))
end

function collider:update(_)
    for i = 1, self.ALL.size do
        local e = self.ALL:get(i)
        self:update_entity(e)
    end
end

function collider:draw()
    if _config:get("DEBUG") then
        love.graphics.setColor(1, 0, 0)
        love.graphics.setLineWidth(1)
        local items, _ = self.collision_world:getItems()
        for i = #items, 1, -1 do
            love.graphics.rectangle("line", self.collision_world:getRect(items[i]))
        end
        _util.l.resetColour()
    end
end

-- Used to moving tiles & hazards (only hazards are used)
function collider:update_entity(e)
    local transform = e:get(_components.transform)
    local collides = e:get(_components.collides)
    local actualX, actualY, _, _ =
        self.collision_world:move(
        collides,
        transform.position.x + collides.offset.x,
        transform.position.y + collides.offset.y,
        function(item, other)
            if not item.collides_with then
                return "slide"
            end
            if string.match(item.collides_with, other.type) then
                return "slide"
            else
                return "cross"
            end
        end
    )
    transform:setPosition(Vector(actualX - collides.offset.x, actualY - collides.offset.y))
end

return collider
