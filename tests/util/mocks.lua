package.path = "data/?.lua;" .. package.path

local mocks = {}
mocks._null_fn = function()
end

-- function mocks:test(title, test)
--     print(title .. " - running.")
--     T(title, test)
--     print(title .. " - passed.")
-- end

function mocks:love()
    love = {
        load = self._null_fn,
        graphics = {},
        filesystem = {
            load = self._null_fn
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
