local stage_manager = System()

function stage_manager:init()
    self.stage = nil
    self.collision_world = nil
end

function stage_manager:load_stage(path)
    self.stage = STI(path, {"bump"})
    assert(self.collision_world, "stage_manager attempted to load stage with collision world unset")
    self.stage:bump_init(self.collision_world)
end

function stage_manager:set_collision_world(collision_world)
    self.collision_world = collision_world
end

function stage_manager:draw()
    if self.stage then
        self.stage:draw()
        if _debug then
            self.stage:bump_draw(self.collision_world)
        end
    end
end

function stage_manager:update(dt)
    if self.stage then
        self.stage:update(dt)
    end
end

return stage_manager
