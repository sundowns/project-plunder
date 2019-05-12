local PATH = (...):gsub("%.init$", "")

return {
    lighting = require(PATH .. ".lighting"),
    sprite_renderer = require(PATH .. ".sprite_renderer")
}
