std = {
    globals = {}, -- these globals can be set and accessed.
    read_globals = {
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
        -- Third party libraries
        "love",
        "resources",
        "anim8",
        "Vector",
        "Behavior",
        "Timer",
        "Entity",
        "Component",
        "System",
        "Instance",
        "Cartographer",
        "Camera",
        "_util",
        -- Our globals
        "_constants",
        "_components",
        "_systems",
        "_debug"
    }
}

codes = true

exclude_files = {"src/shaders/**/*.lua"}
