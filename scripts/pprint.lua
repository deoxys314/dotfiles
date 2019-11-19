local pprint = {}

function pprint.pprint(object, level, indent)
	-- The second two arguments are optional, and are mainly used internally
	
	-- set defaults if not provided
	local level = level or 1
	local indent = indent or 2

	-- local helper function
	local spaces = function (level, indent)
		return string.rep(' ', level, indent)
	end

	-- begin string construction
	local s = ''
	if type(object) == 'table' then
		s = s .. '{\n'
		for k,v in pairs(object) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			s = s .. spaces(level * indent) .. '[' .. k .. '] = ' .. pprint.pprint(v, level + 1, indent) .. ',\n'
		end
		return s .. spaces((level - 1) * indent) .. '}'
	else
		return tostring(object)
	end
end

function pprint.print(object, level, indent)
	print(pprint(object, level, indent))
end

return pprint
