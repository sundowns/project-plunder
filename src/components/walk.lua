local walk =
    Component(
    function(e)
        e.speed = _constants.WALK_SPEED
        e.friction = _constants.FRICTION
        e.x_velocity = 0
    end
)

function walk:move(modifier)
    self.x_velocity = self.speed * modifier
end

function walk:apply_friction(dt)
    if self.x_velocity > 0 then
        self.x_velocity = self.x_velocity - (self.friction * dt)
    elseif self.x_velocity < 0 then
        self.x_velocity = self.x_velocity + (self.friction * dt)
    end

    if math.abs(self.x_velocity) < 20 then
        self.x_velocity = 0
    end
end

return walk
