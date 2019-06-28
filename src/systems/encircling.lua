local encircling = System({_components.transform, _components.encircle})

function encircling:update(_)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local transform = e:get(_components.transform)
        local encircle = e:get(_components.encircle)
        local target = encircle.target_entity
        local player_is_targetting = false

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

            if target:has(_components.controlled) then
                local controlled = target:get(_components.controlled)

                if controlled.is_held["target_light"] then
                    player_is_targetting = true
                end
            end
        end

        if player_is_targetting then
            -- vector from centre of screen to mouse position
            local mouse_pos = Vector(love.mouse.getPosition())
            local origin = encircle.origin
            if target:has(_components.camera_target) then
                mouse_pos = Vector(target:get(_components.camera_target).camera:worldCoords(mouse_pos.x, mouse_pos.y))
            end

            -- normalise and multiply by desired length
            local to_mouse = (mouse_pos - origin)
            local resultant = to_mouse:normalized()
            local magnitude = math.min(to_mouse:len(), encircle.radius)

            -- use vector to update position of transform
            transform.position = origin + resultant * magnitude
        else
            transform.position = encircle.origin
        end
    end
end

function encircling:draw_debug()
    if _debug then
        for i = 1, self.pool.size do
            local e = self.pool:get(i)
            local transform = e:get(_components.transform)
            local encircle = e:get(_components.encircle)
            if encircle.target_entity:has(_components.camera_target) then
                local player_position_via_camera =
                    Vector(
                    encircle.target_entity:get(_components.camera_target).camera:cameraCoords(
                        transform.position.x,
                        transform.position.y
                    )
                )
                love.graphics.circle("fill", player_position_via_camera.x, player_position_via_camera.y, 4)
            else
                love.graphics.circle("fill", transform.position.x, transform.position.y, 4)
            end
        end
    end
end

return encircling
