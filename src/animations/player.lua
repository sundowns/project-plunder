assert(resources.sprites.player)
assert(anim8)

return {
    id = "PLAYER",
    image = resources.sprites.player,
    grid = anim8.newGrid(32, 32, resources.sprites.player:getWidth(), resources.sprites.player:getHeight()),
    animation_names = {
        "default",
        "fall",
        "walk",
        "jump"
    },
    layers = {
        {
            default = {
                frame_duration = 0.15,
                x = "1-6",
                y = 2
            },
            walk = {
                frame_duration = 0.10,
                x = "1-6",
                y = 1
            },
            run = {
                frame_duration = 0.10,
                x = "1-6",
                y = 3
            },
            fall = {
                frame_duration = 0.15,
                x = "1-3",
                y = 5
            },
            jump = {
                frame_duration = 0.095,
                x = "1-6",
                y = 4
            }
        }
    }
}
