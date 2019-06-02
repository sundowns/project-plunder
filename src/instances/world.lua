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
local state_manager = _systems.state_manager()
local stage_manager = _systems.stage_manager()
local collider = _systems.collider()

-- ADD SYSTEMS

world:addSystem(lighting, "attach_lighting")
world:addSystem(lighting, "detach_lighting")
world:addSystem(lighting, "update")

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

world:addSystem(gravity, "update")

world:addSystem(state_manager, "update")

world:addSystem(stage_manager, "load_stage")
world:addSystem(stage_manager, "set_collision_world")
world:addSystem(stage_manager, "draw")

world:addSystem(sprite_renderer, "draw")
world:addSystem(sprite_renderer, "update")
world:addSystem(sprite_renderer, "sprite_state_updated")

world:addSystem(collider, "set_collision_world")
world:addSystem(collider, "update")
world:addSystem(collider, "draw")

world:addSystem(jumping, "action_pressed")
world:addSystem(jumping, "action_held")
world:addSystem(jumping, "update")
world:addSystem(jumping, "set_collision_world")
world:addSystem(jumping, "draw")

-- ENABLE SYSTEMS

world:enableSystem(lighting, "attach_lighting")
world:enableSystem(lighting, "detach_lighting")

world:enableSystem(encircling, "draw_debug")

world:enableSystem(input, "keypressed")
world:enableSystem(input, "keyreleased")

world:enableSystem(walking, "action_pressed")
world:enableSystem(walking, "action_held")

world:enableSystem(air_control, "action_pressed")
world:enableSystem(air_control, "action_held")

world:enableSystem(stage_manager, "load_stage")
world:enableSystem(stage_manager, "set_collision_world")
world:enableSystem(stage_manager, "draw")

world:enableSystem(sprite_renderer, "draw")
world:enableSystem(sprite_renderer, "sprite_state_updated")

world:enableSystem(collider, "set_collision_world")
world:enableSystem(collider, "draw")

world:enableSystem(jumping, "action_pressed")
world:enableSystem(jumping, "action_held")
world:enableSystem(jumping, "set_collision_world")
world:enableSystem(jumping, "draw")

function world:enableUpdates()
    world:enableSystem(lighting, "update")
    world:enableSystem(sprite_renderer, "update")
    world:enableSystem(motion, "update")
    world:enableSystem(encircling, "update")
    world:enableSystem(input, "update")
    world:enableSystem(walking, "update")
    world:enableSystem(air_control, "update")
    world:enableSystem(jumping, "update")
    world:enableSystem(gravity, "update")
    world:enableSystem(state_manager, "update")
    world:enableSystem(collider, "update")
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
    world:disableSystem(state_manager, "update")
    world:disableSystem(collider, "update")
end

world:enableUpdates()

return world
