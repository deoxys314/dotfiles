" Cameron Rossington .vimrc

" ##### Plugins ###

" vim has worked around all the POSIX oddities that fish doesn't have
" so when it tries to use fish things get very confused
if &shell =~# 'fish$'
    set shell=sh
endif

call plug#begin('~/.vim/plugged')

if executable('git')
	Plug 'airblade/vim-gitgutter'                " git info in sign gutter
end
Plug 'airblade/vim-rooter'
Plug 'alvan/vim-closetag'                        " Closes (x)html tags as you type
Plug 'chriskempson/base16-vim'                   " Base16 themes (compatible with airline)
Plug 'christoomey/vim-tmux-navigator'            " navigate vim and tmux panes seamlessly
Plug 'cormacrelf/vim-colors-github'              " a light theme based on github
Plug 'junegunn/goyo.vim'                         " for writing prose
Plug 'junegunn/limelight.vim'                    " also for writing prose
Plug 'Konfekt/FastFold'                          " Fast folding
Plug 'lifepillar/vim-mucomplete'                 " smoother completions
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


" ##### Plugin Settings ###

" Airline
set laststatus=2
autocmd VimEnter * AirlineToggleWhitespace " This event only fires once so an augroup is not needed

let g:airline_powerline_fonts = 0
let g:airline_symbols_ascii = 1 " I don't always have unicode available
let g:airline_section_z='%3p%% [l:%2l c:%2v]'
nnoremap <Leader>a :AirlineToggleWhitespace<CR>
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

" Hardtime
let g:hardtime_default_on = 1

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

" Prose (Goyo and LimeLight)
function! s:goyo_enter()
	let g:temp_colo_store = g:colors_name
	silent! colorscheme base16-solarized-light
	Limelight
	setlocal scrolloff=999
	setlocal statusline=%m
	hi StatusLine ctermfg=red guifg=red gui=NONE cterm=NONE
endfunction

function! s:goyo_leave()
	set scrolloff=4
	Limelight!
	execute 'colorscheme ' . g:temp_colo_store
	unlet g:temp_colo_store
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

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
set linebreak  " if I do turn on wrap, breaks work

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

" Enable folding with spacebar
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" wraps h and l like modern editors
set whichwrap+=h,l,<,>,[,]

" let % bounch between angle brackets as well
set matchpairs+=<:>


" ##### Search options ###
set incsearch  " go to results as you type
set ignorecase " ignore case in search . . .
set smartcase  " unless I type a capital letter

" automatically make searches "more magic" aka sane
nnoremap / /\v
vnoremap / /\v


" ##### Editing Options ###

" virtual edit in visual mode
set virtualedit=block

" swap file
let s:swap = $HOME . "/vimswap"
if !isdirectory(s:swap)
	call mkdir(s:swap, "p")
endif
set swapfile
set directory-=.
execute "set directory^=" . s:swap

" formatting options, mostly dealing with comment characters
set formatoptions-=o " no autoinsert of comment char on o or O
set formatoptions-=r " no autoinsert of comment char on <CR> in insert mode
set formatoptions+=j " remove comment leader when Joining lines
set formatoptions+=1 " if possible, break line before one letter word

" automagically load changes from disk
set autoread


" ##### Function Definitions ###

" remove trailing whitespace on <leader>w, thanks Scolby
function! TrimWhitespace() abort
	let l:save = winsaveview()
	%s/\s\+$//e
	call winrestview(l:save)
endfunction
nnoremap <Leader>w :call TrimWhitespace()<CR>

" Open file under cursor in new tab
nnoremap <Leader>t <C-W>gf


" ##### Key Mappings ###

" cd to :head of :path
nnoremap <Leader>cd :cd %:p:h<CR>

" go to next misspelled word and suggest
nnoremap <Leader>s ]Sz=

" I don'y like Ex mode
nnoremap Q <nop>

" compliment to ZZ and ZQ
nnoremap ZA :w<CR>

" using mouse
set mouse=a


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
