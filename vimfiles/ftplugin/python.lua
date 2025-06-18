vim.opt_local.autoindent = true
vim.opt_local.expandtab = true
vim.opt_local.foldmethod = 'indent'
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
vim.opt_local.textwidth = 100

-- Adapted from:
-- https://github.com/google/styleguide/blob/8f97e24da04753c7a15eda6b02114a01ec3146f5/google_python_style.vim

local max_backwards_look = 50

vim.cmd.let [==[pyindent_nested_paren="&sw*2"]==]
vim.cmd.let [==[pyindent_open_paren="&sw*2"]==]

google_python_indent = function(line_number)
    vim.fn.cursor(line_number, 1)
    local par_line, par_col = vim.fn.searchpairpos([==[(\|{\|\[]==], '', [==[)\|}\|\]]==], 'bW',
                                                   'line(\'.\') < ' ..
                                                       (line_number - max_backwards_look) ..
                                                       ' ? dummy :' ..
                                                       ' synIDattr(synID(line(\'.\'), col(\'.\'), 1), \'name\')' ..
                                                       ' =~ \'\\(Comment\\|String\\)$\'')
    if par_line > 0 then
        vim.fn.cursor(par_line, 1)
        if par_col ~= (vim.fn.col '$' - 1) then return par_col end
    end

    return vim.cmd.GetPythonIndent(line_number)

end

vim.opt_local.indentexpr = 'v:lua.google_python_indent'
