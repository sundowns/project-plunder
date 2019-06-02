local gravity = System({_components.gravity, _components.transform, _components.player_state})

function gravity:init()
end

function gravity:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local gravity = e:get(_components.gravity)
        local transform = e:get(_components.transform)
        local behaviour = e:get(_components.player_state).behaviour

        if behaviour then
            if behaviour.state == "fall" or behaviour.state == "jump" then
                local multiplier = _constants.JUMP_SMALL_MULTIPLIER

                if e:has(_components.controlled) then
                    if e:get(_components.controlled).is_held.jump and behaviour.state == "jump" then
                        multiplier = _constants.JUMP_MULTIPLIER
                    end
                end

                if behaviour.state == "fall" then
                    multiplier = multiplier * _constants.PLAYER_FALLSPEED_MODIFIER
                end

                self:apply_gravity(transform, gravity, dt, multiplier)
            end
        else
            self:apply_gravity(transform, gravity, dt)
        end
    end
end

function gravity:apply_gravity(transform, gravity, dt, multiplier)
    transform.position.y = transform.position.y + (gravity.strength * multiplier * dt)
    transform.velocity.y =
        math.min(_constants.PLAYER_TERMINAL_VELOCITY, transform.velocity.y + (gravity.deceleration * multiplier * dt))
end

return gravity
