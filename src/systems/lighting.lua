local lighting = System({_components.transform, _components.point_light})

function lighting:init()
    self.timer = Timer.new()
    self.point_lighting_shader = love.graphics.newShader(require("src.shaders.point_lighting"))
    self.point_lighting_shader:send("ambient_light", 0.0125) -- TODO: make config variable (based on brightness slider)
    self.light_breath_radius_offset = 0
    self.max_breath_offset = 2
    self.breath_randomness = 5
    self:breathe_lights()
end

function lighting:breathe_lights()
    self.timer:every(
        0.2,
        function()
            self.timer:script(
                function(wait)
                    self.timer:tween(
                        0.1,
                        self,
                        {
                            light_breath_radius_offset = self.max_breath_offset +
                                love.math.random(0, self.breath_randomness)
                        },
                        "in-out-bounce"
                    )
                    wait(0.1)
                    self.timer:tween(
                        0.1,
                        self,
                        {
                            light_breath_radius_offset = -self.max_breath_offset -
                                love.math.random(0, self.breath_randomness)
                        },
                        "in-out-bounce"
                    )
                end
            )
        end
    )
end

function lighting:camera_updated(camera)
    assert(camera)
    self.current_camera = camera
end

function lighting:update(dt)
    self.timer:update(dt)

    self.point_lighting_shader:send("num_lights", self.pool.size)
    -- self.point_lighting_shader:send("breath_offset", self.light_breath_radius_offset)

    self.light_breath_radius_offset = self.light_breath_radius_offset + dt * 100

    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local transform = e:get(_components.transform)
        local point_light = e:get(_components.point_light)
        local radius = point_light.radius
        local position = transform.position:clone()

        if e:has(_components.dimensions) then
            local dimensions = e:get(_components.dimensions)
            position.x = position.x + dimensions.width / 2
            position.y = position.y + dimensions.height / 2
        end

        if self.current_camera then
            position = Vector(self.current_camera:cameraCoords(position.x, position.y))
            radius = radius * self.current_camera.scale
        end

        self.point_lighting_shader:send("lights[" .. i - 1 .. "].position", {position.x, position.y})
        self.point_lighting_shader:send("lights[" .. i - 1 .. "].diffuse", point_light.colour)
        self.point_lighting_shader:send("lights[" .. i - 1 .. "].strength", point_light.strength)
        -- self.point_lighting_shader:send("lights[" .. i - 1 .. "].radius", radius)
    end
end

function lighting:attach_lighting()
    love.graphics.setShader(self.point_lighting_shader)
end

function lighting.detach_lighting(_)
    love.graphics.setShader()
end

return lighting
