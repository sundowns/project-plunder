local states = {
    default = {
        {duration = 1}
    },
    walk = {
        {duration = 1}
    },
    jump = {
        {duration = 1}
    },
    fall = {
        {duration = 1}
    }
}

local player_state =
    Component(
    function(e)
        e.behaviour = Behavior(states)
        e.behaviour:setState("fall")
    end
)

function player_state:update(dt)
    self.behaviour:update(dt)
end

return player_state
