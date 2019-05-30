local air_control =
    Component(
    function(e)
        e.speed = _constants.AIRCONTROL_SPEED
        e.x_velocity = 0
    end
)

function air_control:move(modifier)
    self.x_velocity = self.speed * modifier
end

return air_control
