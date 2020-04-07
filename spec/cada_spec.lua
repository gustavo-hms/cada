local cada = require "cada"

local function random_name()
	local codes = {}
	for i = 1, math.random(10) do
		codes[i] = math.random(161, 255)
	end
	return utf8.char(table.unpack(codes))
end

local function random_numbers()
	local t = {}
	local N = math.random(50)
	for i = 1,N do
		t[i] = math.random()
	end
	return t
end

describe("The #wrap function", function()
	it("should wrap a standard producer into a `cada` producer", function()
		local original = random_numbers()
		local result = {}

		for _, i,v in cada.wrap(ipairs)(original) do
			result[i] = v
		end

		assert.are.same(result, original)
	end)

	it("should build a working local #ipairs", function()
		local original = random_numbers()
		local result = {}

		for _, i,v in cada.ipairs(original) do
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
		for _, i,v in cada.pairs(original) do
			result[i] = v
		end

		assert.are.same(original, result)
	end)
end)

describe("The #list function", function()
	it("should make an iterator that gives the values of an array-like table", function()
		local original = random_numbers()
		local result = {}

		for i, v in cada.list(original) do
			result[i] = v
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

-- describe("The #apply_transformation function", function()
-- 	it("when applied to an adapter, should generate a new iterator", function()
-- 		local iterator = cada.new { next = function() end }
-- 		local adapter = cada.new_adapter(function() end)
-- 		local result = iterator >> adapter
-- 		assert.is.not_nil(result.__iterator)
-- 	end)

-- 	it("when applied to a consumer, should run the consume function", function()
-- 		local done = false
-- 		local iterator = cada.new {
-- 			next = function() if not done then done = true; return 17 end end
-- 		}

-- 		local consumer = cada.new_consumer(function(iterator)
-- 			assert.is.not_nil(iterator.__iterator)

-- 			local counter = 0
-- 			local result
-- 			for v in iterator do
-- 				counter = counter + 1
-- 				result = v
-- 			end

-- 			assert.is.equal(1, counter)
-- 			return result
-- 		end)

-- 		local result = iterator >> consumer
-- 		assert.is.equal(17, result)
-- 	end)
-- end)

-- describe("The #filter #adapter", function()
-- 	it("should filter the elements in a iterator", function()
-- 		local result = cada.sequence({3, 6, 1, 3, 8, 0, 9}):filter(function(e) return e > 5 end):array()
-- 		assert.are.same({6, 8, 9}, result)
-- 	end)
-- end)
