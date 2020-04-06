local global = _G

local _ENV = {}

local  prototype = { __selector = true };
prototype.__index = prototype

local function is_selector(a) return global.type(a) == "table" and a.__selector end

prototype.__call = function(self, ...) return self.call(...) end

prototype.__add = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa+bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__sub = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa-bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__mul = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa*bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__div = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa/bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__mod = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa % bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__pow = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa^bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__unm = function(a)
	call = function(...) return -(a.call(...)) end
	return global.setmetatable({ call = call }, prototype)
end

prototype.__idiv = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa//bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__band = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa & bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__bor = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa | bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__bxor = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa ~ bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__bnot = function(a)
	call = function(...) return ~(a.call(...)) end
	return global.setmetatable({ call = call }, prototype)
end

prototype.__shl = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa << bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__shr = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa >> bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__concat = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa .. bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__len = function(a)
	call = function(...) return #(a.call(...)) end
	return global.setmetatable({ call = call }, prototype)
end

prototype.__eq = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa == bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__lt = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa < bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__le = function(a, b)
	local call = function(...)
		local aa, bb = a, b
		if is_selector(aa) then aa = aa.call(...) end
		if is_selector(bb) then bb = bb.call(...) end

		return aa <= bb
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__index = function(a, key)
	local call

	if is_selector(key) then
		call = function(...) return a.call(...)[key.call(...)] end
	else
		call = function(...) return a.call(...)[key] end
	end

	return global.setmetatable({ call = call }, prototype)
end

prototype.__nexindex = function(a, key, value)
	local call = function(...)
		local kkey, vvalue = key, value
		if is_selector(kkey) then kkey = kkey.call(...) end
		if is_selector(vvalue) then vvalue = vvalue.call(...) end

		a.call(...)[kkey] = vvalue
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
_0 = function(...)
	local t = {...}
	
	local call = function(...)
		local a, b, c, d, e = t[1], t[2], t[3], t[4], t[5]
		if is_selector(a) then a = a.call(...) end
		if is_selector(b) then b = b.call(...) end
		if is_selector(c) then c = c.call(...) end
		if is_selector(d) then d = d.call(...) end
		if is_selector(e) then e = e.call(...) end

		return a, b, c, d, e
	end
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
