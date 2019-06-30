package.path = "../libs/?.lua;../libs/?/init.lua;../src/?/init.lua;../src/?.lua;" .. package.path

local function init_ecs_world()
    ECS =
        require("concord").init(
        {
            useEvents = false
        }
    )
    Component = require("concord.component")
    Entity = require("concord.entity")
    Instance = require("concord.instance")
    System = require("concord.system")
    _components = require("components")
    _entities = require("entities")
end

local function load_dependencies()
    Timer = require("timer")
    Vector = require("vector")
    Behavior = require("behavior")
    _util = require("util")
    init_ecs_world()
end

load_dependencies()