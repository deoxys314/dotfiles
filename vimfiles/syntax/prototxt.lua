if vim.b.current_syntax then return end

vim.api.nvim_create_augroup('PrototxtSyntax', { clear = false })

vim.api.nvim_create_autocmd('BufEnter', {
    group = 'PrototxtSyntax',
    pattern = '*.prototxt',
    callback = function()
        -- Identifier: word followed by ':' or '{'
        vim.fn.matchadd('prototxtIdentifier', [[\v\w+\s*(:|\{)@=]])

        -- [bracket] region containing identifiers, foldable
        -- there is no replacement for a region in lua yet
        vim.cmd.syntax {
            'region',
            'prototxtIdBrackets',
            [=[start='\[']=],
            'end=\']\'',
            'fold',
            'contains=prototxtIdentifier',
        }

        -- Dotted identifier
        vim.fn.matchadd('prototxtIdentifier', [[\v[a-z_]+(\.[a-z_]+)+]], 10, -1, { contained = 1 })

        -- Comment: #
        vim.fn.matchadd('prototxtComment', [[\v#.*$]])

        -- String: double quoted, skips escaped quote
        vim.fn.matchadd('prototxtString', [[\v"(\\"|[^"])*"]], 15)

        -- Integer: optional sign, at least one digit
        vim.fn.matchadd('prototxtInteger', [[[-+]?\\d\\+]], 9)

        -- Float: optional sign, digits, dot, digits
        vim.fn.matchadd('prototxtFloat', [[[-+]?\\d+\\.\\d*]])

        -- Octal number: starts with 0, not followed by x or X, then digits 0-7
        vim.fn.matchadd('prototxtOctal', [[\v<[-+]?0[0-7]+>]], 11)

        -- Hex number: starts with 0x or 0X and hex digits
        vim.fn.matchadd('prototxtHex', [[\v[-+]?0[xX][0-9A-Fa-f]+]], 12)

        -- Boolean: true/false keyword
        vim.fn.matchadd('prototxtBool', [[\<\(true\|false\)\>]])

        -- Enum value: trailing identifier
        vim.fn.matchadd('prototxtEnumValue', [[[A-Za-z_]\+$]])

        -- Highlight links (use nvim_set_hl for modern Neovim)
        vim.api.nvim_set_hl(0, 'prototxtIdBrackets', { link = 'Special' })
        vim.api.nvim_set_hl(0, 'prototxtIdentifier', { link = 'Identifier' })
        vim.api.nvim_set_hl(0, 'prototxtComment', { link = 'Comment' })
        vim.api.nvim_set_hl(0, 'prototxtString', { link = 'String' })
        vim.api.nvim_set_hl(0, 'prototxtInteger', { link = 'Number' })
        vim.api.nvim_set_hl(0, 'prototxtFloat', { link = 'Float' })
        vim.api.nvim_set_hl(0, 'prototxtOctal', { link = 'Number' })
        vim.api.nvim_set_hl(0, 'prototxtHex', { link = 'Number' })
        vim.api.nvim_set_hl(0, 'prototxtBool', { link = 'Boolean' })
        vim.api.nvim_set_hl(0, 'prototxtEnumValue', { link = 'Function' })

        vim.b.current_syntax = 'prototxt'
    end,
})
