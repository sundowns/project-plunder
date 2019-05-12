local encircling = System({_components.transform, _components.encircle})

function encircling:init()
end

function encircling:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local transform = e:get(_components.transform)
        local encircle = e:get(_components.encircle)
        local target = encircle.target_entity

        -- get encircling target if it exists
        if target then
            -- move circling origin to target position
            local new_origin = target:get(_components.transform).position:clone()
            if target:has(_components.dimensions) then
                -- offset based on target's dimensions (if applicable)
                local dimensions = target:get(_components.dimensions)
                new_origin.x = new_origin.x + dimensions.width / 2
                new_origin.y = new_origin.y + dimensions.height / 2
            end
            encircle:update_origin(new_origin)
        end

        -- vector from centre of screen to mouse position
        local mouse = Vector(love.mouse.getPosition())

        -- normalise and multiply by desired length
        local to_mouse = (mouse - encircle.origin)
        local resultant = to_mouse:normalized()
        local magnitude = math.min(to_mouse:len(), encircle.radius)

        -- use vector to update position of transform
        transform.position = encircle.origin + resultant * magnitude
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
