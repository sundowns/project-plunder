-- Wrappers for knife/test with verbose console output
local testing = {}

function testing.fixture(title, test)
    print(">> " .. title .. " - running.") -- TODO: colour these??
    T(title, test)
    print(">> " .. title .. " - finished.")
end

-- fixture is the current wrapping test fixture
function testing.expect(fixture, condition, message)
    fixture:assert(condition, message)
    print("  " .. fixture.description .. "| " .. message .. " - success.")
end

-- fixture is the current wrapping test fixture
function testing.expect_error(fixture, action, message)
    fixture:error(action, message)
    print("  " .. fixture.description .. "| " .. message .. " - success.")
end

return testing
