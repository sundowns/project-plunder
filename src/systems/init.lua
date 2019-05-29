local PATH = (...):gsub("%.init$", "")

return {
    lighting = require(PATH .. ".lighting"),
    sprite_renderer = require(PATH .. ".sprite_renderer"),
    motion = require(PATH .. ".motion"),
    encircling = require(PATH .. ".encircling"),
    input = require(PATH .. ".input"),
    walking = require(PATH .. ".walking"),
    jumping = require(PATH .. ".jumping"),
    gravity = require(PATH .. ".gravity")
}
