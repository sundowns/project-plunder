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

local function give_entity_state(entity, initial_state)
    entity:give(
        _components.movement_state,
        {
            default = {
                {duration = 1}
            },
            walk = {
                {duration = 1}
            },
            jump = {
                {duration = 1}
            },
            fall = {
                {duration = 1}
            }
        },
        initial_state
    ):apply()
end

_t.fixture(
    "Air Control System",
    function(fixture)
        fixture(
            "Given a entity",
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
                            function(fixture)
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
                                fixture(
                                    "and that entity is stateless",
                                    function(fixture)
                                        air_control_system:update(1)

                                        _t.expect(
                                            fixture,
                                            air_control_system.pool:get(1):get(_components.transform).position.x < 0,
                                            "the transform translates accordingly"
                                        )
                                    end
                                )

                                fixture(
                                    "and that entity is falling",
                                    function(fixture)
                                        give_entity_state(air_control_system.pool:get(1), "fall")

                                        air_control_system:update(1)

                                        _t.expect(
                                            fixture,
                                            air_control_system.pool:get(1):get(_components.transform).position.x < 0,
                                            "the transform translates accordingly"
                                        )
                                    end
                                )

                                fixture(
                                    "and that entity is jumping",
                                    function(fixture)
                                        give_entity_state(air_control_system.pool:get(1), "jump")

                                        air_control_system:update(1)

                                        _t.expect(
                                            fixture,
                                            air_control_system.pool:get(1):get(_components.transform).position.x < 0,
                                            "the transform translates accordingly"
                                        )
                                    end
                                )

                                fixture(
                                    "and that entity is in any other state",
                                    function(fixture)
                                        give_entity_state(air_control_system.pool:get(1), "walk")

                                        air_control_system:update(1)

                                        _t.expect(
                                            fixture,
                                            air_control_system.pool:get(1):get(_components.transform).position ==
                                                Vector(0, 0),
                                            "the transform does not translate"
                                        )
                                    end
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
                            function(fixture)
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
                                fixture(
                                    "and that entity is stateless",
                                    function(fixture)
                                        air_control_system:update(1)

                                        _t.expect(
                                            fixture,
                                            air_control_system.pool:get(1):get(_components.transform).position.x > 0,
                                            "the transform translates accordingly"
                                        )
                                    end
                                )

                                fixture(
                                    "and that entity is falling",
                                    function(fixture)
                                        give_entity_state(air_control_system.pool:get(1), "fall")

                                        air_control_system:update(1)

                                        _t.expect(
                                            fixture,
                                            air_control_system.pool:get(1):get(_components.transform).position.x > 0,
                                            "the transform translates accordingly"
                                        )
                                    end
                                )

                                fixture(
                                    "and that entity is jumping",
                                    function(fixture)
                                        give_entity_state(air_control_system.pool:get(1), "jump")

                                        air_control_system:update(1)

                                        _t.expect(
                                            fixture,
                                            air_control_system.pool:get(1):get(_components.transform).position.x > 0,
                                            "the transform translates accordingly"
                                        )
                                    end
                                )

                                fixture(
                                    "and that entity is in any other state",
                                    function(fixture)
                                        give_entity_state(air_control_system.pool:get(1), "walk")

                                        air_control_system:update(1)

                                        _t.expect(
                                            fixture,
                                            air_control_system.pool:get(1):get(_components.transform).position ==
                                                Vector(0, 0),
                                            "the transform does not translate"
                                        )
                                    end
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
