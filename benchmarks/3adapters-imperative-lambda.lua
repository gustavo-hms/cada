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

local predicate = function(v)
	return v < 4*N/3
end

local predicate2 =  function(v) return v < N end

for i,v in ipairs(input) do
    if not predicate2(v) then break end

	if predicate(v) then
		result[i] = fn(v)
	end
end
