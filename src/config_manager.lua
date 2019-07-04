local config_manager = {}
local config_path = "config.lua"
local get_default_config = function()
    return {
        ["ENABLE_LIGHTING"] = true
    }
end

function config_manager:toggle(key)
    assert(self._config[key] ~= nil, "Attempted to toggle non-existent config value: " .. key)
    assert(type(self._config[key]) == "boolean")

    self:update_setting(key, not self._config[key])
end

function config_manager:init()
    self._config = get_default_config()
    self:fetch_user_config()
end

function config_manager:get(key)
    if self._config[key] ~= nil then
        return self._config[key]
    else
        assert(false, "non-existent key in config: " .. key)
    end
end

function config_manager:update_setting(key, value)
    assert(not self._config[key] or type(value) == type(self._config[key]))
    self._config[key] = value
    self:save_user_config()
end

function config_manager:set_config(new_config)
    -- for each key -- TODO:
    --   if in new_config
    --      set from new_config
    --   else set from default
    self._config = new_config
    self:save_user_config()
end

function config_manager:fetch_user_config()
    local contents, _ = love.filesystem.read(config_path)
    if contents then
        local data = setfenv(loadstring(contents), {})()
        if data then
            self:set_config(data)
        else
            self:set_config(get_default_config())
        end
    else
        -- no config file, use defaults
        self:set_config(get_default_config())
    end
end

function config_manager:save_user_config()
    local file = love.filesystem.newFile(config_path)
    file:open("w")
    file:write(serialize(self._config))
end

config_manager:init()

return config_manager
