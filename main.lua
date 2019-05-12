-- Globals
_debug = false
_constants = nil
_components = nil
_entities = nil
_systems = nil
_fonts = nil

local _instances = nil -- should not have visbility of each other...

-- Libraries
_util = nil
ECS = nil
Component = nil
Entity = nil
Instance = nil
System = nil
Vector = nil
Timer = nil

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    _constants = require("src.constants")
    _util = require("libs.util")
    anim8 = require("libs.anim8")
    resources = require("libs.cargo").init("resources")
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
    Timer = require("libs.timer")
    Vector = require("libs.vector")

    _fonts = {
        ["DEBUG"] = resources.fonts.all_business(20)
    }
    love.graphics.setFont(_fonts.DEBUG)

    _components = require("src.components")
    _entities = require("src.entities")
    _systems = require("src.systems")
    _instances = require("src.instances")

    _instances.world:addEntity(_entities.player(Vector(love.graphics.getWidth() / 10, love.graphics.getHeight() / 2)))
end

function love.update(dt)
    _instances.world:emit("update", dt)
end

function love.draw()
    _instances.world:emit("draw", dt)
    love.graphics.print("yeetus")
end

function love.keyreleased(key)
    _instances.world:emit("keyreleased", key)
end

function love.keypressed(key)
    if key == "space" then
        love.event.quit("restart")
    elseif key == "escape" then
        love.event.quit()
    elseif key == "f1" then
        _debug = not _debug
    end

    _instances.world:emit("keypressed", key)
end
