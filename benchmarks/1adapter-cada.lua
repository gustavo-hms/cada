local cada = require "cada"

local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result = {}
for i, v in cada.ipairs(input) >> cada.map(function(i, v) return v%2 == 0 and i, v/2 or i, v-1 end) do
	result[i] = v
end
