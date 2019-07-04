local stage_manager = System()

function stage_manager:init()
    self.stage = nil
    self.collision_world = nil
    self.objects = {}
    self.tiles = {}
end

function stage_manager:load_stage(path)
    self.stage = Mappy.load(path)
    assert(self.collision_world, "stage_manager attempted to load stage with collision world unset")
    assert(self.stage.layers["World"], "attempted to load map without 'World' tile layer")

    local collidable_tile_data = self:read_tile_layer(self.stage.layers["World"])
    -- Stage data is stored in a 1 dimensional array of tiles
    for id, tile in ipairs(collidable_tile_data.tiles) do
        if tile ~= 0 then -- 0 means no tile
            self:add_tile(id, tile, collidable_tile_data.columns)
        end
    end

    if self.stage.layers["Objects"] then
        local object_data = self:read_object_layer(self.stage.layers["Objects"])
        for _, object in pairs(object_data.objects) do
            self:add_object(object)
        end
    end
end

-- second parameter is tile id, unused for now
function stage_manager:add_tile(id, _, columns)
    local x = ((id - 1) % columns) * _constants.TILE_WIDTH
    local y = math.floor((id - 1) / columns) * _constants.TILE_HEIGHT
    local new_tile = {is_tile = true, position = Vector(x, y)}

    table.insert(self.tiles, new_tile)
    self.collision_world:add(new_tile, x, y, _constants.TILE_WIDTH, _constants.TILE_HEIGHT)
end

function stage_manager:add_object(object)
    assert(object and object.type, "stage_manager received object with no type defined")
    local valid = true
    if object.type == "static_light_orange" then
        self:getInstance():addEntity(
            _entities.static_light_source(
                Vector(object.x - _constants.TILE_WIDTH / 2, object.y - _constants.TILE_HEIGHT),
                _constants.COLOURS.ORANGE_TORCHLIGHT,
                object.properties["radius"]
            )
        )
    else
        valid = false
    end

    if valid then
        table.insert(self.objects, object)
    end
end

function stage_manager.read_tile_layer(_, layer)
    assert(layer.data)
    return {
        columns = layer.width,
        rows = layer.height,
        tiles = layer.data
    }
end

function stage_manager.read_object_layer(_, layer)
    assert(layer and layer.objects, "Received nil object layer")
    return {
        objects = layer.objects
    }
end

function stage_manager:set_collision_world(collision_world)
    self.collision_world = collision_world
end

function stage_manager:draw()
    if self.stage then
        self.stage:draw()
    end
end

function stage_manager:update(dt)
    if self.stage then
        self.stage:update(dt)
    end
end

return stage_manager
