assert(resources.sprites.items)
assert(anim8)

return {
    id = "CHEST",
    image = resources.sprites.items,
    grid = anim8.newGrid(32, 32, resources.sprites.items:getWidth(), resources.sprites.items:getHeight()),
    animation_names = {
        "default"
    },
    layers = {
        {
            default = {
                frame_duration = 1000,
                x = 1,
                y = 1
            }
        }
    }
}
