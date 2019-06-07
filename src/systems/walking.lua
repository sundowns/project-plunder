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

    if entity:has(_components.player_state) then
        local player_state = entity:get(_components.player_state)
        if player_state.behaviour.state == "default" then
            player_state:set("walk", self:getInstance(), entity)
        end
    end
end

function walking:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local walk = e:get(_components.walk)
        walk:apply_friction(dt)

        if e:has(_components.player_state) then
            local player_state = e:get(_components.player_state)
            if player_state.behaviour.state ~= "jump" and player_state.behaviour.state ~= "fall" then
                local transform = e:get(_components.transform)
                transform.position.x = transform.position.x + (walk.x_velocity * dt)
            end
            if player_state.behaviour.state == "walk" and walk.x_velocity == 0 then
                player_state:set("default", self:getInstance(), e)
            end
        end
    end
end

return walking
