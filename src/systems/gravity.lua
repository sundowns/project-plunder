local gravity = System({_components.gravity, _components.transform})

local FLOOR = 500 -- crazy hack

function gravity:init()
end

function gravity:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local gravity = e:get(_components.gravity)
        local transform = e:get(_components.transform)
        local state = e:get(_components.player_state).behaviour

        transform.position.y = math.min((transform.position.y + (gravity.strength * dt)), FLOOR)
    end
end

return gravity
