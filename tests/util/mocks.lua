package.path = "tests/data/?.lua;data/?.lua;" .. package.path

local spy = require "luassert.spy"

-- TODO: Use spies to null functions so we can track invocations!!

local mocks = {}
mocks._null_fn = function()
    return spy.new(
        function()
        end
    )
end

-- function mocks:test(title, test)
--     print(title .. " - running.")
--     T(title, test)
--     print(title .. " - passed.")
-- end

function mocks:love()
    love = {
        load = self._null_fn(),
        graphics = {},
        filesystem = {
            load = self._null_fn()
        }
    }
end

function mocks:cartographer()
    Cartographer = {
        load = function(path)
            return require(path)
        end
    }
end

return mocks
