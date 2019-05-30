local world = Instance()

local lighting = _systems.lighting()
local motion = _systems.motion()
local sprite_renderer = _systems.sprite_renderer()
local encircling = _systems.encircling()
local input = _systems.input()
local walking = _systems.walking()
local air_control = _systems.air_control()
local jumping = _systems.jumping()
local gravity = _systems.gravity()

-- ADD SYSTEMS

-- world:addSystem(lighting, "attach")
-- world:addSystem(lighting, "detach")
-- world:addSystem(lighting, "update")

world:addSystem(sprite_renderer, "draw")
world:addSystem(sprite_renderer, "update")
world:addSystem(sprite_renderer, "spriteStateUpdated")

world:addSystem(motion, "update")

world:addSystem(encircling, "update")
world:addSystem(encircling, "draw_debug")

world:addSystem(input, "keypressed")
world:addSystem(input, "keyreleased")
world:addSystem(input, "update")

world:addSystem(walking, "action_pressed")
world:addSystem(walking, "action_held")
world:addSystem(walking, "update")

world:addSystem(air_control, "action_pressed")
world:addSystem(air_control, "action_held")
world:addSystem(air_control, "update")

world:addSystem(jumping, "action_pressed")
world:addSystem(jumping, "update")

world:addSystem(gravity, "update")

-- ENABLE SYSTEMS

-- world:enableSystem(lighting, "attach")
world:enableSystem(lighting, "detach")

world:enableSystem(sprite_renderer, "draw")
world:enableSystem(sprite_renderer, "spriteStateUpdated")

world:enableSystem(encircling, "draw_debug")

world:enableSystem(input, "keypressed")
world:enableSystem(input, "keyreleased")

world:enableSystem(walking, "action_pressed")
world:enableSystem(walking, "action_held")

world:enableSystem(air_control, "action_pressed")
world:enableSystem(air_control, "action_held")

world:enableSystem(jumping, "action_pressed")
world:enableSystem(jumping, "action_held")

function world:enableUpdates()
    -- world:enableSystem(lighting, "update")
    world:enableSystem(sprite_renderer, "update")
    world:enableSystem(motion, "update")
    world:enableSystem(encircling, "update")
    world:enableSystem(input, "update")
    world:enableSystem(walking, "update")
    world:enableSystem(air_control, "update")
    world:enableSystem(jumping, "update")
    world:enableSystem(gravity, "update")
end

function world:disableUpdates()
    world:disableSystem(lighting, "update")
    world:disableSystem(sprite_renderer, "update")
    world:disableSystem(motion, "update")
    world:disableSystem(encircling, "update")
    world:disableSystem(input, "update")
    world:disableSystem(walking, "update")
    world:disableSystem(air_control, "update")
    world:disableSystem(jumping, "update")
    world:disableSystem(gravity, "update")
end

world:enableUpdates()

return world
