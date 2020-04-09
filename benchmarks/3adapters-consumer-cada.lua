local cada = require "cada"

local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result =
	cada.ipairs(input)
		:map(function(i, v) return v%2 == 0 and i, v/2 or i, v-1 end)
		:filter(function(_, v) return v < 4*N/3 end)
		:takewhile(function(_, v) return v < N end)
		:tolist()
