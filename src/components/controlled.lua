local controls =
    Component(
    function(e, binds)
        e.binds = binds
        e.is_held = {}
        for k, v in pairs(e.binds) do
            e.is_held[v] = false
        end
    end
)

function controls:get(key)
    return e.binds[key]
end

return controls
