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
local camera = _systems.camera()
local inventory_manager = _systems.inventory_manager()
local item_manager = _systems.item_manager()
local levitation = _systems.levitation()

-- ADD SYSTEMS

if _config:get("ENABLE_LIGHTING") then
    world:addSystem(lighting, "attach_lighting")
    world:addSystem(lighting, "detach_lighting")
    world:addSystem(lighting, "update")
    world:addSystem(lighting, "camera_updated")
end

world:addSystem(motion, "update")

world:addSystem(encircling, "update")
world:addSystem(encircling, "draw_debug")

world:addSystem(input, "keypressed")
world:addSystem(input, "keyreleased")
world:addSystem(input, "mousepressed")
world:addSystem(input, "mousereleased")
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

world:addSystem(camera, "attach")
world:addSystem(camera, "detach")
world:addSystem(camera, "update")
world:addSystem(camera, "toggle_fullscreen")

world:addSystem(inventory_manager, "draw_ui")
world:addSystem(inventory_manager, "action_pressed")
world:addSystem(inventory_manager, "action_held")
world:addSystem(inventory_manager, "resize")
world:addSystem(inventory_manager, "item_picked_up")

world:addSystem(item_manager, "update")
world:addSystem(item_manager, "draw")
world:addSystem(item_manager, "set_collision_world")
world:addSystem(item_manager, "spawn_item")

world:addSystem(levitation, "update")

-- ENABLE SYSTEMS

if _config:get("ENABLE_LIGHTING") then
    world:enableSystem(lighting, "attach_lighting")
    world:enableSystem(lighting, "detach_lighting")
    world:enableSystem(lighting, "camera_updated")
end

world:enableSystem(encircling, "draw_debug")

world:enableSystem(input, "keypressed")
world:enableSystem(input, "keyreleased")
world:enableSystem(input, "mousepressed")
world:enableSystem(input, "mousereleased")

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

world:enableSystem(camera, "attach")
world:enableSystem(camera, "detach")
world:enableSystem(camera, "toggle_fullscreen")

world:enableSystem(inventory_manager, "draw_ui")
world:enableSystem(inventory_manager, "action_pressed")
world:enableSystem(inventory_manager, "action_held")
world:enableSystem(inventory_manager, "resize")
world:enableSystem(inventory_manager, "item_picked_up")

world:enableSystem(item_manager, "draw")
world:enableSystem(item_manager, "set_collision_world")
world:enableSystem(item_manager, "spawn_item")

function world.enable_updates()
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
    world:enableSystem(camera, "update")
    world:enableSystem(levitation, "update")
    world:enableSystem(item_manager, "update")
end

function world.disable_updates()
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
    world:disableSystem(camera, "update")
    world:disableSystem(levitation, "update")
    world:disableSystem(item_manager, "update")
end

world.enable_updates()

return world
