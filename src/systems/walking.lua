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

    if entity:has(_components.direction) then
        local direction = entity:get(_components.direction)
        direction:set(action) --left or right
    end

    if entity:has(_components.player_state) then
        local behaviour = entity:get(_components.player_state).behaviour
        if behaviour.state == "default" then
            behaviour:setState("walk")
            self:getInstance():emit("spriteStateUpdated", entity, "walk")
        end
    end
end

function walking:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local walk = e:get(_components.walk)
        walk:apply_friction(dt)

        local transform = e:get(_components.transform)
        transform.position.x = transform.position.x + (walk.x_velocity * dt)

        if e:has(_components.player_state) then
            local behaviour = e:get(_components.player_state).behaviour
            if behaviour.state == "walk" and walk.x_velocity == 0 then
                behaviour:setState("default")
                self:getInstance():emit("spriteStateUpdated", e, "default")
            end
        end
    end
end

return walking
