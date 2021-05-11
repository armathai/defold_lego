local M = {}

M.ensure_key = function(t, k)
    return t[k] ~= nil
end

M.shallow_copy_table = function(t)
    local copy = {}
    for k, v in pairs(t) do copy[k] = v end
    return copy
end

M.extend_metatable = function(t, mt)
    local meta = getmetatable(t)

    if meta then
        meta.__index = meta.__index or {}
        M.extend_metatable(meta.__index, mt)
    else
        setmetatable(t, mt)
    end
end

M.uuid4 = function()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

return M

