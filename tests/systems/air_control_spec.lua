package.path = "./tests/util/?.lua;./util/?.lua;" .. package.path

require("init_ecs")
local assert = require "luassert"
local _t = require("testing")
local mocks = require("mocks")

local air_control_system = nil
local world_instance = nil

local function init_system(entities)
    world_instance = Instance()
    air_control_system = require("systems.air_control")()
    world_instance:addSystem(air_control_system, "update")
    world_instance:enableSystem(air_control_system, "update")

    if entities then
        for _, v in pairs(entities) do
            world_instance:addEntity(v)
        end
    end
end

_t.fixture(
    "Air Control System",
    function(fixture)
        fixture(
            "Given an entity",
            function(fixture)
                init_system(
                    {
                        Entity():give(_components.transform, Vector(0, 0), Vector(0, 0)):give(_components.controlled):give(
                            _components.air_control
                        ):apply()
                    }
                )

                fixture(
                    "Given no input",
                    function(fixture)
                        --  assert: it has no velocity
                        world_instance:emit("update", 1)

                        local air_control_component = air_control_system.pool:get(1):get(_components.air_control)
                        _t.expect(fixture, air_control_component.x_velocity == 0, "The position does not change")
                        fixture(
                            "when updating entity without air_control velocity",
                            function(fixture)
                                -- assert: it does not move
                            end
                        )
                    end
                )

                fixture(
                    "Given a left input",
                    function(fixture)
                        --  assert: it has negative x velocity
                        fixture(
                            "when updating entity with negative air_control velocity",
                            function(fixture)
                                -- assert: it moves to the left
                            end
                        )
                    end
                )

                fixture(
                    "Given a right input",
                    function(fixture)
                        --  assert: it has positive x velocity
                        fixture(
                            "when updating entity with positive air_control velocity",
                            function(fixture)
                                -- assert: it moves to the right
                            end
                        )
                    end
                )
            end
        )
    end
)
