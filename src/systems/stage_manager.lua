local stage_manager = System()

function stage_manager:init()
    self.stage = nil
    self.collision_world = nil
end

function stage_manager:load_stage(path)
    self.stage = Cartographer.load(path)
    assert(self.collision_world, "stage_manager attempted to load stage with collision world unset")
    assert(self.stage.layers["World"], "attempted to load map without 'World' tile layer")

    local collidable_tile_data = self:read_tile_layer(self.stage.layers["World"])
    -- Stage data is stored in a 1 dimensional array of tiles
    for id, tile in ipairs(collidable_tile_data.tiles) do
        if tile ~= 0 then -- 0 means no tile
            local x = ((id - 1) % collidable_tile_data.columns) * _constants.TILE_WIDTH
            local y = math.floor((id - 1) / collidable_tile_data.columns) * _constants.TILE_HEIGHT
            self.collision_world:add(
                {
                    is_tile = true
                },
                x,
                y,
                _constants.TILE_WIDTH,
                _constants.TILE_HEIGHT
            )
        end
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
