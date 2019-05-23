" Cameron Rossington .vimrc

" ##### Plugins ###

" vim has worked around all the POSIX oddities that fish doesn't have
" so when it tries to use fish things get very confused.  Fortunately, this
" was fixed in 7.4, patch 276
if v:version < 705 && &shell =~# 'fish$'
    set shell=sh
endif

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'                    " git info in sign gutter
Plug 'airblade/vim-rooter'
Plug 'alvan/vim-closetag'                        " Closes (x)html tags as you type
Plug 'chriskempson/base16-vim'                   " Base16 themes (compatible with airline)
if executable('tmux')
	Plug 'christoomey/vim-tmux-navigator'        " navigate vim and tmux panes seamlessly
endif
Plug 'cormacrelf/vim-colors-github'              " a light theme based on github
Plug 'deoxys314/vim-rng'                         " exposes some RNG functions
Plug 'lervag/vimtex'                             " motiuons, objects and compilation for LaTeX
Plug 'lifepillar/vim-mucomplete'                 " smoother completions
Plug 'rhysd/git-messenger.vim'                   " git commit viewing
Plug 'tmhedberg/SimpylFold', { 'for': 'python' } " better python folding
Plug 'tpope/vim-commentary'                      " commenting
Plug 'tpope/vim-surround'                        " adds a new verb, surround
Plug 'tpope/vim-vinegar'                         " beter netrw
Plug 'vim-airline/vim-airline'                   " Airline, a nicer statusline
Plug 'vim-airline/vim-airline-themes'            " Nice themes for above
Plug 'w0rp/ale'                                  " linting and LSP support

" Languages
Plug 'ambv/black',                { 'on': 'Black' , 'for': 'python' } " python formatting
Plug 'dag/vim-fish',              { 'for': 'fish' }                   " editing fish scripts
Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }               " even better github markdown
Plug 'PProvost/vim-ps1',          { 'for': 'ps1' }                    " powershell syntax and formatting
Plug 'rust-lang/rust.vim',        { 'for': 'rust' }                   " rust-lang
if executable('racer')
	Plug 'racer-rust/vim-racer',  { 'for': 'rust' }                   " completions
endif


" All plugins must be added before the following line
call plug#end()

" must be set before mappings below
let mapleader = ' '


" ##### Plugin Settings ###

" Airline
set laststatus=2
let g:airline#extensions#whitespace#enabled = 0

let g:airline_powerline_fonts = 0
let g:airline_symbols_ascii = 1 " I don't always have unicode available
let g:airline_section_z='%3p%% [l:%2l c:%2v]'
set noshowmode " airline already does this

" ALE
let g:ale_fixers = get(g:, 'ale_fixers', {})
let g:ale_fixers['*'] = ['remove_trailing_lines']

" Black
let g:black_linelength=120

" Closetag
let g:closetag_filenames='*.html,*.htm,*.xml,*.php'

" GitGutter
if executable('git')
	set updatetime=1000
end

" git-messenger
let g:git_messenger_include_diff = 'current'
if !has('nvim')
	let g:git_messenger_max_popup_height = 20
endif

" Hardtime
let g:hardtime_default_on = 1

" Markdown
let g:markdown_mapping_switch_status = '<space><space>'

" mucomplete
set completeopt+=menuone
set completeopt+=noinsert
set belloff+=ctrlg
set shortmess+=c
let g:mucomplete#chains = { 'default':  ['path', 'omni', 'keyn', 'dict', 'uspl'] }
let g:mucomplete#chains.vim =      ['path', 'cmd', 'keyn']
let g:mucomplete#chains.markdown = ['uspl', 'dict', 'path', 'omni']
let g:mucomplete#chains.text = g:mucomplete#chains.markdown
let g:mucomplete#chains.fish = ['omni', 'incl', 'file']
let g:mucomplete#spel#max = 10

" netrw
let g:netrw_dirhistmax = 0
let g:netrw_liststyle = 3

" Rooter
let g:rooter_silent_chdir = 1

" SimplyFold
let g:SimpylFold_docstring_preview = 1

" Syntastic
let g:syntastic_always_populate_loc_list = 1



" ##### Whitespace Options ###

set shiftwidth=4
set softtabstop=4
set tabstop=4

" show wrapped lines
set showbreak=>>>\ 

" keep indent same when wrapping
set breakindent

set list
set listchars=eol:$,tab:>\ ,nbsp:#,trail:_,extends:>,precedes:<


" ##### Display Options ###

set number     " line numbers
syntax on      " syntax highlighting

set showcmd    " show incomplete commands

set nowrap     " don't wrap lines
set linebreak  " don't break in the middle of a word

set wildmenu   " better tab-completion

" to check line lengths
set colorcolumn=+0

" colorscheme
set background=dark
silent! set termguicolors


" ##### Navigation options ###

" split navigations
set splitright
set splitbelow

" navigate splits with <Ctrl-hjkl>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" j and k by lines on screen, as with modern editors
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

" scrolling
set scrolloff=4
set sidescrolloff=8
set sidescroll=1

" folding options
set foldmethod=indent
set foldlevel=99

" wraps h and l like modern editors
set whichwrap+=h,l,<,>,[,]

" let % bounce between angle brackets as well
set matchpairs+=<:>


" ##### Search options ###
set incsearch  " go to results as you type
set ignorecase " ignore case in search . . .
set smartcase  " unless I type a capital letter

augroup vimrc-insearch-highlight
	autocmd!
	autocmd CmdLineEnter [/\?] call search#toggle_hls(1)
	autocmd CmdLineLeave [/\?] call search#toggle_hls(0)
augroup END

" automatically make searches "more magic" aka sane
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v


" ##### Editing Options ###

" virtual edit in visual mode
set virtualedit+=block

" swap file
let s:swap = $HOME . '/vimswap'
if !isdirectory(s:swap)
	call mkdir(s:swap, 'p')
endif
set swapfile
set directory-=.
execute 'set directory^=' . s:swap

" formatting options, mostly dealing with comment characters
set formatoptions-=o " no autoinsert of comment char on o or O
set formatoptions-=r " no autoinsert of comment char on <CR> in insert mode
set formatoptions+=j " remove comment leader when Joining lines
set formatoptions+=1 " if possible, break line before one letter word
set formatoptions+=c " auto-format comments
set formatoptions-=t " but don't auto-format text

" automagically load changes from disk
set autoread

" make :find and friends better
set path+=**


" ##### Key and Command Mappings ###

" cd to :head of :path
nnoremap <Leader>cd :cd %:p:h<CR>

" remove trailing whitespace
nnoremap <Leader>w :call whitespace#TrimWhitespace()<CR>

" go to next misspelled word and suggest
nnoremap <Leader>s ]Sz=

" I don't like Ex mode
nnoremap Q <nop>

" compliment to ZZ and ZQ
nnoremap ZA :w<CR>

" using mouse
set mouse=a

" color options
command! RandomColorScheme call color#RandomColorScheme()
command! NextColorScheme call color#NextColorScheme()
command! PreviousColorScheme call color#PreviousColorScheme()


" ##### Misc Options ###

" make backspace work the way it dos in most editors
set backspace=indent,eol,start

" UTF-8
set encoding=utf-8

" store a lot of history
set history=1000

" Unix line endings
set fileformat=unix

" no sound, just flash the screen
set visualbell

" Make spell not take over entire screen
set spellsuggest=15

" no modelines: potential security issue
set modelines=0

if &diff
	" Makes diff easier to read
	" https://vi.stackexchange.com/a/626
	highlight! link DiffText MatchParen

	" easier to quit both at once in diff mode
	command! Q qall

	" disable linting
	ALEDisable
endif


" ##### Filetype Options ###
source <sfile>:p:h/files.vim


" ##### Autoload functions ###
execute 'set runtimepath+=' . expand('<sfile>:p:h') . '/vimfiles'
