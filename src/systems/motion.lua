local motion = System({_components.transform})

function motion:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local transform = e:get(_components.transform)

        transform.position = transform.position + transform.velocity * dt

        -- temp code to move puddy back to left of screen
        if transform.position.x > love.graphics.getWidth() then
            transform.position.x = 0
        end
    end
end

return motion
