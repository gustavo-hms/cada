local genny = require "genny"

local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local gen = genny.generator(ipairs(input))
local result = genny.sequence(genny.when(genny.filter(genny.map(gen, function(i, v) return v%2 == 0 and i, v/2 or i, v-1 end), function(_, v) return v < 4*N/3 end), function(_, v) return v < N end))
