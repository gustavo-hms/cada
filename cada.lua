local global = _G

local _ENV = {}

local iterator = { __iterator = true }
iterator.__index = iterator

local function apply_transformation(self, transformer)
	return transformer:transform(self)
end

iterator.__shr = apply_transformation
iterator.__add = apply_transformation

function iterator:__call()
	return self:next()
end

function iterator:map(fn)
	return map(fn):transform(self)
end

function iterator:filter(fn)
	return filter(fn):transform(self)
end

function iterator:take_while(fn)
	return take_while(fn):transform(self)
end

function iterator:array()
	return array():transform(self)
end

function new(t) return global.setmetatable(t, iterator) end

-- Generators

function wrap(generator)
    return function(...)
        local next, invariant, control = generator(...)

        local t = {
			control = control,
            next = function(self)
				local a, b, c, d, e = next(invariant, self.control)
				if a == nil then return end
				self.control = a
                return a, b, c, d, e
            end
        }

        return new(t)
    end
end

ipairs = wrap(global.ipairs)
pairs = wrap(global.pairs)

function sequence(t)
	return ipairs(t) >> second()
end

function values(t)
	return pairs(t) >> second()
end

-- Adapters

local adapter = { __adapter = true }
adapter.__index = adapter

function adapter:transform(iterator)
	self.former = iterator
	return new(self)
end

function new_adapter(next)
	return global.setmetatable( { next = next }, adapter )
end

function map(fn)
	return new_adapter(function(self)
		local a, b, c, d, e = self.former:next()
		if a == nil then return end
		return fn(a, b, c, d, e)
	end)
end

function filter(fn)
	return new_adapter(function(self)
		for a, b, c, d, e in self.former do
			if fn(a, b, c, d, e) then return a, b, c, d, e end
		end
	end)
end

function take_while(fn)
	return new_adapter(function(self)
		local a, b, c, d, e = self.former:next()
		if not fn(a, b, c, d, e) then return nil end
		return a, b, c, d, e
	end)
end

function second()
	return new_adapter(function(self)
		local _, b = self.former:next()
		return b
	end)
end

-- Consumers

local consumer = { __consumer = true }
consumer.__index = consumer

function consumer:transform(iterator)
	return self.consume(iterator)
end

function new_consumer(consume)
	return global.setmetatable( { consume = consume }, consumer )
end

function array()
	local t = new_consumer(function(iterator)
		local t = {}
		local i = 1

		for value in iterator do
			t[i] = value
			i = i + 1
		end

		return t
	end)

	return t
end

return _ENV
