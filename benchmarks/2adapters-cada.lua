local cada = require "cada"

local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result = {}
for i, v in cada.list(input)
		:map(function(v) return v%2 == 0 and v/2 or v-1 end)
		:filter(function(v) return v < 4*N/3 end)
		:iter2() do
	result[i] = v
end
