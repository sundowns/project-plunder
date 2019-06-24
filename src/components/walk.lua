local walk =
    Component(
    function(e)
        e.acceleration = _constants.WALK_ACCELERATION
        e.max_speed = _constants.WALK_MAX_SPEED
        e.friction = _constants.FRICTION
    end
)

function walk:move(transform, modifier)
    local speed = transform.velocity.x + self.acceleration * modifier
    if math.abs(speed) > self.max_speed then
        speed = self.max_speed * modifier
    end
    transform.velocity.x = speed
end

function walk:apply_friction(transform, dt)
    if transform.velocity.x > 0 then
        transform.velocity.x = transform.velocity.x - (self.friction * dt)
    elseif transform.velocity.x < 0 then
        transform.velocity.x = transform.velocity.x + (self.friction * dt)
    end

    if math.abs(transform.velocity.x) < 15 then
        transform.velocity.x = 0
    end
end

return walk
