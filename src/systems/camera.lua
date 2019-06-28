local camera = System({_components.camera_target, _components.transform})

function camera:init()
    self.current_camera = nil
    self.previous_position = Vector(0, 0)
    self.zoom = 1.5
end

function camera:update()
    -- only follow the first entity given camera_target (quick & dirty)
    local e = self.pool:get(1)
    if e then
        local target_position = e:get(_components.transform).position
        local camera_target = e:get(_components.camera_target)
        if not self.current_camera or self.current_camera.id ~= camera_target.id then
            self:set_camera(camera_target.camera)
        end
        if target_position ~= self.previous_position then
            self:move_camera(e:get(_components.transform).position)
            self.previous_position = target_position
        end
    end
end

function camera:set_camera(new_camera)
    -- self.current_camera = new_camera
    -- self.current_camera:zoomTo(self.zoom) -- TODO: make shader work with zoom (and mouse pos)
end

function camera:move_camera(target)
    if not self.current_camera then
        return
    end
    self.current_camera:lookAt(target.x, target.y)
    local cam_x, cam_y = self.current_camera:worldCoords(target.x, target.y)

    self:getInstance():emit("camera_moved", Vector(target.x - cam_x, target.y - cam_y))
end

function camera:attach()
    if self.current_camera then
        self.current_camera:attach()
    end
end

function camera:detach()
    if self.current_camera then
        self.current_camera:detach()
    end
end

return camera
