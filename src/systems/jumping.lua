local jumping = System({_components.controlled, _components.transform, _components.jump})

function jumping:init()
end

function jumping:action_pressed(action, entity)
    if entity:has(_components.jump) then
        self:jump(action, entity)
    end
end

function jumping:jump(action, entity)
    assert(action)
    assert(entity)
    if action ~= "jump" then
        return
    end

    local jump = entity:get(_components.jump)
    local behaviour = entity:get(_components.player_state).behaviour
    if behaviour.state == "walk" or behaviour.state == "default" then
        behaviour:setState("jump")
        self:getInstance():emit("spriteStateUpdated", entity, "jump")
        jump:jump()
    end
end

function jumping:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local jump = e:get(_components.jump)
        local transform = e:get(_components.transform)
        local behaviour = e:get(_components.player_state).behaviour
        local gravity = e:get(_components.gravity)
        local controlled = e:get(_components.controlled)

        if behaviour.state == "jump" then
            if jump.y_velocity < jump.falling_trigger_velocity then
                behaviour:setState("fall")
                self:getInstance():emit("spriteStateUpdated", e, "fall")
            end
        end

        if transform.position.y >= 500 and behaviour.state == "fall" then -- beautiful hardcoding!
            jump.y_velocity = 0
            behaviour:setState("default")
            self:getInstance():emit("spriteStateUpdated", e, "default")
        else
            local multiplier = _constants.JUMP_SMALL_MULTIPLIER

            if controlled.is_held.jump then
                if jump.y_velocity > 0 and behaviour.state ~= "fall" then
                    multiplier = _constants.JUMP_MULTIPLIER
                end
            end

            jump:update(dt, gravity, multiplier)
        end

        if behaviour.state == "jump" or behaviour.state == "fall" then
            transform.position.y = transform.position.y - jump.y_velocity
        end
    end
end

return jumping
