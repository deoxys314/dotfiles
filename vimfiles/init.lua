local g = vim.g
local opt = vim.opt
-- some setup before plugins run
g.mapleader = ' '
g.polyglot_disabled = { 'markdown' }

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
        config = function() if vim.fn.executable('git') then vim.opt.updatetime = 100 end end,
    },
    { 'airblade/vim-rooter', config = function() g.rooter_silent_chdir = 1 end },
    {
        'alvan/vim-closetag',
        config = function()
            g.closetag_filenames = table.concat({ '*.html', '*.htm', '*.xml', '*.php' }, ',')
        end,
    },
    { 'andymass/vim-matchup' },
    { 'chriskempson/base16-vim' },
    { 'christoomey/vim-tmux-navigator' },
    {
        'dcampos/nvim-snippy',
        config = {
            mappings = {
                is = { ['<Tab>'] = 'expand_or_advance', ['<S-Tab>'] = 'previous' },
                nx = { ['<leader>x'] = 'cut_text' },
            },
        },
        dependencies = { 'honza/vim-snippets' },
    },
    {
        'folke/zen-mode.nvim',
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
            on_open = function(win) end,
            on_close = function() end,
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
        config = function() g.markdown_mapping_switch_status = '<space>,' end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = {
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
                },
            },
            indent = { enable = true },
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

            vim.keymap.set('n', '<F8>', ':TagbarToggle<CR>', { silent = true })
            vim.keymap.set('n', 'TT', ':TagbarToggle<CR>', { silent = true })
        end,
        enabled = vim.fn.executable('ctags'),
        lazy = true,
        keys = { '<F8>', 'TT' },
    },
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
    { 'rust-lang/rust.vim' },
    { 'sheerun/vim-polyglot' },
    { 'tpope/vim-apathy' },
    { 'tpope/vim-commentary' },
    { 'tpope/vim-endwise' },
    { 'tpope/vim-eunuch' },
    { 'tpope/vim-fugitive', version = '*' },
    { 'tpope/vim-obsession' },
    { 'tpope/vim-projectionist' },
    { 'tpope/vim-scriptease' },
    { 'tpope/vim-surround' },
    {
        'tpope/vim-vinegar',
        config = function()
            g.netrw_dirhistmax = 0
            g.netrw_liststyle = 3 -- tree style listing
        end,
    },
    {
        'williamboman/mason.nvim',
        version = '*',
        dependencies = { 'williamboman/mason-lspconfig.nvim', 'neovim/nvim-lspconfig' },
        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = { 'clangd', 'jsonls', 'lua_ls', 'pylsp' },
            })
            require('lspconfig').clangd.setup({ filetypes = { 'c', 'cpp', 'h', 'hpp' } })
        end,
        enabled = false, -- this is experimental at best
    },
    {
        'w0rp/ale',
        version = '*',
        config = function()
            g.ale_fixers = {
                ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
                cpp = { 'remove_trailing_lines', 'trim_whitespace', 'clang-format' },
                fish = { 'fish_indent', 'trim_whitespace', 'remove_trailing_lines' },
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
                '--spaces-inside-table-braces',
            }, ' ')
            g.ale_linters = { python = { 'pylsp', 'mypy', 'ruff' }, markdown = { 'markdownlint' } }
        end,
    },

}, {
    performance = { rtp = { paths = { os.getenv('HOME') .. '/dotfiles/vimfiles' } } },
    ui = {
        icons = {
            cmd = '⌘',
            config = '¤',
            event = '%',
            ft = '&',
            init = '⚙',
            keys = '#',
            plugin = '@',
            runtime = '<=>',
            require = '%',
            source = '{}',
            start = '>',
            task = '*',
            lazy = '…',
        },
    },
    profiling = { loader = true, require = true },
})

-- Statusline

opt.laststatus = 2
opt.showmode = false

local statusline = require('statusline')

vim.opt.statusline = [[%!v:lua.require('statusline').active_status_line()]]

local StatusLine = vim.api.nvim_create_augroup('StatusLine', { clear = true })
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    pattern = '*',
    callback = statusline.update_inactive_windows,
    group = StatusLine,
    desc = 'set statuslines properly',
})
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
    pattern = '*',
    callback = function() statusline.set_status_line(true) end,
    group = StatusLine,
})
vim.api.nvim_create_autocmd({ 'WinLeave' }, {
    pattern = '*',
    callback = function() statusline.set_status_line(false) end,
    group = StatusLine,
})
vim.api.nvim_create_autocmd({ 'ColorScheme', 'VimEnter' }, {
    pattern = '*',
    callback = statusline.set_colors,
    group = StatusLine,
})

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

for _, key in ipairs({ 'H', 'J', 'K', 'L' }) do
    vim.keymap.set('n', string.format('<C-%s>', key), string.format('<C-W><C-%s>', key))
end

opt.scrolloff = 4
opt.sidescrolloff = 8
opt.sidescroll = 1

opt.foldmethod = 'marker'
opt.foldlevelstart = 99
opt.foldopen:append('all')
opt.foldclose = 'all'

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

vim.keymap.set({ 'n', 'v' }, '/', '/\\v')
vim.keymap.set({ 'n', 'v' }, '?', '?\\v')

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

local swap = os.getenv('HOME') .. '/vimswap'
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

vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>')
vim.keymap.set('n', '<leader>w', function()
    if not opt.binary:get() and vim.opt.filetype:get() ~= 'diff' then
        local save = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]])
        vim.cmd.winrestview(save)
    end
end)

vim.keymap.set('n', '<leader>s', ']Sz=')
vim.keymap.set('n', '<leader>S', '[Sz=')

vim.keymap.set('n', 'Q', '<nop>')

vim.keymap.set('n', 'ZA', ':w<CR>')

opt.mouse = 'a'

-- Misc Options

opt.backspace = { 'indent', 'eol', 'start' }

opt.encoding = 'utf-8'

opt.history = 1000

opt.fileformat = 'unix'

opt.visualbell = true

opt.spellsuggest = '15'

opt.modeline = true
opt.modelines = 5
opt.modelineexpr = false

if opt.diff:get() then
    vim.cmd.highlight({ args = { 'link', 'DiffText', 'MatchParen' }, bang = true })
    vim.cmd.command('Q qall')
    vim.cmd('silent! ALEDisable')

    opt.number = false
    opt.signcolumn = false
    opt.foldopen:remove('all')
end

local Vimrc = vim.api.nvim_create_augroup('Vimrc', { clear = true })
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

-- Color
opt.termguicolors = true
vim.cmd.colorscheme('base16-solarized-dark')

-- Gui Options

pcall(function()
    opt.guioptions:remove({ 'e', 'T', 'l', 'L', 'r', 'R', 'm' })
    opt.guioptions:append({ 'c' })
end)
