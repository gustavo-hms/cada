local iter = require "iter"

local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result = iter.array(input):map(function(v) return v%2 == 0 and v/2 or v-1 end):filter(function(v) return v < 4*N/3 end):take_while(function(v) return v < N end):collect()
