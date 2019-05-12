local encircling = System({_components.transform, _components.encircle})

function encircling:init()
end

--WIP
function encircling:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local transform = e:get(_components.transform)
        local encircle = e:get(_components.encircle)
        local target = encircle.target_entity

        -- get encircling target if it exists
        if target then
            -- move circling origin to target position
            encircle:update_origin(target:get(_components.transform).position)
        end

        -- vector from centre of screen to mouse position
        local mouse = Vector(love.mouse.getPosition())
        local centre = Vector(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        -- normalise and multiple by radius
        local resultant = (mouse - centre):normalized()

        local origin_x, origin_y = encircle.origin.x, encircle.origin.y
        if target:has(_components.dimensions) then
            -- offset based on target's dimensions (if applicable)
            local dimensions = target:get(_components.dimensions)
            origin_x = origin_x + dimensions.width / 2
            origin_y = origin_y + dimensions.height / 2
        end

        -- use vector to update position of transform
        transform.position = Vector(origin_x, origin_y) + resultant * encircle.radius
    end
end

function encircling:draw_debug()
    if _debug then
        for i = 1, self.pool.size do
            local e = self.pool:get(i)
            local transform = e:get(_components.transform)
            love.graphics.circle("fill", transform.position.x, transform.position.y, 4)
        end
    end
end

return encircling
