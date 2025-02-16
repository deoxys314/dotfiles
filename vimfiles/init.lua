local g = vim.g
local opt = vim.opt
-- some setup before plugins run
g.mapleader = ' '
local function is_executable(program_name)
    return function() return vim.fn.executable(program_name) == 1 end
end
local USER_HOME = os.getenv('HOME') or (os.getenv('homedrive') .. os.getenv('homepath'))

-- Make sure Lazy is installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
        'airblade/vim-gitgutter',
        config = function() vim.opt.updatetime = 100 end,
        enabled = is_executable('git'),
    },
    { 'airblade/vim-rooter', config = function() g.rooter_silent_chdir = 1 end },
    {
        'alvan/vim-closetag',
        config = function()
            g.closetag_filenames = table.concat({ '*.html', '*.htm', '*.xml', '*.php' }, ',')
        end,
        ft = { 'html', 'htm', 'xml', 'php' },
    },
    { 'andymass/vim-matchup' },
    { 'chriskempson/base16-vim', priority = 98, enabled = false },
    {
        'christoomey/vim-tmux-navigator',
        cmd = {
            'TmuxNavigateLeft',
            'TmuxNavigateDown',
            'TmuxNavigateUp',
            'TmuxNavigateRight',
            'TmuxNavigatePrevious',
        },
        keys = {
            { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
            { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
            { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
            { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
            { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
        },
        config = function()
            -- when leaving vim, will :update
            vim.g.tmux_navigator_save_on_switch = 2
        end,
    },
    {
        'folke/tokyonight.nvim',
        enabled = true,
        lazy = false,
        priority = 99,
        opts = {
            style = 'moon',
            light_style = 'day',
            styles = {
                comments = { italic = true },
                keywords = { italic = false },
                functions = {},
                variables = {},
                -- background styles
                sidebars = 'dark',
                floats = 'normal',
            },
            sidebars = { 'qf', 'help' },
            dim_inactive = false,
        },
    },
    {
        'gabrielelana/vim-markdown',
        ft = { 'markdown' },
        config = function() g.markdown_mapping_switch_status = '<space>,' end,
    },
    {
        'github/copilot.vim',
        enabled = function()
            local res, hostname = pcall(function()
                local f = io.popen('/bin/hostname')
                local hostname = f:read('*a') or ''
                f:close()
                hostname = string.gsub(hostname, '\n$', '')
                return hostname
            end)
            return (vim.fn.has('nvim-0.9.0') and vim.fn.executable('npm') == 1) and res and
                       string.match(hostname, '%..*evinternal%..*')
        end,
        config = function()
            g.copilot_filetypes = { ['*'] = true, markdown = false, gitcommit = false,
                                    text = false }
            g.copilot_workspace_folders = { '~/src/ev-image-processing' }
            vim.api.nvim_create_autocmd({ 'BufEnter' }, {
                pattern = 'copilot.*',
                callback = function() vim.cmd('ALEDisableBuffer') end,
            })
        end,
        tag = 'v1.45.0',
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = { indent = { char = { '▏' } } },
        version = '*',
        enabled = true,
    },
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            opt.termguicolors = true
            require('colorizer').setup({ css = { css_fn = true }, 'javascript', 'html' },
                                       { mode = 'background', names = false })
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff' },
                lualine_c = {
                    function()
                        local fn = vim.fn
                        if opt.buftype == 'terminal' then
                            return fn.expand('%:t')
                        else
                            return fn.pathshorten(fn.fnamemodify(fn.expand('%:p'), ':~:.')) ..
                                       '%h%m%r'
                        end
                    end,
                },
                lualine_x = {
                    { 'diagnostics', sources = { 'ale' } },
                    function()
                        -- show encoding only if it's not utf-8
                        local ret, _ = (vim.bo.fileencoding or vim.go.encoding):gsub([[^utf%-8$]],
                                                                                     '')
                        return ret
                    end,
                    function()
                        -- don't display if this is unix
                        local ret, _ = vim.bo.fileformat:gsub([[^unix$]], '')
                        return ret
                    end,
                    'filetype',
                    'fileformat',
                },
                lualine_y = {
                    function()
                        if vim.fn['ObsessionStatus'] ~= nil then
                            return vim.fn.ObsessionStatus('󱊈', '󱊍')
                        else
                            return ''
                        end
                    end,
                    'searchcount',
                    'selectioncount',
                },
                lualine_z = { '%l/%L:%c %p%%' },
            },
        },
    },
    {
        'preservim/tagbar',
        config = function()
            g.tagbar_position = 'topleft vertical'
            g.tagbar_zoomwidth = 0
            g.tagbar_autofocus = 1
            g.tagbar_sort = 0
            g.tagbar_compact = 1
            g.tagbar_indent = 1
            g.tagbar_show_dat_type = 1
            g.tagbar_show_visibility = 1
            g.tagbar_show_tag_linenumbers = 1
            g.tagbar_show_tag_count = 1
            g.tagbar_autoshowtag = 1

            vim.keymap.set('n', '<F8>', ':TagbarToggle<CR>',
                           { silent = true, noremap = true, desc = 'Toggle Tagbar.' })
            vim.keymap.set('n', 'TT', ':TagbarToggle<CR>',
                           { silent = true, noremap = true, desc = 'Toggle Tagbar.' })
        end,
        enabled = is_executable('ctags'),
        lazy = true,
        keys = { '<F8>', 'TT' },
    },
    { 'prichrd/netrw.nvim', opts = {}, dependencies = { 'nvim-tree/nvim-web-devicons' } },
    {
        'rhysd/git-messenger.vim',
        config = function()
            g.git_messenger_always_into_popup = true
            g.git_messenger_close_on_cursor_moved = false
            g.git_messenger_date_format = '%F %H:%M:%S'
            g.git_messenger_include_diff = 'current'
            g.git_messenger_max_popup_height = 20
            g.git_messenger_floating_win_opts = { border = 'rounded' }
        end,
    },
    {
        'rktjmp/playtime.nvim',
        opts = { fps = 60 },
        enabled = function()
            local version = vim.version()
            -- 0.10.0 or later
            return version.major >= 1 or (version.major == 0 and version.minor >= 10)
        end,
        cmd = { 'Playtime' },
        -- known good commit, this repo has no tags or versions supplied at this time
        -- commit = 'e01f683',
    },
    { 'rust-lang/rust.vim', ft = 'rust' },
    { 'tpope/vim-apathy' },
    {
        'tpope/vim-commentary',
        keys = { 'gcc', 'gcu', 'gcgc', { 'gc', mode = { 'v', 'o' } } },
        cmd = 'Commentary',
    },
    { 'tpope/vim-endwise' },
    { 'tpope/vim-eunuch' },
    { 'tpope/vim-fugitive', version = '*' },
    { 'tpope/vim-obsession' },
    {
        'tpope/vim-scriptease',
        version = '*',
        keys = { 'zS', { 'K', ft = { 'vim' } }, { 'g=', ft = { 'vim' } } },
        cmd = {
            'Breakadd',
            'Breakdel',
            'Disarm',
            'Messages',
            'PP',
            'PPMsg',
            'Runtime',
            'Scriptnames',
            'Time',
            'Verbose',
        },
    },
    { 'tpope/vim-surround' },
    {
        'tpope/vim-vinegar',
        keys = { '-' },
        config = function()
            g.netrw_dirhistmax = 0
            g.netrw_liststyle = 3 -- tree style listing
        end,
    },
    {
        'w0rp/ale',
        version = '*',
        config = function()
            local function args(tbl) return table.concat(tbl, ' ') end
            g.ale_fixers = {
                ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
                cpp = { 'remove_trailing_lines', 'trim_whitespace', 'clang-format' },
                fish = { 'fish_indent', 'trim_whitespace', 'remove_trailing_lines' },
                go = { 'gofmt' },
                js = { 'clang-format', 'trim_whitespace', 'remove_trailing_lines' },
                json = { 'jq' },
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
            }
            g.ale_linters = {
                go = { 'gofmt' },
                markdown = { 'markdownlint' },
                python = { 'pylsp', 'mypy', 'ruff' },
            }
        end,
    },
    {
        url = 'https://git.ari.lt/ari/wrapped.vim/',
        name = 'vim-wrapped-2025',
        version = '*',
        enabled = function() return os.date('%Y') == '2025' end,
        config = function()
            g.wrapped_ignore_langs = { 'wrapped', 'tmp', 'bak', 'log', 'undotree', 'netrw' }
            g.wrapped_ignore_globs = { 'NetrwTreeListing', '*NetrwTreeListing*' }
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
        end,
    },
}, {
    git = { cooldown = 3600 },
    install = { missing = true, colorscheme = { 'tokyonight', 'darkblue' } },
    ui = {
        size = { width = 0.7, height = 0.8 },
        border = 'rounded',
        backdrop = 40,
        title = 'Lazy Plugin Manager',
        title_pos = 'left',
        icons = {
            cmd = ':',
            config = '¤',
            event = '%',
            ft = '&',
            init = '~',
            keys = '#',
            plugin = '<-',
            runtime = '@',
            require = '%',
            source = '{}',
            start = '!',
            task = '*',
            lazy = '…',
        },
        custom_keys = {
            ['<localleader>l'] = false,
            ['<localleader>i'] = false,
            ['<localleader>t'] = false,
            ['<leader>i'] = {
                function(plugin)
                    require'lazy.util'.notify(vim.inspect(plugin),
                                              { title = 'Inspect ' .. plugin.name, lang = lua })
                end,
                desc = 'Inspect Plugin',
            },
            ['<leader>t'] = {
                function(plugin)
                    require'lazy.util'.float_term(nil, { cwd = plugin.dir })
                end,
                desc = 'Open terminal in plugin dir',
            },
        },
    },
    performance = { rtp = { paths = { USER_HOME .. '/dotfiles/vimfiles' } } },
})
vim.keymap.set('n', '<leader>l', function() require('lazy').home() end,
               { desc = 'Open Lazy home window' })

-- Statusline

opt.laststatus = 2
opt.showmode = false

-- Whitespace
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

opt.breakindent = true

opt.list = true
opt.listchars = {
    conceal = '…',
    eol = '¬',
    extends = '»',
    nbsp = '~',
    precedes = '«',
    tab = '| ',
    trail = '·',
}

-- Display
opt.number = true
vim.cmd('syntax on')

opt.showcmd = true

opt.wrap = false
opt.linebreak = true

opt.wildmenu = true

opt.colorcolumn:append('+0')

opt.cursorline = false
opt.cursorcolumn = false

-- Navigation
opt.splitright = true
opt.splitbelow = true

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'gj', 'j')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'gk', 'k')

if not vim.fn.exists ':TmuxNavigatePrevious' then
    for _, key in ipairs({ 'H', 'J', 'K', 'L' }) do
        vim.keymap.set('n', string.format('<C-%s>', key), string.format('<C-W><C-%s>', key), {
            noremap = true,
            desc = string.format('Move across windows with %s', key),
        })
    end
end

opt.scrolloff = 4
opt.sidescrolloff = 8
opt.sidescroll = 1

opt.foldmethod = 'indent'
opt.foldcolumn = '0'
opt.foldlevelstart = 99
opt.foldopen:append('jump')

vim.o.whichwrap = 'b,s,h,l,<,>,[,]'

opt.matchpairs:append('<:>')

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

local function toggle_search_hls(on_enter)
    if on_enter then
        _G.hls_on = opt.hlsearch:get()
    else
        if _G.hls_on ~= nil then
            opt.hlsearch = _G.hls_on
            _G.hls_on = nil
        end
    end
end

local VimrcIncsearchHighlight = vim.api.nvim_create_augroup('VimrcIncsearchHighlight',
                                                            { clear = true })
vim.api.nvim_create_autocmd({ 'CmdLineEnter' }, {
    pattern = [=[[/\?]]=],
    callback = function() toggle_search_hls(true) end,
    group = VimrcIncsearchHighlight,
})
vim.api.nvim_create_autocmd({ 'CmdLineLeave' }, {
    pattern = [=[[/\?]]=],
    callback = function() toggle_search_hls(false) end,
    group = VimrcIncsearchHighlight,
})

vim.keymap.set({ 'n', 'v' }, '/', '/\\v', { desc = 'Make searches more magic by default.' })
vim.keymap.set({ 'n', 'v' }, '?', '?\\v', { desc = 'Make searches more magic by default.' })

vim.keymap.set({ 'n' }, '<c-l>', function() opt.hlsearch = not opt.hlsearch:get() end,
               { desc = 'Toggle search highlighting.' })

if vim.fn.executable('rg') then
    opt.grepprg = 'rg --vimgrep -- $*'
elseif vim.fn.executable('grep') then
    opt.grepprg = 'grep -Rn -- $*'
else
    opt.grepprg = internal
end

vim.cmd([[command! -nargs=+ -bar Grep silent! grep! <args> | cwindow | redraw!]])

-- Editing
opt.virtualedit:append('block')

local swap = USER_HOME .. '/vimswap'
if not vim.fn.isdirectory(swap) then vim.fn.mkdir(swap, 'p') end
opt.swapfile = true
opt.directory:remove('.')
opt.directory:prepend(swap)

opt.formatoptions:remove('o') -- no autoinsert of comment char on o or O
opt.formatoptions:remove('r') -- no autpinsert of comment char on <CR> in insert mode
opt.formatoptions:append('j') -- remove comment leader when Joining lines
opt.formatoptions:append('1') -- if possible, break lines before one letter words
opt.formatoptions:append('c') -- auto-format comments
opt.formatoptions:remove('t') -- but don't auto-format text

opt.autoread = true
opt.omnifunc = 'ale#completion#OmniFunc'

-- Key and Command Mappings

vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>',
               { noremap = true, desc = 'Switch to the directory of th current buffer.' })
vim.keymap.set('n', '<leader>w', function()
    if not opt.binary:get() and vim.opt.filetype:get() ~= 'diff' then
        local save = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.winrestview(save)
    end
end, { noremap = true, desc = 'Remove trailing whitespace.' })
vim.keymap.set('n', '<C-W>z', function()
    if os.getenv('TMUX') then
        vim.system { 'tmux', 'resize-pane', '-Z' }
    else
        vim.cmd.echom '"Not in a tmux environment!"'
    end
end, { noremap = true, desc = 'Zoom into tmux windows (if possible)' })

vim.api.nvim_create_user_command('RemoveNonbreakingSpaces', function(opts)
    local args = opt.args
    vim.cmd([[:%s/ //g]])
end, {
    bang = false,
    bar = false,
    desc = 'Removes non-breaking spaces from the current buffer',
    force = true,
    nargs = 0,
})

vim.keymap.set('n', '<leader>s', ']Sz=', { desc = 'Spellcheck forward.' })
vim.keymap.set('n', '<leader>S', '[Sz=', { desc = 'Spellcheck backwards.' })

vim.keymap.set('n', 'Q', '<nop>', { desc = 'Disable \'Q\'.' })

vim.keymap.set('n', 'ZA', function() vim.cmd.update() end, { desc = 'Write if needed.' })

opt.mouse = 'a'

vim.api.nvim_create_user_command('LPP', function(opts)
    local args = opts.args
    if args == nil then return end
    local func, err = load('return (' .. args .. ')', '=lpp_chunk', 't')
    if func then
        local ok, res = pcall(func)
        if ok then
            require('pprint').print(res)
        else
            print('Execution error: ', res)
        end
    else
        print('Compilation error: ', err)
    end
end, {
    bang = false,
    bar = false,
    complete = 'lua',
    desc = 'Pretty-print provided lua object',
    nargs = 1,
})

local function backup_plugins()
    local lockfile_path = vim.fn.stdpath('config') .. '/lazy-lock.json'
    local backup_directory = os.getenv('LOCAL_BACKUP_LOCATION') or (USER_HOME .. '/.backup')
    local backup_path = backup_directory .. '/' .. vim.fn.strftime([[nvim-plugins-%Y-%m-%d.json]])
    if vim.fn.filereadable(backup_path) == 0 then
        -- we're reading here, checking for well-formed JSON and writing it out to the backup location
        local lock = assert(io.open(lockfile_path, 'r'),
                            'Cannot open lockfile at "' .. lockfile_path .. '"')
        local locks = vim.json.decode(lock:read('*all'))
        locks['_version'] = vim.version()
        local backup = assert(io.open(backup_path, 'w'),
                              'Cannot open file for writing at "' .. backup_path .. '"')
        backup:write(vim.json.encode(locks))
        backup:close()
    end
end

vim.api.nvim_create_user_command('BackupPlugins', backup_plugins, { bang = true })

if os.date('%A') == 'Monday' or os.date('%A') == 'Thursday' then
    print('Backing up plugin configuration')
    backup_plugins()
end

local function manage_lazy(concurrent_jobs)
    local n_jobs = concurrent_jobs or 5 -- this is tuned so that it's fast but I still see work being done
    require'lazy'.sync { show = true, wait = true, concurrency = n_jobs }
end

local function maintainence()
    print('Backing up plugin configuration')
    backup_plugins()
    print('Syncing Lazy plugin status')
    manage_lazy(8)
    vim.cmd.checkhealth()
end

vim.api.nvim_create_user_command('AutoMaintain', maintainence, { bang = true })

-- Misc Options

opt.backspace = { 'indent', 'eol', 'start' }

opt.encoding = 'utf-8'

opt.history = 1000

opt.visualbell = true

opt.spellsuggest = '15'

opt.modeline = true
opt.modelines = 5
opt.modelineexpr = false

local Vimrc = vim.api.nvim_create_augroup('Vimrc', { clear = true })

if opt.diff:get() then
    vim.cmd.highlight({ args = { 'link', 'DiffText', 'MatchParen' }, bang = true })
    vim.cmd.command('Q qall')
    vim.cmd('silent! ALEDisable')

    opt.number = false
    opt.signcolumn = 'no'
    opt.foldopen:remove('all')
    -- set statusline to something simple
    opt.statusline = '%f %= %y'
    -- hide lualine
    vim.api.nvim_create_autocmd({ 'VimEnter' }, {
        pattern = '*',
        callback = function() require'lualine'.hide() end,
        desc = 'Hide lualine while viewing diffs',
        group = Vimrc,
        once = true,
    })
end

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.js,*.css,*.htm,*.html,*.php',
    callback = function()
        opt.autoindent = true
        opt.fileformat = 'unix'
        opt.foldmethod = 'indent'
        opt.expandtab = false
        opt.shiftwidth = 2
        opt.softtabstop = 2
        opt.tabstop = 2
    end,
    group = Vimrc,
})
vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
    pattern = '*.py,*.pyw',
    callback = function()
        if vim.fn.pumvisible() == 0 and vim.fn.winnr('$') > 1 then vim.cmd.pclose() end
    end,
    group = Vimrc,
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.prototxt',
    callback = function() opt.filetype = 'prototxt' end,
    group = Vimrc,
})
vim.api.nvim_create_autocmd({ 'WinResized', 'WinNew', 'WinEnter' }, {
    pattern = '*',
    callback = function()
        local SCROLLOFF_PERCENTAGE = 0.25
        opt.scrolloff = math.floor(vim.o.lines * SCROLLOFF_PERCENTAGE)
    end,
    desc = 'Set scrolloff automatically',
    group = Vimrc,
})

g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Color
opt.termguicolors = true
vim.cmd.colorscheme 'tokyonight'

-- Gui Options

pcall(function()
    opt.guioptions:remove({ 'e', 'T', 'l', 'L', 'r', 'R', 'm' })
    opt.guioptions:append({ 'c' })
end)
