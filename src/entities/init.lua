local PATH = (...):gsub("%.init$", "")

return {
    player = require(PATH .. ".player"),
    following_light_source = require(PATH .. ".following_light_source"),
    static_light_source = require(PATH .. ".static_light_source"),
    stick = require(PATH .. ".items.stick")
}
