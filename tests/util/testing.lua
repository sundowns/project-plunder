-- Wrappers for knife/test with verbose console output
local testing = {}

local indent = "  "
local arrows = ">> "
local divider = " | "

local function traverse_history(fixture)
  local output = ""
  local current_node = fixture.parent
  while current_node.parent and current_node.parent.currentNodeIndex ~= 0 do
    output = current_node.description .. divider .. output
    current_node = current_node.parent
  end
  -- allow leaf nodes to not have any message
  if fixture.description then
    output = output .. fixture.description
  end
  return output
end

local function print_test_name(fixture, message)
  print(indent .. traverse_history(fixture) .. divider .. message)
end

function testing.fixture(title, test)
  print(arrows .. title .. " - running.") -- TODO: colour these??
  T(title, test)
end

-- fixture is the current wrapping test fixture
function testing.expect(fixture, condition, message)
  fixture:assert(condition, message)
  print_test_name(fixture, message)
end

-- fixture is the current wrapping test fixture
function testing.expect_error(fixture, action, message)
  fixture:error(action, message)
  print_test_name(fixture, message)
end

return testing
