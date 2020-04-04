local cada = require "cada"

describe("The #new function", function()
	it("should create a new #iterator", function()
		local iterator = cada.new {
			next = function() end
		}
		assert.is.not_nil(iterator.__iterator)
	end)

	it("should convert an #adapter into an #iterator", function()
		local adapter = cada.new_adapter(function() end)
		local iterator = cada.new(adapter)
		assert.is.not_nil(iterator.__iterator)
		assert.is_nil(iterator.__adapter)
	end)
end)

describe("The #new_adapter function", function()
	it("should create a new #adapter", function()
		local adapter = cada.new_adapter(function() end)
		assert.is.not_nil(adapter.__adapter)
	end)
end)

describe("The #new_consumer function", function()
	it("should create a new #consumer", function()
		local consumer = cada.new_consumer(function() end)
		assert.is.not_nil(consumer.__consumer)
	end)
end)

describe("The #apply_transformation function", function()
	it("when applied to an adapter, should generate a new iterator", function()
		local iterator = cada.new { next = function() end }
		local adapter = cada.new_adapter(function() end)
		local result = iterator >> adapter
		assert.is.not_nil(result.__iterator)
	end)

	it("when applied to a consumer, should run the consume function", function()
		local done = false
		local iterator = cada.new {
			next = function() if not done then done = true; return 17 end end
		}

		local consumer = cada.new_consumer(function(iterator)
			assert.is.not_nil(iterator.__iterator)

			local counter = 0
			local result
			for v in iterator do
				counter = counter + 1
				result = v
			end

			assert.is.equal(1, counter)
			return result
		end)

		local result = iterator >> consumer
		assert.is.equal(17, result)
	end)
end)

describe("The #filter #adapter", function()
	it("should filter the elements in a iterator", function()
		local result = cada.sequence({3, 6, 1, 3, 8, 0, 9}):filter(function(e) return e > 5 end):array()
		assert.are.same({6, 8, 9}, result)
	end)
end)
