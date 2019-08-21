local PATH = (...):gsub("%.init$", "")

return {
  sprite = require(PATH .. ".sprite"),
  transform = require(PATH .. ".transform"),
  direction = require(PATH .. ".direction"),
  point_light = require(PATH .. ".point_light"),
  encircle = require(PATH .. ".encircle"),
  dimensions = require(PATH .. ".dimensions"),
  controlled = require(PATH .. ".controlled"),
  walk = require(PATH .. ".walk"),
  air_control = require(PATH .. ".air_control"),
  jump = require(PATH .. ".jump"),
  gravity = require(PATH .. ".gravity"),
  movement_state = require(PATH .. ".movement_state"),
  collides = require(PATH .. ".collides"),
  camera_target = require(PATH .. ".camera_target"),
  inventory = require(PATH .. ".inventory"),
  item = require(PATH .. ".item"),
  levitating = require(PATH .. ".levitating"),
  pickup_items = require(PATH .. ".pickup_items"),
  icon = require(PATH .. ".icon"),
  toolbar = require(PATH .. ".toolbar"),
  visible = require(PATH .. ".visible"),
  grabbable = require(PATH .. ".grabbable"),
  invulnerability = require(PATH .. ".invulnerability")
}
