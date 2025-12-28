local g = vim.g

local ale_config = {}

ale_config.config = function()
    local function args(tbl) return table.concat(tbl, ' ') end
    g.ale_fixers = {
        ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
        cpp = { 'remove_trailing_lines', 'trim_whitespace', 'clang-format' },
        fish = { 'fish_indent', 'trim_whitespace', 'remove_trailing_lines' },
        go = { 'gofmt' },
        groovy = { 'npm-groovy-lint' },
        js = { 'clang-format', 'trim_whitespace', 'remove_trailing_lines' },
        json = { 'jq', 'prettier', 'json_pytool', 'clang-format' },
        lua = { 'remove_trailing_lines', 'trim_whitespace', 'lua-format', 'luafmt' },
        markdown = { 'mdl', 'pandoc', 'write-good' },
        python = { 'isort', 'black' },
        rust = { 'rustfmt' },
        typescript = { 'tslint', 'prettier' },
    }
    g.ale_cspell_options = args {
        '--unique',
        '--config',
        '"' .. USER_HOME .. '/' .. 'dotfiles' .. '/' .. 'cspell.json' .. '"',
    }
    g.ale_markdown_mdl_options = args { '--rule', '~MD029', '--rule', '~MD005' }
    g.ale_markdown_writegood_options = args { '--no-passive' }
    g.ale_lua_lua_format_options = args {
        '--break-after-table-lb',
        '--chop-down-table',
        '--column-limit=99',
        '--double-quote-to-single-quote',
        '--extra-sep-at-table-end',
        '--keep-simple-control-block-one-line',
        '--spaces-inside-table-braces',
        '--no-spaces-inside-functiondef-parens',
        '--no-spaces-inside-functioncall-parens',
    }
    g.ale_linters = {
        go = { 'gofmt' },
        markdown = { 'markdownlint' },
        python = { 'pylsp', 'mypy', 'ruff' },
    }
    g.ale_python_auto_uv = true
end

return ale_config
