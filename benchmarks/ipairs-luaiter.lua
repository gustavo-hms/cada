local luaiter = require "iter"

local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result = {}
local i = 1
for v in luaiter.array(input) do
    result[i] = v
    i = i+1
end
