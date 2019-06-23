assert(resources.sprites.torch)
assert(anim8)

return {
    id = "TORCH",
    image = resources.sprites.torch,
    grid = anim8.newGrid(32, 32, resources.sprites.torch:getWidth(), resources.sprites.torch:getHeight()),
    animation_names = {
        "default"
    },
    layers = {
        {
            default = {
                frame_duration = 1000,
                x = 1,
                y = 2
            }
        }
    }
}
