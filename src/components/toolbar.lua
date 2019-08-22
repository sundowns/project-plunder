local toolbar =
  Component(
  function(e, size)
    assert(size and type(size) == "number" and size > 0, "Received invalid size to toolbar constructor")
    e.size = size
    e.selected_index = 1
    e.slots = {}
  end
)

function toolbar:select(index)
  assert(index > 0 and index <= self.size, "Received out-of-bounds slot index to toolbar:select")
  self.selected_index = index
end

return toolbar
