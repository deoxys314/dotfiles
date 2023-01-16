local mod = {
    InsertAtLineEnd = function(text)
        vim.fn.setline('.', vim.fn.getline('.') .. text)
        vim.fn.cursor(vim.fn.line('.'), vim.fn.col('$'))
    end
}

return mod
