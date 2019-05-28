local sprite_renderer = System({_components.sprite, _components.transform})

function sprite_renderer:init()
    self.spriteBank = {}
end

function sprite_renderer:entityAdded(e)
    local sprite = e:get(_components.sprite)
    local instance = self:createInstance(sprite.name)
    sprite:setAnimationData(instance)
end

function sprite_renderer:draw()
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local img = e:get(_components.sprite)
        local position = e:get(_components.transform).position
        local flipped = e:has(_components.direction) and e:get(_components.direction).value == "LEFT"

        if img.visible then
            self:drawSpriteInstance(
                img.animation,
                Vector(position.x + img.offset_x, position.y + img.offset_y),
                0,
                img.sx,
                img.sy,
                flipped
            )
        end
    end
end

function sprite_renderer:loadSpriteSheet(spriteName)
    local err, sprite_file
    sprite_file, err = love.filesystem.load("src/animations/" .. string.lower(spriteName) .. ".lua")
    if not sprite_file then
        print("[ERROR] The following error happend: " .. tostring(err))
        return nil
    end

    self.spriteBank[spriteName] = sprite_file()
    return self.spriteBank[spriteName]
end

function sprite_renderer:createInstance(spriteName, currentState)
    if spriteName == nil then
        return nil
    end

    if self.spriteBank[spriteName] == nil then
        if self:loadSpriteSheet(spriteName) == nil then
            return nil
        end
    end

    -- If the specified state does not exist, use the first one
    if self.spriteBank[spriteName].layers[1][currentState] == nil then
        currentState = self.spriteBank[spriteName].animation_names[1]
    end

    return {
        animations = self:retrieveLayerInstances(spriteName, currentState),
        sprite = self.spriteBank[spriteName],
        currentState = currentState,
        time_scale = 1 --slow-mo?
    }
end

function sprite_renderer:spriteStateUpdated(entity, newState)
    local sprite = entity:get(_components.sprite)
    sprite.animation.animations = self:retrieveLayerInstances(sprite.animation.sprite.id, newState)
end

function sprite_renderer:update(dt)
    for i = 1, self.pool.size do
        local e = self.pool:get(i)
        local sprite = e:get(_components.sprite)
        for i, layer in pairs(sprite.animation.animations) do
            layer.animation:update(dt)
        end
    end
end

function sprite_renderer:drawSpriteInstance(instance, position, orientation, sx, sy, flipped)
    for i, layer in pairs(instance.animations) do
        local w, h = layer.animation:getDimensions()
        local offset_position_x = position.x
        if flipped then
            offset_position_x = offset_position_x + w * sx
            sx = sx * -1
        end
        layer.animation:draw(instance.sprite.image, offset_position_x, position.y, orientation or 0, sx, sy)
    end
end

function sprite_renderer:retrieveLayerInstances(spriteName, currentState)
    local layers = {}
    for i, layer in pairs(self.spriteBank[spriteName].layers) do
        local anim_data = layer[currentState]
        table.insert(
            layers,
            {
                animation = anim8.newAnimation(
                    self.spriteBank[spriteName].grid(anim_data.x, anim_data.y),
                    anim_data.frame_duration
                ),
                origin = Vector(anim_data.offset_x, anim_data.offset_y),
                rotation = anim_data.rotation,
                scale = Vector(anim_data.scale_x or 1, anim_data.scale_y or 1)
            }
        )
    end

    return layers
end

return sprite_renderer
