package.path = "./tests/util/?.lua;./util/?.lua;" .. package.path

require("init_ecs")
local assert = require "luassert"
local _t = require("testing")
local mocks = require("mocks")

local stage_manager_system = nil
local world_instance = nil

local function init_system(entities)
    world_instance = Instance()
    stage_manager_system = require("systems.stage_manager")()
    world_instance:addSystem(stage_manager_system, "load_stage")
    world_instance:enableSystem(stage_manager_system, "load_stage")

    if entities then
        for _, v in pairs(entities) do
            world_instance:addEntity(v)
        end
    end
end

local reset_dependecies = function()
    mocks:love()
    mocks:cartographer()
    stage_manager_system:set_collision_world(
        {
            add = mocks.null_spy()
        }
    )
end

_t.fixture(
    "Stage Manager System",
    function(fixture)
        fixture(
            "Stage Loading Context",
            function(fixture)
                init_system({})
                reset_dependecies()

                fixture(
                    "Given unset collision data",
                    function(fixture)
                        -- Arrange
                        reset_dependecies()
                        stage_manager_system:set_collision_world(nil)
                        -- Act & Assert will error
                        _t.expect_error(
                            fixture,
                            function()
                                world_instance:emit("load_stage", "stage_00")
                            end,
                            "then it throws an error"
                        )
                    end
                )

                fixture(
                    "Given map with no world layer",
                    function(fixture)
                        -- Arrange
                        reset_dependecies()
                        -- Act & Assert will error
                        _t.expect_error(
                            fixture,
                            function()
                                world_instance:emit("load_stage", "stage_00")
                            end,
                            "then it throws an error"
                        )
                    end
                )

                fixture(
                    "Given map with valid tiles defined in 'World' layer",
                    function(fixture)
                        -- Arrange
                        reset_dependecies()
                        -- Act
                        world_instance:emit("load_stage", "stage_01")

                        -- Assert
                        _t.expect(
                            fixture,
                            assert.spy(stage_manager_system.collision_world.add).was.called(4),
                            "The expected number of tiles were added to the stage_manager table"
                        )
                        _t.expect(
                            fixture,
                            #stage_manager_system.tiles == 4,
                            "The expected number of tiles were added to the collision world"
                        )
                    end
                )

                fixture(
                    "Given map with valid objects defined in 'Object' layer",
                    function(fixture)
                        -- Arrange
                        reset_dependecies()

                        -- Act
                        world_instance:emit("load_stage", "stage_02")

                        -- Assert
                        _t.expect(
                            fixture,
                            #stage_manager_system.objects == 2,
                            "The expected number of objects were added to the stage_manager table"
                        )
                        _t.expect(
                            fixture,
                            world_instance.entities.size == 2,
                            "The expected number of entities were added to the instance"
                        )
                        _t.expect(
                            fixture,
                            stage_manager_system.objects[1].type == "static_light_orange",
                            "The first object has the correct type"
                        )
                        _t.expect(
                            fixture,
                            stage_manager_system.objects[2].type == "static_light_orange",
                            "The second object has the correct type"
                        )
                    end
                )
            end
        )
    end
)
