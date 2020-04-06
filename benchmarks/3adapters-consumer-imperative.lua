local N = 300000

local input = {}
for i = 1,N do
	input[i] = 2*i
end

local result = {}

for i,v in ipairs(input) do
    if v >= N then break end

	if v < 4*N/3 then
		if v%2 == 0 then
			result[i] = v/2
		else
			result[i] = v - 1
		end
	end
end
