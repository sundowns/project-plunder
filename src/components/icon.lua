local icon =
  Component(
  function(e, path)
    assert(path, "Received invalid path to icon component: " .. path)
    e.image = love.graphics.newImage(path)
  end
)

return icon
