local camera = System({_components.camera_target, _components.transform})

function camera:init()
  self.current_camera = nil
  self.previous_position = Vector(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function camera.entityAdded(_, e)
  local entity_camera = e:get(_components.camera_target).camera
  local position = e:get(_components.transform).position
  entity_camera:lookAt(position.x, position.y)
end

function camera:update()
  -- only follow the first entity given camera_target (quick & dirty)
  local e = self.pool:get(1)
  if e then
    local target_position = e:get(_components.transform).position
    local camera_target = e:get(_components.camera_target)
    if not self.current_camera or self.current_camera.id ~= camera_target.id then
      self:set_camera(camera_target.camera)
      self.previous_position = nil
    end
    if target_position ~= self.previous_position then
      self:move_camera(e:get(_components.transform).position)
      self.previous_position = target_position
    end
  end
end

function camera:toggle_fullscreen()
  love.window.setFullscreen(not love.window.getFullscreen())
  if not love.window.getFullscreen() then
    love.window.setMode(_constants.WINDOWED_RESOLUTION.x, _constants.WINDOWED_RESOLUTION.y)
  end
  self:getInstance():emit("resize", love.graphics.getWidth(), love.graphics.getHeight())
end

function camera:set_camera(new_camera)
  self.current_camera = new_camera
  self.current_camera:zoomTo(1.8)
end

function camera:move_camera(target)
  if not self.current_camera then
    return
  end
  self.current_camera:lockPosition(target.x, target.y, Camera.smooth.damped(_constants.CAMERA_DAMPENING))

  self:getInstance():emit("camera_updated", self.current_camera)
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
