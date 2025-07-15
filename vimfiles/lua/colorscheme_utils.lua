local M = {}

-- List all available colorschemes
function M.list_colorschemes()
    local colorschemes = {}
    for _, name in ipairs(vim.fn.getcompletion('', 'color')) do table.insert(colorschemes, name) end
    return colorschemes
end

-- Rotate through colorschemes
local current_index = 1
local schemes = {}

function M.rotate_colorschemes()
    if #schemes == 0 then schemes = M.list_colorschemes() end
    current_index = current_index % #schemes + 1
    vim.cmd('colorscheme ' .. schemes[current_index])
    return schemes[current_index]
end

return M
