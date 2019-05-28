local world = Instance()

local lighting = _systems.lighting()
local motion = _systems.motion()
local sprite_renderer = _systems.sprite_renderer()
local encircling = _systems.encircling()
local input = _systems.input()
local walking = _systems.walking()

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

-- ENABLE SYSTEMS

-- world:enableSystem(lighting, "attach")
-- world:enableSystem(lighting, "detach")local

world:enableSystem(sprite_renderer, "draw")
world:enableSystem(sprite_renderer, "spriteStateUpdated")

world:enableSystem(encircling, "draw_debug")

world:enableSystem(input, "keypressed")
world:enableSystem(input, "keyreleased")

world:enableSystem(walking, "action_pressed")
world:enableSystem(walking, "action_held")

function world:enableUpdates()
    -- world:enableSystem(lighting, "update")
    world:enableSystem(sprite_renderer, "update")
    world:enableSystem(motion, "update")
    world:enableSystem(encircling, "update")
    world:enableSystem(input, "update")
    world:enableSystem(walking, "update")
end

function world:disableUpdates()
    world:disableSystem(lighting, "update")
    world:disableSystem(sprite_renderer, "update")
    world:disableSystem(motion, "update")
    world:disableSystem(encircling, "update")
    world:disableSystem(input, "update")
    world:disableSystem(walking, "update")
end

world:enableUpdates()

return world
