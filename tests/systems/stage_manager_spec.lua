package.path = "./tests/util/?.lua;./util/?.lua;" .. package.path

require("init_ecs") -- Must always come first

local assert = require "luassert"
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

-- TODO: make below all common code
local test = function(title, test)
    print(title .. " - running.")
    T(title, test)
    print(title .. " - passed.")
end

local expect = function(t, condition, message)
    t:assert(condition, message)
    print("  " .. t.description .. "| " .. message .. " - success.")
end

local expect_error = function(t, action, message)
    t:error(action, message)
    print("  " .. t.description .. "| " .. message .. " - success.")
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

test(
    "Stage Manager System",
    function(test)
        test(
            "Stage Loading Context",
            function(test)
                init_system({})
                reset_dependecies()

                test(
                    "Given unset collision data",
                    function(test)
                        -- Arrange
                        reset_dependecies()
                        stage_manager_system:set_collision_world(nil)
                        -- Act & Assert will error
                        expect_error(
                            test,
                            function()
                                world_instance:emit("load_stage", "stage_00")
                            end,
                            "then it throws an error"
                        )
                    end
                )

                test(
                    "Given map with no world layer",
                    function(test)
                        -- Arrange
                        reset_dependecies()
                        -- Act & Assert will error
                        expect_error(
                            test,
                            function()
                                world_instance:emit("load_stage", "stage_00")
                            end,
                            "then it throws an error"
                        )
                    end
                )

                test(
                    "Given map with valid tiles defined in 'World' layer",
                    function(test)
                        -- Arrange
                        reset_dependecies()
                        -- Act
                        world_instance:emit("load_stage", "stage_01")

                        -- Assert
                        expect(
                            test,
                            assert.spy(stage_manager_system.collision_world.add).was.called(4),
                            "The expected number of tiles were added to the stage_manager table"
                        )
                        expect(
                            test,
                            #stage_manager_system.tiles == 4,
                            "The expected number of tiles were added to the collision world"
                        )
                    end
                )

                test(
                    "Given map with valid objects defined in 'Object' layer",
                    function(test)
                        -- Arrange
                        reset_dependecies()

                        -- Act
                        world_instance:emit("load_stage", "stage_02")

                        -- Assert
                        expect(
                            test,
                            #stage_manager_system.objects == 2,
                            "The expected number of objects were added to the stage_manager table"
                        )
                        expect(
                            test,
                            world_instance.entities.size == 2,
                            "The expected number of entities were added to the instance"
                        )
                        expect(
                            test,
                            stage_manager_system.objects[1].type == "static_light_orange",
                            "The first object has the correct type"
                        )
                        expect(
                            test,
                            stage_manager_system.objects[2].type == "static_light_orange",
                            "The second object has the correct type"
                        )
                    end
                )
            end
        )
    end
)
