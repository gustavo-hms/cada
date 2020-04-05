local cada = require "cada"

local N = 1000000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result = {}
for i, v in cada.ipairs(input) do
	result[i] = v
end
