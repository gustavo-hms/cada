local genny = require "genny"

local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local gen = genny.generator(ipairs(input))
local result = {}
for i, v in gen do
	result[i] = v
end
