local cada = require "cada"

cada.expose_selectors(_ENV)
local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result = {}
for i, v in cada.ipairs(input) >> cada.map(_2%2 == 0 and _0(_1, _2/2) or _0(_1, _2-1)) do
	result[i] = v
end
