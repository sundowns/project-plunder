local walk =
    Component(
    function(e)
        e.accel = _constants.WALK_ACCEL
        e.maxspeed = _constants.WALK_MAXSPEED
        e.friction = _constants.FRICTION
        e.x_velocity = 0
    end
)

function walk:move(modifier)
    self.x_velocity = self.x_velocity + self.accel * modifier
    if math.abs(self.x_velocity) > self.maxspeed then
        self.x_velocity = self.maxspeed * modifier
    end
end

function walk:apply_friction(dt)
    if self.x_velocity > 0 then
        self.x_velocity = self.x_velocity - (self.friction * dt)
    elseif self.x_velocity < 0 then
        self.x_velocity = self.x_velocity + (self.friction * dt)
    end

    if math.abs(self.x_velocity) < 15 then
        self.x_velocity = 0
    end
end

return walk
