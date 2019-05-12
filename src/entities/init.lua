local PATH = (...):gsub("%.init$", "")

return {
    player = require(PATH .. ".player"),
    light_source = require(PATH .. ".light_source")
}
