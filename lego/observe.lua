local Utils = require('lego.utils')

local M = {}

function M.make_observable(self, prop_name)
    local t = self[prop_name] or {}
    local p = t
    t = {}

    Utils.extend_metatable(t, {
        __index = function(t, k)
            return p[k]
        end,
        __newindex = function(t, k, v)
            if p[k] == v then return end

            local old_value = p[k]
            p[k] = v

            local event_name = prop_name .. '_' .. k .. '_' .. 'update'
            Lego.event.emit(event_name, v, old_value, prop_name)
            -- 
            print('Lego: ' .. event_name .. '  ' .. prop_name)
        end
    })

    rawset(self, prop_name, t)
end

function M.remove_observable(self, prop_name)
    if (Utils.ensure_key(self, prop_name)) then setmetatable(self[prop_name], nil) end
end

return M
