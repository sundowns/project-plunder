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
        e.previous_states = {}
        e.state_history_buffer_size = 10
        e.behaviour:setState("fall")
        e.current_state_elapsed = 0
        e.previous_states[#e.previous_states + 1] = {
            name = "fall",
            duration = e.current_state_elapsed
        }
    end
)

function player_state:update(dt)
    self.current_state_elapsed = self.current_state_elapsed + dt
    self.behaviour:update(dt)
    if love.keyboard.isDown("p") then --delete this
        _util.t.print(self.previous_states)
    end
end

function player_state:set(new_state, instance, entity)
    assert(self.behaviour.states[new_state], "[ERR] Attempted to set non-existent state: " .. new_state)

    table.insert(self.previous_states, {name = new_state, duration = self.current_state_elapsed})
    if #self.previous_states > self.state_history_buffer_size then
        table.remove(self.previous_states, 1)
    end

    self.current_state_elapsed = 0
    self.behaviour:setState(new_state)
    instance:emit("sprite_state_updated", entity, new_state)
end

return player_state
