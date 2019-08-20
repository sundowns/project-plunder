local config_manager = {}
local config_path = "config.lua"

local get_default_config = function()
  return {
    ["DEBUG"] = false,
    ["ENABLE_LIGHTING"] = true
  }
end

config_manager.config = {}

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

function config_manager:toggle(key)
  -- assert(self.config[key] ~= nil, "Attempted to toggle non-existent config value: " .. key)
  assert(type(get_default_config()[key]) == "boolean")
  if self.config[key] == nil then
    -- fix it
    self:update_setting(key, get_default_config()[key])
  end

  self:update_setting(key, not self.config[key])
end

function config_manager:get(key)
  if self.config[key] ~= nil then
    return self.config[key]
  else
    assert(get_default_config()[key] ~= nil, "Attempted to index non-existent default config key: " .. key)
    return get_default_config()[key]
  end
end

function config_manager:update_setting(key, value)
  assert(self.config[key] == nil or type(value) == type(self.config[key]))
  self.config[key] = value
  self:save_user_config()
end

function config_manager:set_config(new_config)
  self.config = new_config
  self:save_user_config()
end

function config_manager:save_user_config()
  local file = love.filesystem.newFile(config_path)
  file:open("w")
  file:write(serialize(self.config))
  file:close()
end

return config_manager
