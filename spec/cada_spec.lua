local cada = require "cada"
math.randomseed(os.time())

local function random_name()
	local codes = {}
	for i = 1, math.random(10) do
		codes[i] = math.random(161, 255)
	end
	return utf8.char(table.unpack(codes))
end

local function random_numbers()
	local t = {}
	for i = 1,math.random(100) do
		t[i] = math.random()
	end
	return t
end

describe("The #wrap function", function()
	it("should wrap a standard producer into a `cada` producer", function()
		local original = random_numbers()
		local result = {}

		for i,v in cada.wrap(ipairs)(original) do
			result[i] = v
		end

		assert.are.same(original, result)
	end)

	it("should build a working local #ipairs", function()
		local original = random_numbers()
		local result = {}

		for i,v in cada.ipairs(original) do
			result[i] = v
		end

		assert.are.same(result, original)
	end)

	it("should build a working local #pairs", function()
		local original = {}
		local N = math.random(50)

		for _ = 1,N do
			original[random_name()] = math.random()
		end

		local result = {}
		for i,v in cada.pairs(original) do
			result[i] = v
		end

		assert.are.same(original, result)
	end)
end)

describe("The #list function", function()
	it("should make an iterator that gives the values of an array-like table", function()
		local original = random_numbers()
		local result = {}

		local i = 1
		for v in cada.list(original) do
			result[i] = v
			i = i + 1
		end

		assert.are.same(original, result)
	end)
end)

describe("The #tolist function", function()
	it("should build an array-like table from an iterator", function()
		local original = random_numbers()
		local result = cada.tolist(cada.list(original))
		assert.are.same(original, result)
	end)

	it("should work as a method", function()
		local original = random_numbers()
		local result = cada.list(original):tolist()
		assert.are.same(original, result)
	end)
end)

describe("The #map function", function()
	it("should transform the original iterator", function()
		local original = random_numbers()
		local expected = {}
		local f = function(v) return 2*v end

		for i, v in ipairs(original) do
			expected[i] = f(v)
		end

		local result = cada.list(original):map(f):tolist()
		assert.are.same(expected, result)
	end)
end)

describe("The #filter function", function()
	it("should transform the original iterator", function()
		local original = random_numbers()
		local expected = {}
		local f = function(v) return v < 5 end

		for _, v in ipairs(original) do
			if f(v) then
				expected[#expected + 1] = v
			end
		end

		local result = cada.list(original):filter(f):tolist()
		assert.are.same(expected, result)
	end)
end)

describe("The #takewhile function", function()
	it("should transform the original iterator", function()
		local original = random_numbers()
		local expected = {}
		local f = function(v) return v < 1 end

		for _, v in ipairs(original) do
			if  not f(v) then
				break
			end

			expected[#expected + 1] = v
		end

		local result = cada.list(original):takewhile(f):tolist()
		assert.are.same(expected, result)
	end)
end)

describe("A composition of adapters", function()
	it("should work for #map, #filter and #takewhile", function()
		local original = random_numbers()
		-- local original = {0.3, .17, .14, .38, .94, .77, .46}
		local expected = {}
		local map = function(v) return v/1.1 end
		local filter = function(v) return v > 0.2 end
		local takewhile = function(v) return v < 0.5 end

		for _, v in ipairs(original) do
			v = map(v)

			if filter(v) then
				if not takewhile(v) then
					break
				end

				expected[#expected + 1] = v
			end
		end

		local result =
			cada.list(original)
				:map(map)
				:filter(filter)
				:takewhile(takewhile)
				:tolist()
		assert.are.same(expected, result)
	end)
end)
