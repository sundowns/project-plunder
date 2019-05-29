local gravity = System({_components.gravity, _components.transform})

function gravity:init()
end

function gravity:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local gravity = e:get(_components.gravity)
        local transform = e:get(_components.transform)

        if transform.position.y < 500 then --beautiful hardcoding
            transform.position.y = transform.position.y + (gravity.strength * dt)
        end
    end
end

return gravity
