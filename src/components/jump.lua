local jump =
  Component(
  function(e)
    e.jump_velocity = _constants.JUMP_ACCELERATION
    e.falling_trigger_velocity = 3
  end
)
return jump
