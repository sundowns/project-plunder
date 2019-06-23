local walking = System({_components.controlled, _components.transform, _components.walk})

function walking:init()
end

function walking:action_pressed(action, entity)
    if entity:has(_components.walk) then
        self:walk(action, entity)
    end
end

function walking:action_held(action, entity)
    if entity:has(_components.walk) then
        self:walk(action, entity)
    end
end

function walking:walk(action, entity)
    assert(action)
    assert(entity)
    if action ~= "left" and action ~= "right" then
        return
    end

    if entity:has(_components.movement_state) then
        local movement_state = entity:get(_components.movement_state)
        if movement_state.behaviour.state == "default" then
            movement_state:set("walk", self:getInstance(), entity)
        end

        if movement_state.behaviour.state ~= "walk" then
            return
        end
    end

    local direction_modifier = 1
    if action == "left" then
        direction_modifier = -1
    end

    local walk = entity:get(_components.walk)
    walk:move(direction_modifier)

    local direction = entity:get(_components.direction)
    if direction and direction.value ~= action then
        direction:set(action) --left or right
    end
end

function walking:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local walk = e:get(_components.walk)
        walk:apply_friction(dt)

        if e:has(_components.movement_state) then
            local movement_state = e:get(_components.movement_state)
            if movement_state.behaviour.state == "walk" or movement_state.behaviour.state == "default" then
                local transform = e:get(_components.transform)
                transform.position.x = transform.position.x + (walk.x_velocity * dt)
            end
            if movement_state.behaviour.state == "walk" and walk.x_velocity == 0 then
                movement_state:set("default", self:getInstance(), e)
            end
        end
    end
end

return walking
