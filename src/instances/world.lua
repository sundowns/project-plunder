local world = Instance()

local lighting = _systems.lighting()
local sprite_renderer = _systems.sprite_renderer()

-- ADD SYSTEMS

world:addSystem(lighting, "draw")
world:addSystem(lighting, "update")

world:addSystem(sprite_renderer, "draw")
world:addSystem(sprite_renderer, "update")
world:addSystem(sprite_renderer, "spriteStateUpdated")

-- ENABLE SYSTEMS

world:enableSystem(lighting, "draw")

world:enableSystem(sprite_renderer, "draw")
world:enableSystem(sprite_renderer, "spriteStateUpdated")

function world:enableUpdates()
    world:enableSystem(lighting, "update")
    world:enableSystem(sprite_renderer, "update")
end

function world:disableUpdates()
    world:disableSystem(lighting, "update")
    world:disableSystem(sprite_renderer, "update")
end

world:enableUpdates()

return world
