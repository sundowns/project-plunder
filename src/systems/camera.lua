local camera = System({_components.camera_target, _components.transform})

function camera:init()
    self.camera = Camera(0, 0)
end

function camera:update()
    -- only follow the first entity given camera_target (quick & dirty)
    local e = self.pool:get(1)
    local position = e:get(_components.transform).position
    self.camera:lookAt(position.x, position.y)
end

function camera:attach()
    self.camera:attach()
end

function camera:detach()
    self.camera:detach()
end

return camera
