local jumping = System({_components.controlled, _components.transform, _components.jump})

function jumping:init()
end

function jumping:action_pressed(action, entity)
    if entity:has(_components.jump) then
        self:jump(action, entity)
    end
end

function jumping:action_held(action, entity)
    if entity:has(_components.jump) then
        self:jump(action, entity)
    end
end

function jumping:jump(action, entity)
    assert(action)
    assert(entity)
    if action ~= "space" then
        return
    end

    local jump = entity:get(_components.jump)
    local state = entity:get(_components.player_state)
    if state.state == "walk" then
        state.state = "jump"
        jump:jump()
    end
end

function jumping:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local jump = e:get(_components.jump)
        local transform = e:get(_components.transform)
        local behaviour = e:get(_components.player_state)

        if behaviour.state == "jump" then
            jump:decay(dt)
            if jump.y_velocity < jump.falling_trigger_velocity then
                behaviour.state = "fall"
            end
        end

        if transform.position.y > 500 and behaviour.state == "fall" then -- beautiful hardcoding!
            jump.y_velocity = 0
            behaviour.state = "walk"
        else
            transform.position.y = transform.position.y - jump.y_velocity * dt
        end
        print(behaviour.state)
        print(jump.y_velocity)
    end
end

return jumping
