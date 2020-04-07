local cada = require "cada"

local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result = {}
local result =
	cada.ipairs(input)
		>> cada.map(function(i, v) return v%2 == 0 and i, v/2 or i, v-1 end)
		>> cada.filter(function(_, v) return v < 4*N/3 end)
		>> cada.take_while(function(_, v) return v < N end)
		>> cada.array()