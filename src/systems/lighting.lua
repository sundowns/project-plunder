local lighting = System({_components.transform})

function lighting:init()
    self.timer = Timer.new()
    self.point_lighting_shader = love.graphics.newShader(require("src.shaders.point_lighting"))
end

function lighting:update(dt)
    self.timer:update(dt)

    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local transform = e:get(_components.transform)
    end
end

function lighting:draw()
end

return lighting
