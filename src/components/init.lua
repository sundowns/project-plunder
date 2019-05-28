local PATH = (...):gsub("%.init$", "")

return {
    sprite = require(PATH .. ".sprite"),
    transform = require(PATH .. ".transform"),
    direction = require(PATH .. ".direction"),
    point_light = require(PATH .. ".point_light"),
    encircle = require(PATH .. ".encircle"),
    dimensions = require(PATH .. ".dimensions"),
    controlled = require(PATH .. ".controlled"),
    walk = require(PATH .. ".walk")
}
