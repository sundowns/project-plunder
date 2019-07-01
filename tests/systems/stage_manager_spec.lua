package.path = "./tests/util/?.lua;./util/?.lua;" .. package.path

require("init_ecs") -- Must always come first

local mocks = require("mocks")
local stage_manager_system = nil
local world_instance = nil

local function init_system(entities)
    world_instance = Instance()
    stage_manager_system = require("systems.stage_manager")()
    world_instance:addSystem(stage_manager_system, "load_stage")
    world_instance:enableSystem(stage_manager_system, "load_stage")
    stage_manager_system:set_collision_world(
        {
            add = mocks._null_fn
        }
    )
    if entities then
        for _, v in pairs(entities) do
            world_instance:addEntity(v)
        end
    end
end

local test = function(title, test)
    print(title .. " - running.")
    T(title, test)
    print(title .. " - passed.")
end

test(
    "Stage Manager System",
    function(test)
        mocks:love()
        mocks:cartographer()
        test(
            "Stage Loading Context",
            function(test)
                init_system({})

                test(
                    "Given unset collision data",
                    function(test)
                        stage_manager_system:set_collision_world(nil)
                        -- Assert will error
                        test:error(
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
                        -- Assert will error
                        test:error(
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
                        -- Assert will error
                        world_instance:emit("load_stage", "stage_01")
                        _util.t.print(stage_manager_system, 1)
                        -- test:error(
                        --     function()
                        --     end,
                        --     "then it throws an error"
                        -- )
                    end
                )
            end
        )
    end
)
