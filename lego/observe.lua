local Utils = require('lego.utils')

local M = {}

function M.make_observable(self, prop_name)
    local t = self[prop_name] or {}
    t.__uuid__ = t.__uuid__ or Utils.uuid4()
    local _t = t
    t = {}

    Utils.extend_metatable(t, {
        __index = function(t, k)
            return _t[k]
        end,
        __newindex = function(t, k, new_value)
            if _t[k] == new_value then return end

            local old_value = _t[k]
            _t[k] = new_value

            local event_name = prop_name .. '_' .. k .. '_' .. 'update'
            Lego.event.emit(event_name, new_value, old_value, _t.__uuid__)
        end
    })

    rawset(self, prop_name, t)
end

function M.remove_observable(self, prop_name)
    if Utils.ensure_key(self, prop_name) then setmetatable(self[prop_name], nil) end
end

return M
