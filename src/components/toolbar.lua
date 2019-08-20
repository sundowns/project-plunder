local toolbar =
  Component(
  function(e, size)
    assert(size and type(size) == "number", "Received invalid size to toolbar constructor")
    e.size = size
    e.slots = {}
  end
)

-- function toolbar:something()
-- end

return toolbar
