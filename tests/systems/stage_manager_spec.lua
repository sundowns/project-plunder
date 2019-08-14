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
    mocks:mappy()
    stage_manager_system:set_collision_world(
        {
            add = mocks.null_spy()
        }
    )
end

_t.fixture(
    "Stage Manager System",
    function(fixture)
        init_system({})
        reset_dependecies()

        fixture(
            "Given no collision data",
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
                    "it throws an error"
                )
            end
        )

        fixture(
            "Given a map file with no world layer",
            function(fixture)
                -- Arrange
                reset_dependecies()
                -- Act & Assert will error
                _t.expect_error(
                    fixture,
                    function()
                        world_instance:emit("load_stage", "stage_00")
                    end,
                    "it throws an error"
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
                    #stage_manager_system.tiles == 4,
                    "the expected number of tiles were added to the collision world"
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
                    "the expected number of objects were added to the stage_manager table"
                )
                _t.expect(
                    fixture,
                    world_instance.entities.size == 2,
                    "the expected number of entities were added to the instance"
                )
                _t.expect(
                    fixture,
                    stage_manager_system.objects[1].type == "static_light_orange",
                    "the first object has the correct type"
                )
                _t.expect(
                    fixture,
                    stage_manager_system.objects[2].type == "static_light_orange",
                    "the second object has the correct type"
                )
            end
        )
    end
)
