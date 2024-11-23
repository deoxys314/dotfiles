local tinsert = table.insert
local concat = table.concat
local BRACES = { '[', ']' }

local magic = {}

local function strip_table_address(obj)
    local obj_type = type(obj)
    if obj_type == 'table' then
        return (string.gsub(tostring(obj), [[:0x%x+$]], '', 1))
    else
        return tostring(obj)
    end
end

local function string_function(name, inner, second)
    return function()
        local string_builder = { name, BRACES[1], strip_table_address(inner) }
        if second then
            tinsert(string_builder, ',')
            tinsert(string_builder, strip_table_address(second))
        end
        tinsert(string_builder, BRACES[2])
        return concat(string_builder)
    end
end

local function create_magic_object(func, name_func)
    return setmetatable({}, { __call = func, __index = magic.magic, __tostring = name_func })
end

magic.magic = {
    chain = function(iter, other)
        local first_returned_nil = false
        return create_magic_object(function()
            if first_returned_nil then return other() end
            local val = iter()
            if val == nil then
                first_returned_nil = true
                return other()
            else
                return val
            end
        end, string_function_factory('Chain', iter, other))
    end,
    map = function(iter, f)
        return setmetatable({}, {
            __call = function()
                local val = iter()
                if val then return f(val) end
            end,
            __index = iterx.magic,
            __tostring = function() return iterx_tostring('Map', iter, f) end,
        })
    end,
    filter = function(iter, f)
        return setmetatable({}, {
            __call = function()
                local val = iter()
                if val == nil then return nil end
                while not f(val) do
                    val = iter()
                    if val == nil then return nil end
                end
                return val
            end,
            __index = iterx.magic,
            __tostring = function() return iterx_tostring('Filter', iter, f) end,
        })
    end,
    skip = function(iter, n)
        local count = 0
        return setmetatable({}, {
            __call = function()
                while count < n do
                    count = count + 1
                    iter()
                end
                return iter()
            end,
            __index = iterx.magic,
            __tostring = function() return iterx_tostring('Skip', iter, n) end,
        })
    end,
    skipwhile = function(iter, f)
        -- skips until the first false
        local done_skipping = false
        return setmetatable({}, {
            __call = function()
                if done_skipping then return iter() end
                local val = iter()
                if val == nil then return nil end
                while f(val) do val = iter() end
                done_skipping = true
                return val
            end,
            __index = iterx.magic,
            __tostring = function() return iterx_tostring('SkipWhile', iter, f) end,
        })
    end,
    takewhile = function(iter, f)
        local done_returning = false
        return setmetatable({}, {
            __call = function()
                if done_returning then
                    return nil
                else
                    local val = iter()
                    if f(val) then
                        return val
                    else
                        done_returning = true
                        return nil
                    end
                end
            end,
            __index = iterx.magic,
            __tostring = function() return iterx_tostring('TakeWhile', iter, f) end,
        })
    end,
    terminate = function(iter)
        local has_returned_nil = false
        return setmetatable({}, {
            __call = function()
                if has_returned_nil then return nil end
                local val = iter()
                if val == nil then
                    has_returned_nil = true
                    return nil
                else
                    return val
                end
            end,
            __index = iterx.magic,
            __tostring = function() return iterx_tostring('Terminate', iter) end,
        })
    end,
}

magic.sink = {
    collect = function(iter)
        local t = {}
        for thing in iter do tinsert(t, thing) end
        return t
    end,
    reduce = function(iter, f, initial)
        if f == nil then return nil, 'No reduction function provided!' end
        local value = initial or iter()
        for element in iter do value = f(value, element) end
        return value
    end,
    last = function(iter)
        local previous_value = nil
        local value = iter()
        while true do
            if value == nil then
                return previous_value
            else
                previous_value = value
                value = iter()
            end
        end
    end,
    always_iterable = function(obj)
        local obj_type = type(obj)
        if obj_type == 'table' then
            return pairs(obj)
        elseif obj_type == 'string' then
            return string.gsub(obj, '.')
        else
            local emitted = false
            return function()
                if not emitted then
                    emitted = true
                    return obj
                else
                    return nil
                end
            end
        end
    end,
    count = function(start, step)
        local current = start or 0
        local stepsize = step or 1
        return function()
            current = current + stepsize
            return current
        end
    end,
    cycle = function(array)
        if type(array) ~= 'table' then return nil, 'Must be a table!' end
        if array[1] == nil then return nil, 'Table must have a value at position 1!' end
        local max = #array
        local idx = 0
        return function()
            if idx >= max then idx = 0 end
            idx = idx + 1
            return array[idx]
        end
    end,
    range = function(start, stop, step)
        if start == nil or stop == nil then
            return nil, 'Must provide both start and stop values!'
        end
        local mystep = step or 1
        local current = start - mystep
        return setmetatable({}, {
            __call = function()
                current = current + mystep
                if current > stop then return nil end
                return current
            end,
            __index = iterx.magic,
            __tostring = function()
                return
                    string.format('Range%s%d, %d, %d%s', BRACES[1], start, stop, step, BRACES[2])
            end,
        })
    end,
    reiterate = function(element)
        return setmetatable({}, {
            __call = function() return element end,
            __index = iterx.magic,
            __tostring = function()
                return string.format('Reiterate%s%s%s', BRACES[1], element, BRACES[2])
            end,
        })
    end,
}

setmetatable(magic.magic, {
    __call = function(_, iter)
        return setmetatable({}, {
            __call = iter,
            __index = magic.magic,
            __tostring = function() return string_function('Magic', iter) end,
        })
    end,
})

return magic
