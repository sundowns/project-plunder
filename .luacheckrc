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
        "Cartographer",
        "Bump",
        "Camera",
        "_util",
        -- Our globals
        "_constants",
        "_fonts",
        "_components",
        "_entities",
        "_systems",
        "_collision_world",
        "_debug",
        "_config"
    }
}

codes = true

exclude_files = {"src/shaders/**/*.lua", "tests/**/*.lua"}
