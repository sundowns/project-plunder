local input = System({_components.controlled})

function input:init()
    self.timer = Timer.new()
    self.timer:every(
        0.01,
        function()
            self:poll_keys()
        end
    )
end

function input:poll_keys()
    for i = 1, self.pool.size do
        local controlled = self.pool:get(i):get(_components.controlled)
        local to_trigger = {}
        for key, is_held in pairs(controlled.is_held) do
            if is_held then
                self:getInstance():emit("action_held", controlled.binds[key], self.pool:get(i))
            end
        end
    end
end

function input:keypressed(key)
    for i = 1, self.pool.size do
        local controlled = self.pool:get(i):get(_components.controlled)
        local binds = controlled.binds
        if binds[key] and not controlled.is_held[key] then
            controlled.is_held[key] = true
            self:getInstance():emit("action_pressed", binds[key], self.pool:get(i))
        end
    end
end

function input:keyreleased(key)
    for i = 1, self.pool.size do
        local controlled = self.pool:get(i):get(_components.controlled)
        local binds = controlled.binds
        if binds[key] and controlled.is_held[key] then
            controlled.is_held[key] = false
            self:getInstance():emit("action_released", binds[key], self.pool:get(i))
        end
    end
end

function input:update(dt)
    self.timer:update(dt)
end

return input
