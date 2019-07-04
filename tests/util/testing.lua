-- Wrappers for knife/test with verbose console output
local testing = {}

local indent = "  "
local arrows = ">> "
local divider = " | "

function testing.fixture(title, test)
    print(arrows .. title .. " - running.") -- TODO: colour these??
    T(title, test)
    print(arrows .. title .. " - finished.")
end

-- fixture is the current wrapping test fixture
function testing.expect(fixture, condition, message)
    fixture:assert(condition, message)
    local output = fixture.description .. divider .. message
    if fixture.parent and fixture.parent.currentNodeIndex ~= 0 then -- TODO: recurse down the chain until this condition is true (not just 1)
        print(indent .. fixture.parent.description .. divider .. output)
    else
        print(output)
    end
end

-- fixture is the current wrapping test fixture
function testing.expect_error(fixture, action, message)
    fixture:error(action, message)
    print(indent .. fixture.description .. divider .. message)
end

return testing
