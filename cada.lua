local global = _G

local _ENV = {}

-- Next : (invariant, control) -> (control, ...)
-- Generator: invariant -> (Next, invariant, control)
-- Iterator: { next: Next }
-- Adapter: Next -> Next

local protoiterator = {__iterator = true}
protoiterator.__index = protoiterator

function protoiterator:__call(invariant, control)
	return self.next(invariant, control)
end

function protoiterator:apply(adapter)
    self.next = adapter(self.next)
    return self:iter()
end

function protoiterator:consume(consumer)
	return consumer(self)
end

function protoiterator:map(fn) return self:apply(map(fn)) end

function protoiterator:filter(fn) return self:apply(filter(fn)) end

function protoiterator:takewhile(fn) return self:apply(takewhile(fn)) end

function protoiterator:arg(n) return self:apply(arg(n)) end

function protoiterator:tolist() return self:consume(tolist) end

function iterator(next, invariant, control)
    local t = {
		next = next,
		iter = function(self)
			local invariant, control = invariant, control
			return self, invariant, control
		end
	}

    return global.setmetatable(t, protoiterator)
end

local function standard_iterator(next, invariant, control)
	local next_with_double_control = function(invariant_, control_)
		local control_, a, b, c, d = next(invariant_, control_)
		return control_, control_, a, b, c, d
	end

    local t = {
		next = next_with_double_control,
		__invariant = invariant,
		__control = control,
	}

    return global.setmetatable(t, protoiterator)
end

-- wrap: StandardGenerator -> Generator
function wrap(generator)
    return function(...)
        local next, invariant, control = generator(...)
        return standard_iterator(next, invariant, control), invariant, control
    end
end

-- Generators

ipairs = wrap(global.ipairs)

pairs = wrap(global.pairs)

list = function(t)
	local next, invariant, control = global.ipairs(t)
	return iterator(next, invariant, control), invariant, control
end

keys = pairs -- Just ignore the other elements

values = function(t) return pairs(t):arg(2) end

-- Adapters

-- map: (a, b, c, d, e -> a', b', c', d', e') -> (Next a b c d e -> Next a' b' c' d' e')
function map(fn)
    return function(next)
        return function(invariant, control)
            local a, b, c, d, e = next(invariant, control)
            if a ~= nil then return a, fn(b, c, d, e) end
        end
    end
end

-- filter: (a, b, c, d, e -> Bool) -> (Next a b c d e -> Next a b c d e)
function filter(fn)
    return function(next)
        return function(invariant, control)
            for a, b, c, d, e in next, invariant, control do
                if fn(b, c, d, e) then return a, b, c, d, e end
            end
        end
    end
end

-- takewhile: (a, b, c, d, e -> Bool) -> (Next a b c d e -> Next a b c d e)
function takewhile(fn)
    return function(next)
        return function(invariant, control)
            for a, b, c, d, e in next, invariant, control do
                if not fn(b, c, d, e) then return end
                return a, b, c, d, e
            end
        end
    end
end

function arg2(next)
	return function(invariant, control)
		local _, b = next(invariant, control)
		return b
	end
end


function arg(n)
    return function(next)
        return function(invariant, control)
			global.print("control", control)
            local a, b, c, d, e = next(invariant, control)
			if a == nil then return end

            if n == 1 then
                return a
            elseif n == 2 then
                return b
            elseif n == 3 then
                return c
            elseif n == 4 then
                return d
            elseif n == 5 then
                return e
            end
        end
    end
end


-- Consumers

function tolist(iterator)
	local list = {}
	local i = 1

	for _, v in iterator:iter() do
		list[i] = v
		i = i + 1
	end

	return list
end


return _ENV
