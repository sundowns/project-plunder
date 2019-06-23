-- Globals
_debug = true
_constants = nil
_components = nil
_entities = nil
_systems = nil
_fonts = nil
_collision_world = nil

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
Bump = nil
STI = nil
Camera = nil

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
    Behavior = require("libs.behavior")
    Bump = require("libs.bump")
    STI = require("libs.sti")
    Camera = require("libs.camera")

    _fonts = {
        ["DEBUG"] = resources.fonts.all_business(20)
    }
    love.graphics.setFont(_fonts.DEBUG)

    _components = require("src.components")
    _entities = require("src.entities")
    _systems = require("src.systems")
    _instances = require("src.instances")
    _collision_world = Bump.newWorld(32)

    _instances.world:emit("set_collision_world", _collision_world)
    _instances.world:emit("load_stage", "resources/stage/test.lua")

    local player = _entities.player(Vector(love.graphics.getWidth() / 4, love.graphics.getHeight() / 2))
    _instances.world:addEntity(player)
    _instances.world:emit("sprite_state_updated", player, "run")
    _instances.world:addEntity(_entities.light_source(Vector(0, 0), player))
end

function love.update(dt)
    _instances.world:emit("update", dt)
end

function love.draw()
    _instances.world:emit("attach_lighting")
    _instances.world:emit("attach")
    _instances.world:emit("draw")
    _instances.world:emit("detach")
    _instances.world:emit("detach_lighting")
    _instances.world:emit("draw_debug")
    -- _instances.world:emit("draw_ui")
end

function love.keyreleased(key)
    _instances.world:emit("keyreleased", key)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" then
        --love.event.quit("restart")
    elseif key == "escape" then
        love.event.quit()
    elseif key == "f1" then
        _debug = not _debug
    end

    _instances.world:emit("keypressed", key)
end

function love.mousepressed(x, y, button, istouch, presses)
    _instances.world:emit("mousepressed", x, y, button)
end

function love.mousereleased(x, y, button, istouch, presses)
    _instances.world:emit("mousereleased", x, y, button)
end
