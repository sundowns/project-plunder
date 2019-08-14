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

function mocks:mappy()
    Mappy = {
        load = function(path)
            local stage = require(path)
            if stage.layers["World"] then
                stage.layers["World"].getCollidersIter = function()
                    return self.null_spy()
                end
            end
            return stage
        end
    }
end

return mocks
