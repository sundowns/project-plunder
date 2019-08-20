local item =
  Component(
  function(e, id)
    assert(id, "Received nil id for item component")
    e.id = id
  end
)

return item
