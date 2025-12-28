local g = vim.g

local wrapped_config = {}

wrapped_config.config = function()
    g.wrapped_ignore_langs =
        { 'bak', 'copilot-chat', 'log', 'netrw', 'tmp', 'undotree', 'wrapped' }
    g.wrapped_ignore_globs = {
        'NetrwTreeListing',
        '*NetrwTreeListing*',
        'copilot-chat',
        '*copilot-chat*',
        '[No Name]',
        '*No Name*',
    }
    g.wrapped_ignore_cmds = {
        'call',
        'close',
        'Commentary',
        'echo',
        'echom',
        'echomsg',
        'exit',
        'nohlsearch',
        'Playtime',
        'q!',
        'q',
        'qa',
        'qall',
        'quit',
        'tabclose',
        'TmuxNavigateDown',
        'TmuxNavigateLeft',
        'TmuxNavigateRight',
        'TmuxNavigateUp',
        'w!',
        'w',
        'wq!',
        'wq',
        'WrappedDeleteAllData',
        'WrappedVim',
        'write',
    }
end

return wrapped_config
