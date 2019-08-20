local PATH = (...):gsub("%.init$", "")

return {
  lighting = require(PATH .. ".lighting"),
  sprite_renderer = require(PATH .. ".sprite_renderer"),
  motion = require(PATH .. ".motion"),
  encircling = require(PATH .. ".encircling"),
  input = require(PATH .. ".input"),
  walking = require(PATH .. ".walking"),
  air_control = require(PATH .. ".air_control"),
  jumping = require(PATH .. ".jumping"),
  gravity = require(PATH .. ".gravity"),
  state_manager = require(PATH .. ".state_manager"),
  stage_manager = require(PATH .. ".stage_manager"),
  collider = require(PATH .. ".collider"),
  camera = require(PATH .. ".camera"),
  inventory_manager = require(PATH .. ".inventory_manager"),
  levitation = require(PATH .. ".levitation"),
  item_manager = require(PATH .. ".item_manager")
}
