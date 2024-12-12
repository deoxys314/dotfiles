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
        'alanfortlink/blackjack.nvim',
        cmd = { 'BlackJackNewGame' },
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { card_style = 'large', suit_style = 'black' },
    },
    {
        'alvan/vim-closetag',
        config = function()
            g.closetag_filenames = table.concat({ '*.html', '*.htm', '*.xml', '*.php' }, ',')
        end,
        ft = { 'html', 'htm', 'xml', 'php' },
    },
    { 'andymass/vim-matchup' },
    { 'chriskempson/base16-vim', priority = 1000, enabled = false },
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
        connfig = function()
            -- when leaving vim, will :update
            vim.g.tmux_navigator_save_on_switch = 2
        end,
    },
    {
        'dcampos/nvim-snippy',
        event = { 'InsertEnter' },
        opts = {
            mappings = {
                is = { ['<Tab>'] = 'expand_or_advance', ['<S-Tab>'] = 'previous' },
                nx = { ['<leader>x'] = 'cut_text' },
            },
        },
        dependencies = { 'honza/vim-snippets' },
        enabled = false,
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
        'folke/zen-mode.nvim',
        version = '*',
        cmd = { 'ZenMode', 'Prose' },
        ft = { 'markdown', 'rst' },
        opts = {
            window = {
                width = .85,
                height = .85,
                options = {
                    signcolumn = 'no',
                    number = false,
                    relativenumber = false,
                    cursorline = false,
                    cursorcolumn = false,
                    foldcolumn = '0',
                    list = false,
                },
            },
            plugins = {
                -- disable some global vim options (vim.o...)
                options = {
                    enabled = true,
                    ruler = false, -- disables the ruler text in the cmd line area
                    showcmd = false, -- disables the command in the last line of the screen
                    -- laststatus = 0, -- turn off the statusline in zen mode
                },
                twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
                gitsigns = { enabled = false }, -- disables git signs
                tmux = { enabled = false }, -- disables the tmux statusline
            },
            on_open = function(win)
                _G.zen_mode_stored_scrolloff = opt.scrolloff:get()
                opt.scrolloff = 99
            end,
            on_close = function()
                opt.scrolloff = _G.zen_mode_stored_scrolloff or 4
                _G.zen_mode_stored_scrolloff = nil
            end,
        },
        config = function()
            vim.api.nvim_create_user_command('Prose', function()
                require('zen-mode').toggle({
                    window = {
                        width = .8,
                        height = 1,
                        options = {
                            signcolumn = 'no',
                            number = false,
                            relativenumber = false,
                            cursorline = false,
                            cursorcolumn = false,
                            foldcolumn = '0',
                            list = false,
                        },
                    },
                })
            end, { force = false, desc = 'Setup neovim for writing prose' })
        end,
        dependencies = {
            'folke/twilight.nvim',
            version = '*',
            opts = {
                context = 5,
                treesitter = false,
                exclude = {
                    'git',
                    'gitattributes',
                    'gitcommit',
                    'gitconfig',
                    'gitignore',
                    'gitrebase',
                    'gitsendmail',
                },
            },
        },
    },
    {
        'gabrielelana/vim-markdown',
        ft = { 'markdown' },
        config = function() g.markdown_mapping_switch_status = '<space>,' end,
    },
    {
        'jim-fx/sudoku.nvim',
        cmd = { 'Sudoku' },
        config = function()
            local faded_color = '#7d7d7d'
            require('sudoku').setup {
                persist_settings = true,
                persist_games = true,
                default_mappings = true,
                custom_highlights = {
                    board = { fg = faded_color },
                    set_number = { fg = faded_color, gui = 'italic' },
                },
            }
        end,
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
                    'ObsessionStatusLine',
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
                },
                lualine_y = { 'searchcount', 'selectioncount' },
                lualine_z = { '%l:%c %p%%' },
            },
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-symbols.nvim',
            {
                'andrew-george/telescope-themes',
                config = function() require'telescope'.load_extension 'themes' end,
            },
            {
                'tsakirist/telescope-lazy.nvim',
                config = function() require'telescope'.load_extension 'lazy' end,
            },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = [[cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build]],
                enabled = is_executable 'cmake',
            },
        },
        cmd = { 'Telescope' },
        keys = { '<leader>ff' },
        config = function()
            local builtin = require 'telescope.builtin'
            local actions = require 'telescope.actions'
            vim.keymap.set('n', '<leader>ff', builtin.find_files,
                           { desc = 'Open Telescope in file finding mode.' })
            require'telescope'.setup {
                defaults = { mappings = { i = { ['<esc>'] = actions.close, ['<C-u>'] = false } } },
                pickers = {
                    find_files = { theme = 'dropdown' },
                    spell_suggest = { theme = 'dropdown' },
                    pickers = { theme = 'dropdown' },
                },
                extensions = { lazy = { show_icon = false, theme = 'dropdown' } },
            }

        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        version = '*',
        build = ':TSUpdate',
        enabled = false,
        opts = {
            ensure_installed = {
                'c',
                'cmake',
                'cpp',
                'css',
                'dockerfile',
                'fish',
                'go',
                'html',
                'json',
                'json5',
                'latex',
                'lua',
                'python',
                'rust',
                'toml',
                'typescript',
                'vim',
            },
            auto_install = true,
            highlight = {
                enable = true,
                disable = {
                    'git',
                    'gitattributes',
                    'gitcommit',
                    'gitconfig',
                    'gitignore',
                    'gitrebase',
                    'gitsendmail',
                    'help',
                    'vimdoc',
                },
            },
            indent = { enable = true, disable = { 'help', 'vimdoc' } },
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
    { 'sakhnik/nvim-gdb', enabled = function() return is_executable 'gdb' end },
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
    { 'tpope/vim-projectionist' },
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
    { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {}, enabled = false },
    {
        'w0rp/ale',
        version = '*',
        config = function()
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
            g.ale_markdown_mdl_options = '--rule ~MD029 --rule ~MD005'
            g.ale_markdown_writegood_options = '--no-passive'
            g.ale_lua_lua_format_options = table.concat({
                '--break-after-table-lb',
                '--chop-down-table',
                '--column-limit=99',
                '--double-quote-to-single-quote',
                '--extra-sep-at-table-end',
                '--keep-simple-control-block-one-line',
                '--spaces-inside-table-braces',
            }, ' ')
            g.ale_linters = {
                go = { 'gofmt' },
                markdown = { 'markdownlint' },
                python = { 'pylsp', 'mypy', 'ruff' },
            }
        end,
    },

}, {
    performance = { rtp = { paths = { USER_HOME .. '/dotfiles/vimfiles' } } },
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
    },
    profiling = { loader = true, require = true },
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
        once=true,
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
