package.path = "./tests/util/?.lua;./util/?.lua;" .. package.path

require("init_ecs") -- Must always come first

local motion_system = nil
local world_instance = nil

local function init_system(entities)
    world_instance = Instance()
    motion_system = require("systems.motion")()

    world_instance:addSystem(motion_system, "update")
    world_instance:enableSystem(motion_system, "update")

    for _, v in pairs(entities) do
        world_instance:addEntity(v)
    end
end

local test = function(title, test)
    print(title .. " - running.")
    T(title, test)
    print(title .. " - passed.")
end

test(
    "Motion System",
    function(test)
        test(
            "Given an entity with no velocity",
            function(test)
                -- Arrange data/world for test
                init_system(
                    {
                        Entity():give(_components.transform, Vector(0, 0), Vector(0, 0)):apply()
                    }
                )

                -- Update / run the system for 1 second
                world_instance:emit("update", 1)

                -- Test / assert the outcomes
                local transform = motion_system.pool:get(1):get(_components.transform)
                test:assert(transform.position == Vector(0, 0), "The position does not change")
            end
        )

        test(
            "Given an entity with some velocity",
            function(test)
                -- Arrange data/world for test
                init_system(
                    {
                        Entity():give(_components.transform, Vector(0, 0), Vector(10, 50)):apply()
                    }
                )

                -- Update / run the system for 1 second
                world_instance:emit("update", 1)

                -- Test / assert the outcomes
                local transform = motion_system.pool:get(1):get(_components.transform)
                test:assert(transform.position == Vector(10, 50), "The position is updated correctly")
            end
        )
    end
)
