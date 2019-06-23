local air_control =
    System({_components.controlled, _components.transform, _components.air_control, _components.collides})

function air_control:init()
    self.collision_world = nil
end

function air_control:set_collision_world(collision_world)
    self.collision_world = collision_world
end

function air_control:action_pressed(action, entity)
    if entity:has(_components.air_control) then
        self:move(action, entity)
    end
end

function air_control:action_held(action, entity)
    if entity:has(_components.air_control) then
        self:move(action, entity)
    end
end

function air_control:move(action, entity)
    assert(action)
    assert(entity)
    if action ~= "left" and action ~= "right" then
        return
    end

    if entity:has(_components.movement_state) then
        local state = entity:get(_components.movement_state).behaviour.state
        if state ~= "jump" and state ~= "fall" and state ~= "wallslide" then
            return
        end
    end

    local direction_modifier = 1
    if action == "left" then
        direction_modifier = -1
    end

    local air_controlled = entity:get(_components.air_control)
    air_controlled:move(direction_modifier)

    if entity:has(_components.direction) then
        local direction = entity:get(_components.direction)
        direction:set(action) --left or right
    end
end

function air_control:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local air_controlled = e:get(_components.air_control)
        local transform = e:get(_components.transform)
        local movement_state = e:get(_components.movement_state)

        if e:has(_components.movement_state) then
            local behaviour = movement_state.behaviour
            if behaviour.state == "jump" or behaviour.state == "fall" or behaviour.state == "wallslide" then
                transform.position.x = transform.position.x + (air_controlled.x_velocity * dt)
            else
                air_controlled.x_velocity = 0
            end

            -- test to see if we should wallslide
            if behaviour.state == "fall" or "wallslide" then
                local collides = e:get(_components.collides)
                local items_left, len_left =
                    self.collision_world:queryPoint(
                    transform.position.x + (collides.offset.x * -(_constants.Y_OFFSET_TO_TEST_PLAYER_IS_GROUNDED)),
                    transform.position.y + collides.offset.y
                )

                local items_right, len_right =
                    self.collision_world:queryPoint(
                    transform.position.x + collides.offset.x +
                        collides.width * (_constants.Y_OFFSET_TO_TEST_PLAYER_IS_GROUNDED),
                    transform.position.y + collides.offset.y
                )

                -- only do it if player still holding current direction
                local controlled = e:get(_components.controlled)
                local direction = e:get(_components.direction)
                if len_left > 0 and direction.value == "LEFT" then
                    if not controlled.is_held["left"] then
                        if movement_state.behaviour.state == "wallslide" then
                            movement_state:set("fall", self:getInstance(), e)
                        end
                    else
                        if movement_state.behaviour.state == "fall" then
                            movement_state:set("wallslide", self:getInstance(), e)
                        end
                    end
                elseif len_right > 0 and direction.value == "RIGHT" then
                    if not controlled.is_held["right"] then
                        if movement_state.behaviour.state == "wallslide" then
                            movement_state:set("fall", self:getInstance(), e)
                        end
                    else
                        if movement_state.behaviour.state == "fall" then
                            movement_state:set("wallslide", self:getInstance(), e)
                        end
                    end
                end
                print(movement_state.behaviour.state)
            end
        end
    end
end

return air_control
