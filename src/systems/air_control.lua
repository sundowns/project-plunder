local air_control = System({_components.controlled, _components.transform, _components.air_control})

function air_control:init()
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

    if entity:has(_components.player_state) then
        local state = entity:get(_components.player_state).behaviour.state
        if state ~= "jump" and state ~= "fall" then
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

        if e:has(_components.player_state) then
            local behaviour = e:get(_components.player_state).behaviour
            if behaviour.state == "jump" or behaviour.state == "fall" then
                transform.position.x = transform.position.x + (air_controlled.x_velocity * dt)
            else
                air_controlled.x_velocity = 0
            end
        end
    end
end

return air_control
