local global = _G

local _ENV = {}

local  prototype = { __selector = true };
prototype.__index = prototype

local function is_selector(a) return global.type(a) == "table" and a.__selector end

prototype.__call = function(self, ...) return self.call(...) end

prototype.__add = function(a, b)
	local call

	if is_selector(b) then
		call = function(...) return a.call(...) + b.call(...) end
	else
		call = function(...) return a.call(...) + b end
	end

	return global.setmetatable({ call = call }, prototype)
end

local function number(n)
	local call = function(...) return ({...})[n] end
	return global.setmetatable({ call = call }, prototype)
end

_1 = number(1)
_2 = number(2)
_3 = number(3)
_4 = number(4)
_5 = number(5)
_0 = function(constant)
	local call = function() return constant end
	return global.setmetatable({ call = call }, prototype)
end

function expose(env)
	env._1 = _1
	env._2 = _2
	env._3 = _3
	env._4 = _4
	env._5 = _5
	env._0 = _0
end

function lift(fn)
	return function(sel)
		local call = function(...) return fn(sel.call(...)) end
		return global.setmetatable({ call = call }, prototype)
	end
end

return _ENV
