local iter = require "iter"

local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result = {}
local i = 1
for v in iter.array(input):map(function(v) return v%2 == 0 and v/2 or v-1 end):filter(function(v) return v < 2*N/3 end) do
	result[i] = v
	i = i+1
end
