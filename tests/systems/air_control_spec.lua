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
                local no_velocity =
                    Entity():give(_components.transform, Vector(0, 0), Vector(0, 0)):give(_components.controlled):give(
                    _components.air_control
                ):apply()

                init_system(
                    {
                        no_velocity
                    }
                )

                fixture(
                    "Given no input",
                    function(fixture)
                        fixture(
                            "when updating",
                            function(fixture)
                                _t.expect(
                                    fixture,
                                    air_control_system.pool:get(1):get(_components.air_control).x_velocity == 0,
                                    "the aerial drift velocity does not change"
                                )
                            end
                        )

                        fixture(
                            "when updating an entity without aerial drift velocity",
                            function(fixture)
                                world_instance:emit("update", 1)
                                local no_velocity_entity = air_control_system.pool:get(1)
                                _t.expect(
                                    fixture,
                                    no_velocity_entity:get(_components.transform).position == Vector(0, 0),
                                    "the position does not change"
                                )
                            end
                        )
                    end
                )

                fixture(
                    "Given a left input",
                    function(fixture)
                        --  assert: it has negative x velocity
                        air_control_system:move("left", air_control_system.pool:get(1))
                        fixture(
                            "",
                            function()
                                _t.expect(
                                    fixture,
                                    air_control_system.pool:get(1):get(_components.air_control).x_velocity < 0,
                                    "the aerial drift velocity decreases"
                                )
                            end
                        )

                        fixture(
                            "when updating an entity with a negative aerial drift velocity (moving left)",
                            function(fixture)
                                air_control_system:update(1)
                                _t.expect(
                                    fixture,
                                    air_control_system.pool:get(1):get(_components.transform).position.x < 0,
                                    "the transform translates accordingly"
                                )
                            end
                        )
                    end
                )

                fixture(
                    "Given a right input",
                    function(fixture)
                        air_control_system:move("right", air_control_system.pool:get(1))
                        fixture(
                            "",
                            function()
                                _t.expect(
                                    fixture,
                                    air_control_system.pool:get(1):get(_components.air_control).x_velocity > 0,
                                    "the aerial drift velocity increases"
                                )
                            end
                        )

                        fixture(
                            "when updating an entity with a positive aerial drift velocity (moving right)",
                            function(fixture)
                                air_control_system:update(1)
                                _t.expect(
                                    fixture,
                                    air_control_system.pool:get(1):get(_components.transform).position.x > 0,
                                    "the transform translates accordingly"
                                )
                            end
                        )
                    end
                )

                fixture(
                    "Given some unknown input",
                    function(fixture)
                        air_control_system:move("jump", air_control_system.pool:get(1))
                        fixture(
                            "when updating",
                            function(fixture)
                                _t.expect(
                                    fixture,
                                    air_control_system.pool:get(1):get(_components.air_control).x_velocity == 0,
                                    "the aerial drift velocity does not change"
                                )
                            end
                        )
                    end
                )
            end
        )
    end
)
