local pprint = {}

-- helper function
local function spaces(level, indent)
	return string.rep(' ', level, indent)
end

local next = next

-- will choke on non-tables
local function isempty(table_)
	return next(table_) == nil
end

function pprint.pprint(object, level, indent)
	-- The second two arguments are optional, and are mainly used internally

	-- set defaults if not provided
	local level = level or 1
	local indent = indent or 2

	-- begin string construction
	local s = ''
	if type(object) == 'table' then
		-- early return for empty table
		if isempty(object) then return '{}' end

		s = s .. '{\n'
		for k,v in pairs(object) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			s = s .. spaces(level * indent) .. '[' .. k .. '] = ' .. pprint.pprint(v, level + 1, indent) .. ',\n'
		end
		return s .. spaces((level - 1) * indent) .. '}'
	else
		if type(object) == 'string' then
			return '"' .. tostring(object) .. '"'
		else
			return tostring(object)
		end
	end
end

function pprint.print(object, level, indent)
	print(pprint.pprint(object, level, indent))
end

return pprint
