-- GLobals
_debug = false
_constants = nil
_components = nil
_entities = nil
_instances = nil
_systems = nil

-- Libraries
ECS = nil
Component = nil
Entity = nil
Instance = nil
System = nil
_util = nil

function love.load()
    -- love.graphics.setDefaultFilter("nearest", "nearest", 0)
    _constants = require("src.constants")
    _util = require("libs.util")
    ECS =
        require("libs.concord").init(
        {
            useEvents = false
        }
    )
    Component = require("libs.concord.component")
    Entity = require("libs.concord.entity")
    Instance = require("libs.concord.instance")
    System = require("libs.concord.system")

    _components = require("src.components")
    _entities = require("src.entities")
    _systems = require("src.systems")
    _instances = require("src.instances")
end

function love.update(dt)
end

function love.draw()
end

function love.keypressed(key)
    if key == "space" then
        love.event.quit("restart")
    elseif key == "escape" then
        love.event.quit()
    elseif key == "f1" then
        _debug = not _debug
    end
end
