local M = {}

local function ensure_key(t, k)
	return t[k] ~= nil
end

function M.make_observable(self, prop_name)
	local t = self[prop_name] or {}
	local p = t
	t = {}

	setmetatable(t, {
		__index = function (t, k) return p[k] end,
		__newindex = function (t, k, v)
			if p[k] == v then return end

			local old_value = p[k]
			p[k] = v

			local event_name = self.__name__ .. '_' .. prop_name .. '_' .. k .. '_' .. 'update'			
			Lego.event.emit(event_name, v, old_value, self.__uuid__)
		end
	})

	self[prop_name]	= t
end

function M.remove_observable(self, prop_name)
	if (ensure_key(self, prop_name)) then setmetatable(self[prop_name], nil) end
end

return M