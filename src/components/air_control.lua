local air_control =
    Component(
    function(e)
        e.accel = _constants.AIRCONTROL_ACCEL
        e.maxspeed = _constants.AIRCONTROL_MAXSPEED
        e.x_velocity = 0
    end
)

function air_control:move(modifier)
    self.x_velocity = self.x_velocity + self.accel * modifier
    if math.abs(self.x_velocity) > self.maxspeed then
        self.x_velocity = self.maxspeed * modifier
    end
end

return air_control
