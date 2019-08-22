-- position is a vector with world coordinates (floats)
return function(position)
  assert(position.x and position.y, "Received non-vector position to player entity")

  local player =
    Entity():give(_components.transform, position, Vector(0, 0)):give(_components.sprite, "PLAYER"):give(
    _components.direction
  ):give(_components.dimensions, _constants.PLAYER_WIDTH, _constants.PLAYER_HEIGHT):give(
    _components.controlled,
    {
      ["a"] = "left",
      ["d"] = "right",
      ["space"] = "jump",
      ["mouse1"] = "target_light",
      ["i"] = "toggle_inventory",
      ["q"] = "drop_item",
      ["1"] = "select_1",
      ["2"] = "select_2",
      ["3"] = "select_3",
      ["4"] = "select_4",
      ["5"] = "select_5",
      ["6"] = "select_6",
      ["7"] = "select_7",
      ["8"] = "select_8",
      ["9"] = "select_9",
      ["0"] = "select_10",
      ["-"] = "select_11",
      ["="] = "select_12"
    }
  ):give(_components.walk):give(_components.air_control):give(_components.jump):give(
    _components.gravity,
    _constants.GRAVITY,
    _constants.GRAVITY_DECELERATION
  ):give(
    _components.movement_state,
    {
      default = {
        {duration = 1}
      },
      walk = {
        {duration = 1}
      },
      jump = {
        {duration = 1}
      },
      fall = {
        {duration = 1}
      }
    },
    "fall"
  ):give(
    _components.collides,
    _constants.PLAYER_WIDTH,
    _constants.PLAYER_HEIGHT,
    Vector(6, 12),
    "player",
    "world" -- offset relative to transform (arbitrary numbers that look nice atm)
  ):give(_components.camera_target):give(_components.inventory, _constants.DEFAULT_INVENTORY_SIZE):give(
    _components.pickup_items
  ):give(_components.toolbar, _constants.INVENTORY_SLOTS_PER_ROW):give(_components.visible):apply()
  return player
end
