local Utils = require('lego.utils')

local M = {__events__ = {}}

function M.emit(event_name, ...)
    local ll = M._get_listeners(event_name)
    if not ll then return end

    local ll_copy = Utils.shallow_copy_table(ll)

    for _, v in pairs(ll_copy) do
        if v.once then M._remove_listener(event_name, v.callback, v.context) end

        v.callback(v.context, ...)
    end
end

function M.on(event_name, callback, context)
    M._add_listener(event_name, callback, context, false)

    return M
end

function M.once(event_name, callback, context)
    M._add_listener(event_name, callback, context, true)

    return M
end

function M.off(event_name, callback, context)
    M._remove_listener(event_name, callback, context)

    return M
end

function M.remove_listeners_of(context)
    for k1, v1 in pairs(M.__events__) do
        local ll = M._get_listeners(k1)

        for k2, v2 in pairs(ll) do            
            if v2.context == context then M._remove_listener(k1, v2.callback, v2.context) end
        end
    end
end

function M.remove_listeners(event)
    for k1, v1 in pairs(M.__events__) do
        if k1 == event then M.__events__[k1] = nil end
    end
end

function M._add_listener(event_name, callback, context, once)
    local ll = M._get_listeners(event_name)
    local l = {callback = callback, context = context, once = once}
    if ll then
        ll[#ll + 1] = l
    else
        M.__events__[event_name] = {l}
    end
end

function M._remove_listener(event_name, callback, context)
    local ll = M._get_listeners(event_name)
    if not ll then return end

    for k, v in pairs(ll) do
        if v.callback == callback and v.context == context then ll[k] = nil end
    end

    if #ll == 0 then ll = nil end
end

function M._get_listeners(key)
    return M.__events__[key]
end

return M
