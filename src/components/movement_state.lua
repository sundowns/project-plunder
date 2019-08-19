local movement_state =
    Component(
    function(e, states, initial_state)
        e.behaviour = Behavior(states)
        e.previous_states = {}
        e.timer = Timer.new()
        e.is_forgiving_jump = false
        e.state_history_buffer_size = 10
        e.behaviour:setState(initial_state)
        e.current_state_elapsed = 0
        e.previous_states[#e.previous_states + 1] = {
            name = initial_state,
            duration = e.current_state_elapsed
        }
    end
)

function movement_state:update(dt)
    self.current_state_elapsed = self.current_state_elapsed + dt
    self.behaviour:update(dt)
    self.timer:update(dt)
end

function movement_state:set(new_state, instance, entity)
    assert(self.behaviour.states[new_state], "[ERR] Attempted to set non-existent state: " .. new_state)

    table.insert(self.previous_states, {name = new_state, duration = self.current_state_elapsed})
    if #self.previous_states > self.state_history_buffer_size then
        table.remove(self.previous_states, 1)
    end

    self.current_state_elapsed = 0
    self.behaviour:setState(new_state)
    instance:emit("sprite_state_updated", entity, new_state)
end

function movement_state:forgive_jump()
    self.is_forgiving_jump = true
    self.timer:after(
        0.05,
        function()
            self.is_forgiving_jump = false
        end
    )
end

return movement_state
