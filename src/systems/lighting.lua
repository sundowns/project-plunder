local lighting = System({_components.transform, _components.point_light})

function lighting:init()
    self.timer = Timer.new()
    self.point_lighting_shader = love.graphics.newShader(require("src.shaders.point_lighting"))
    self.point_lighting_shader:send("ambientLight", 0.025)
end

function lighting:update(dt)
    self.timer:update(dt)

    self.point_lighting_shader:send("lightCount", self.pool.size)

    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local transform = e:get(_components.transform)
        local point_light = e:get(_components.point_light)

        transform.position = Vector(love.mouse.getPosition())
        self.point_lighting_shader:send(
            "lights[" .. i - 1 .. "].position",
            {transform.position.x, transform.position.y}
        )
        self.point_lighting_shader:send("lights[" .. i - 1 .. "].diffuse", point_light.colour)
        self.point_lighting_shader:send("lights[" .. i - 1 .. "].strength", point_light.strength)
        self.point_lighting_shader:send("lights[" .. i - 1 .. "].radius", point_light.radius)
    end
end

function lighting:attach()
    love.graphics.setShader(self.point_lighting_shader)
end

function lighting:detach()
    love.graphics.setShader()
end

return lighting
