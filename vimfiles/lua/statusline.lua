local opt = vim.opt
local module = {}

module.set_colors = function()
    vim.cmd.highlight { 'link', 'User1', 'Directory', bang = true }
    vim.cmd.highlight { 'link', 'User2', 'ErrorMsg', bang = true }
end

local function set_status_line(active)
    if opt.buftype:get() == 'nofile' or opt.filetype:get() == 'netrw' then
        vim.opt_local.statusline = [[%!v:lua.require('statusline').no_file_status_line()]]
    elseif opt.buftype:get() == 'nowrite' then
        return
    elseif active then
        vim.opt_local.statusline = [[%!v:lua.require('statusline').active_status_line()]]
    else
        vim.opt_local.statusline = [[%!v:lua.require('statusline').inactive_status_line()]]
    end
end
module.set_status_line = set_status_line

local function update_inactive_windows()
    for _, winnum in ipairs(vim.fn.range(1, vim.fn.winnr('$'))) do
        if winnum ~= vim.fn.winnr() then
            vim.fn.setwinvar(winnum, '&statusline',
                             [[%!v:lua.require('statusline').inactive_status_line()]])
        end
    end
end
module.update_inactive_windows = update_inactive_windows

local function short_file_path()
    local fn = vim.fn
    if opt.buftype == 'terminal' then
        return fn.expand('%:t')
    else
        return fn.pathshorten(fn.fnamemodify(fn.expand('%:p'), ':~:.'))
    end
end
module.short_file_path = short_file_path

local function fugitive_status_line()
    if vim.g.loaded_fugitive ~= nil then
        return vim.api.nvim_eval('FugitiveStatusLine()')
    else
        return ''
    end
end

local function obsession_status_line()
    if vim.g.loaded_obsession ~= nil then
        return vim.api.nvim_eval('ObsessionStatus()')
    else
        return ''
    end
end

module.active_status_line = function()
    return table.concat({
        '%([%-2{mode(1)}]%)', -- mode
        -- location and flags
        '%(%1* ',
        short_file_path(),
        '%h%2*%m%r%1* %)%0*',
        '%=', -- split
        '%(%y[%{&ff}]%)', -- file info
        '%([%3p%%]%)%([x:%2c y:%2l]%)', -- location
        '%(',
        fugitive_status_line(),
        '%)', -- fugitive
        '%(',
        obsession_status_line(),
        '%)', -- obsession

    })
end

module.inactive_status_line = function() return [[  %(%{v:lua.require('statusline').short_file_path()}%)%(%h%)%(%m%)%(%r%)]] end
module.no_file_status_line = function() return  [[  %(%{v:lua.require('statusline').short_file_path()}%)]] end

return module
