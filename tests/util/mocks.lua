package.path = "tests/data/?.lua;data/?.lua;" .. package.path

local spy = require "luassert.spy"

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

function mocks.mappy(_)
    Mappy = {
        load = function(path)
            return require(path)
        end
    }
end

return mocks
