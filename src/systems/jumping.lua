local jumping =
    System({_components.transform, _components.jump, _components.movement_state, _components.collides, "ALL"})

function jumping:init()
    self.collision_world = nil
end

function jumping:set_collision_world(collision_world)
    self.collision_world = collision_world
end

function jumping:action_pressed(action, entity)
    if entity:has(_components.jump) then
        self:jump(action, entity)
    end
end

function jumping:action_held(action, entity)
end

function jumping:jump(action, entity)
    assert(action)
    assert(entity)
    if action ~= "jump" then
        return
    end

    local jump = entity:get(_components.jump)
    local movement_state = entity:get(_components.movement_state)
    local air_controlled = entity:get(_components.air_control)
    local walk = entity:get(_components.walk)
    local transform = entity:get(_components.transform)
    if
        movement_state.behaviour.state == "walk" or movement_state.behaviour.state == "default" or
            movement_state.is_forgiving_jump
     then
        movement_state:set("jump", self:getInstance(), entity)
        air_controlled.x_velocity = walk.x_velocity * _constants.PLAYER_GROUND_TO_AIR_MOMENTUM_CONSERVATION_RATIO

        transform.velocity.y = -jump.jump_velocity
    end
end

function jumping:update(dt)
    for i = 1, self.ALL.size do
        local e = self.ALL:get(i)
        local jump = e:get(_components.jump)
        local transform = e:get(_components.transform)
        local movement_state = e:get(_components.movement_state)
        local gravity = e:get(_components.gravity).deceleration or 0
        local collides = e:get(_components.collides)

        if movement_state.behaviour.state == "jump" then
            if transform.velocity.y > jump.falling_trigger_velocity then -- check for transition to falling state
                movement_state:set("fall", self:getInstance(), e)
            else
                -- query to see if player headbonks
                local items, len =
                    self.collision_world:queryRect(
                    transform.position.x + collides.offset.x + collides.width * 0.2,
                    transform.position.y + collides.offset.y - 1,
                    collides.width * 0.6,
                    0.1
                )
                if len > 0 then
                    movement_state:set("fall", self:getInstance(), e)
                end
            end
        end

        -- query to see if player is falling
        if movement_state.behaviour.state == "walk" or movement_state.behaviour.state == "default" then
            local items_left, len_left =
                self.collision_world:queryPoint(
                transform.position.x + collides.offset.x,
                transform.position.y + collides.offset.y +
                    collides.height * _constants.Y_OFFSET_TO_TEST_PLAYER_IS_GROUNDED
            )

            local items_centre, len_centre =
                self.collision_world:queryPoint(
                transform.position.x + collides.offset.x + collides.width / 2,
                transform.position.y + collides.offset.y +
                    collides.height * _constants.Y_OFFSET_TO_TEST_PLAYER_IS_GROUNDED
            )

            local items_right, len_right =
                self.collision_world:queryPoint(
                transform.position.x + collides.offset.x + collides.width,
                transform.position.y + collides.offset.y +
                    collides.height * _constants.Y_OFFSET_TO_TEST_PLAYER_IS_GROUNDED
            )
            if len_left == 0 and len_right == 0 and len_centre == 0 then
                movement_state:set("fall", self:getInstance(), e)
                movement_state:forgive_jump()
                if e:has(_components.controlled) and e:has(_components.direction) then
                    local controlled = e:get(_components.controlled)
                    local direction = e:get(_components.direction)
                    local held_modifier = 0.25
                    if not controlled.is_held[string.lower(direction.value)] then
                        held_modifier = 1
                    end

                    e:get(_components.air_control).x_velocity =
                        e:get(_components.walk).x_velocity *
                        _constants.PLAYER_WALK_OFF_LEDGE_MOMENTUM_CONSERVATION_RATIO *
                        held_modifier
                end
            end
        end

        -- check if player has landed
        if movement_state.behaviour.state == "fall" then
            local items_left, len_left =
                self.collision_world:queryPoint(
                transform.position.x + collides.offset.x,
                transform.position.y + collides.offset.y +
                    collides.height * _constants.Y_OFFSET_TO_TEST_PLAYER_IS_GROUNDED
            )

            local items_centre, len_centre =
                self.collision_world:queryPoint(
                transform.position.x + collides.offset.x + collides.width / 2,
                transform.position.y + collides.offset.y +
                    collides.height * _constants.Y_OFFSET_TO_TEST_PLAYER_IS_GROUNDED
            )

            local items_right, len_right =
                self.collision_world:queryPoint(
                transform.position.x + collides.offset.x + collides.width,
                transform.position.y + collides.offset.y +
                    collides.height * _constants.Y_OFFSET_TO_TEST_PLAYER_IS_GROUNDED
            )
            if len_centre > 0 or len_right > 0 or len_left > 0 then
                transform.velocity.y = 0
                if e:has(_components.walk) then
                    if e:has(_components.air_control) then
                        -- only do it if player still holding current direction
                        if e:has(_components.controlled) and e:has(_components.direction) then
                            local controlled = e:get(_components.controlled)
                            local direction = e:get(_components.direction)
                            local held_modifier = 0.25
                            if not controlled.is_held[string.lower(direction.value)] then
                                held_modifier = 1
                            end

                            e:get(_components.walk).x_velocity =
                                e:get(_components.air_control).x_velocity *
                                _constants.PLAYER_AIR_TO_GROUND_MOMENTUM_CONSERVATION_RATIO *
                                held_modifier
                        end
                    end
                    movement_state:set("walk", self:getInstance(), e)
                    -- clear jump forgiveness timer
                    movement_state.timer:clear()
                end
            end
        end
    end
end

function jumping:draw()
    if _debug then
        love.graphics.setColor(0, 1, 1)
        for i = 1, self.ALL.size do
            local e = self.ALL:get(i)
            local jump = e:get(_components.jump)
            local transform = e:get(_components.transform)
            local collides = e:get(_components.collides)

            local left =
                Vector(
                transform.position.x + collides.offset.x,
                transform.position.y + collides.offset.y +
                    collides.height * _constants.Y_OFFSET_TO_TEST_PLAYER_IS_GROUNDED
            )

            local right =
                Vector(
                transform.position.x + collides.offset.x + collides.width,
                transform.position.y + collides.offset.y +
                    collides.height * _constants.Y_OFFSET_TO_TEST_PLAYER_IS_GROUNDED
            )

            local centre =
                Vector(
                transform.position.x + collides.offset.x + collides.width / 2,
                transform.position.y + collides.offset.y +
                    collides.height * _constants.Y_OFFSET_TO_TEST_PLAYER_IS_GROUNDED
            )

            love.graphics.circle("fill", left.x, left.y, 2)
            love.graphics.circle("fill", right.x, right.y, 2)
            love.graphics.circle("fill", centre.x, centre.y, 2)
        end
        _util.l.resetColour()
    end
end

return jumping
