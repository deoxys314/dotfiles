local pprint = {}

-- constants
local NEWLINE_THRESHOLD = 5

-- helper functions
local function spaces(level, indent) return string.rep(' ', level * indent) end

local function is_identifier(str)
    local id_pattern = [=[^[%a%s]+[%a%d_]*$]=]
    return string.find(str, id_pattern)
end

local function display_key(key)
    if type(key) == 'string' then
        if is_identifier(key) then
            return key
        else
            local _, double_quote_count = string.gsub(key, '"', '')
            if double_quote_count == 0 then return '["' .. key .. '"]' end
            local _, single_quote_count = string.gsub(key, '\'', '')
            if double_quote_count >= single_quote_count then
                return '[\'' .. key .. '\']'
            else
                return '["' .. key .. '"]'
            end
        end
    end
    return tostring(key)
end

local function is_array(table_)
    local i = 0
    for _ in pairs(table_) do
        i = i + 1
        if table_[i] == nil then return false end
    end
    return true
end

local function is_mixed(table_)
    if is_array(table_) then return false end
    local has_number_keys = false
    local has_other_keys = false
    for key, value in pairs(table_) do
        if type(key) == 'number' then
            has_number_keys = true
        else
            has_other_keys = true
        end
        if has_number_keys and has_other_keys then return true end
    end
    return false
end

local next = next

-- will choke on non-tables
local function isempty(table_) return next(table_) == nil end

function pprint.pprint(object, level, indent, seen)
    -- The second two arguments are optional, and are mainly used internally

    -- set defaults if not provided
    local level = level or 1
    local indent = indent or 2
    local seen = seen or {}

    -- begin string construction
    local s = ''
    if type(object) == 'table' then
        if seen[object] then
            return '...'
        else
            seen[object] = true
        end
        -- 4 cases we can have here:
        --   an empty table
        --   an array-like table (keys are numbers and 1-N)
        --   a dict-like table (keys are non-numbers)
        --   a mixed table (number and non-number keys)

        -- early return for empty table
        if isempty(object) then return '{}' end

        if is_array(object) then
            local highest_idx = 1
            for idx, _ in ipairs(object) do highest_idx = idx end
            local nl = highest_idx >= NEWLINE_THRESHOLD
            s = s .. '{'
            if nl then
                s = s .. '\n' .. spaces(level, indent)
            else
                s = s .. ' '
            end
            for idx, val in ipairs(object) do
                s = s .. pprint.pprint(val, level + 1, indent, seen)
                if idx == highest_idx then
                    if nl then
                        s = s .. ',\n' .. spaces(level - 1, indent)
                    else
                        s = s .. ' '
                    end
                else
                    s = s .. ','
                    if nl then
                        s = s .. '\n' .. spaces(level, indent)
                    else
                        s = s .. ' '
                    end
                end
            end
            return s .. '}'
        end

        if is_mixed(object) then
            -- construct array part
            local highest_idx = 1
            for idx, _ in ipairs(object) do highest_idx = idx end
            local nl = highest_idx >= NEWLINE_THRESHOLD
            s = s .. '{\n' .. spaces(level, indent)
            for idx, val in ipairs(object) do
                s = s .. pprint.pprint(val, level + 1, indent, seen)
                if idx == highest_idx then
                    s = s .. ';\n'
                else
                    s = s .. ','
                    if nl then
                        s = s .. '\n' .. spaces(level, indent)
                    else
                        s = s .. ' '
                    end
                end
            end

            -- construct dict part
            for key, value in pairs(object) do
                if not (type(key) == 'number' and key <= highest_idx and key >= 1) then
                    s = s .. spaces(level, indent) .. display_key(key) .. ' = ' ..
                            pprint.pprint(value, level + 1, indent) .. ',\n'
                end
            end
            return s .. spaces((level - 1), indent) .. '}'
        end

        s = s .. '{\n'
        for key, value in pairs(object) do
            s = s .. spaces(level, indent) .. display_key(key) .. ' = ' ..
                    pprint.pprint(value, level + 1, indent, seen) .. ',\n'
        end
        return s .. spaces((level - 1), indent) .. '}'
    else
        if type(object) == 'string' then
            return '"' .. tostring(object) .. '"'
        else
            return tostring(object)
        end
    end
end

function pprint.print(object, level, indent, seen) print(pprint.pprint(object, level, indent, seen)) end

return pprint
