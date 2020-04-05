local itertools = require "itertools"

local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result = {}
for i, v in itertools.filter(function(v) return v < 2*N/3 end, itertools.map(function(v) return v%2 == 0 and v/2 or v-1 end, itertools.each(input))) do
	result[i] = v
end
