if vim.b.current_syntax then return end

-- Comments
vim.cmd.syntax { 'match', 'prototxtComment', [[/#.*$/]] }

-- Strings (double-quoted, with escaped quote support)
vim.cmd.syntax { 'region', 'prototxtString', [[start=+"+ skip=+\\"+ end=+"+]] }

-- Booleans
vim.cmd.syntax { 'keyword', 'prototxtBool', 'true', 'false' }

-- Hex numbers (must come before integer to take priority)
vim.cmd.syntax { 'match', 'prototxtHex', [[/\v[-+]?0[xX][0-9A-Fa-f]+/]] }

-- Octal numbers
vim.cmd.syntax { 'match', 'prototxtOctal', [[/\v<[-+]?0[0-7]+>/]] }

-- Float (with decimal point)
vim.cmd.syntax { 'match', 'prototxtFloat', [[/\v[-+]?(\d+\.\d*|\.\d+)([eE][-+]?\d+)?/]] }

-- Float (scientific notation without decimal point)
vim.cmd.syntax { 'match', 'prototxtFloat', [[/\v[-+]?\d+[eE][-+]?\d+/]] }

-- Special float keywords
vim.cmd.syntax { 'keyword', 'prototxtFloat', 'inf', '-inf', 'nan' }

-- Integer (must come after float/hex/octal so those take priority)
vim.cmd.syntax { 'match', 'prototxtInteger', [[/\v[-+]?\d+/]] }

-- Field name (word before colon)
vim.cmd.syntax { 'match', 'prototxtFieldName', [[/\v\w+\ze\s*:/]] }

-- Message name (word before opening brace)
vim.cmd.syntax { 'match', 'prototxtMessageName', [[/\v\w+\ze\s*\{/]] }

-- Enum value (bare identifier as a value — after the colon, not followed by brace)
vim.cmd.syntax { 'match', 'prototxtEnumValue', [[/\v:\s+\zs[A-Z][A-Za-z0-9_]*/]] }

-- Extension identifier in brackets: [some.extension.name]
vim.cmd.syntax { 'region', 'prototxtExtension', [[start='\[' end='\]']], 'contains=prototxtExtensionName' }
vim.cmd.syntax { 'match', 'prototxtExtensionName', [[/\v[a-zA-Z_][a-zA-Z0-9_.]+/]], 'contained' }

-- Braces
vim.cmd.syntax { 'match', 'prototxtBraces', [[/[{}]/]] }

-- Highlight links
vim.api.nvim_set_hl(0, 'prototxtComment', { link = 'Comment' })
vim.api.nvim_set_hl(0, 'prototxtString', { link = 'String' })
vim.api.nvim_set_hl(0, 'prototxtBool', { link = 'Boolean' })
vim.api.nvim_set_hl(0, 'prototxtHex', { link = 'Number' })
vim.api.nvim_set_hl(0, 'prototxtOctal', { link = 'Number' })
vim.api.nvim_set_hl(0, 'prototxtFloat', { link = 'Float' })
vim.api.nvim_set_hl(0, 'prototxtInteger', { link = 'Number' })
vim.api.nvim_set_hl(0, 'prototxtFieldName', { link = 'Identifier' })
vim.api.nvim_set_hl(0, 'prototxtMessageName', { link = 'Function' })
vim.api.nvim_set_hl(0, 'prototxtEnumValue', { link = 'Constant' })
vim.api.nvim_set_hl(0, 'prototxtExtension', { link = 'Special' })
vim.api.nvim_set_hl(0, 'prototxtExtensionName', { link = 'Special' })
vim.api.nvim_set_hl(0, 'prototxtBraces', { link = 'Delimiter' })

vim.b.current_syntax = 'prototxt'
