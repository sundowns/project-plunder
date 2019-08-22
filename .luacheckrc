std = {
  globals = {
    -- these globals can only be accessed.
    -- Standard Lua library
    "math",
    "pairs",
    "ipairs",
    "string",
    "require",
    "table",
    "assert",
    "tostring",
    "print",
    "setfenv",
    "type",
    "loadstring",
    "match",
    "package",
    "tonumber",
    -- Third party libraries
    "love",
    "resources",
    "anim8",
    "serialize",
    "Vector",
    "Behavior",
    "Timer",
    "ECS",
    "Entity",
    "Component",
    "System",
    "Instance",
    "Mappy",
    "Bump",
    "Camera",
    "_util",
    "luassert",
    -- Our globals
    "_constants",
    "_fonts",
    "_components",
    "_entities",
    "_systems",
    "_collision_world",
    "_config"
  },
  read_globals = {"T"}
}

max_line_length = 140

codes = true

exclude_files = {"src/shaders/**/*.lua", "tests/**/*.lua"}
