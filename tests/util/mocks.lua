package.path = "tests/data/?.lua;data/?.lua;" .. package.path

local spy = require "luassert.spy"

-- TODO: Use spies to null functions so we can track invocations!!

local mocks = {}
mocks._null_fn = function()
end
mocks.null_spy = function()
    return spy.new(mocks._null_fn)
end

function mocks:love()
    love = {
        load = self.null_spy(),
        graphics = {},
        filesystem = {
            load = self.null_spy()
        }
    }
end

function mocks.cartographer(_)
    Cartographer = {
        load = function(path)
            return require(path)
        end
    }
end

return mocks
