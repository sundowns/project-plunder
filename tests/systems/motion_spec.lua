package.path = "./tests/util/?.lua;./util/?.lua;" .. package.path

require("init_ecs")
local _t = require("testing")

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

_t.fixture(
    "Motion System",
    function(fixture)
        fixture(
            "Given an entity with no velocity",
            function(fixture)
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
                _t.expect(fixture, transform.position == Vector(0, 0), "the position does not change")
            end
        )

        fixture(
            "Given an entity with some velocity",
            function(fixture)
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
                _t.expect(fixture, transform.position == Vector(10, 50), "the position is updated correctly")
            end
        )
    end
)
