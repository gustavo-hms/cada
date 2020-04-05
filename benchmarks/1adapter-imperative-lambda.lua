local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result = {}
local fn = function(v)
    if v%2 == 0 then
        return v/2
    else
        return v - 1
    end
end

for i,v in ipairs(input) do
    result[i] = fn(v)
end
