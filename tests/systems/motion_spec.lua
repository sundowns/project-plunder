require("util.init_ecs") -- Must always come first

local motion_system = nil
local world_instance = nil

local function init_motion_system(entities)
    world_instance = Instance()
    motion_system = require("systems.motion")()

    world_instance:addSystem(motion_system, "update")
    world_instance:enableSystem(motion_system, "update")

    for _, v in pairs(entities) do
        world_instance:addEntity(v)
    end
end

T(
    "Motion System",
    function(T)
        T(
            "Given an entity with no velocity",
            function(T)
                -- Arrange data/world for test
                init_motion_system(
                    {
                        Entity():give(_components.transform, Vector(0, 0), Vector(0, 0)):apply()
                    }
                )

                -- Update / run the system for 1 second
                world_instance:emit("update", 1)

                -- Test / assert the outcomes
                local transform = motion_system.pool:get(1):get(_components.transform)
                T:assert(transform.position == Vector(0, 0), "The position does not change")
            end
        )

        T(
            "Given an entity with some velocity",
            function(T)
                -- Arrange data/world for test
                init_motion_system(
                    {
                        Entity():give(_components.transform, Vector(0, 0), Vector(10, 50)):apply()
                    }
                )

                -- Update / run the system for 1 second
                world_instance:emit("update", 1)

                -- Test / assert the outcomes
                local transform = motion_system.pool:get(1):get(_components.transform)
                T:assert(transform.position == Vector(10, 50), "The position is updated correctly")
            end
        )
    end
)
