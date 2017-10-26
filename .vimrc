" Cameron Rossington .vimrc
" created 170420


"##### Vundle Plugins #####
set nocompatible              " be iMproved, required
filetype off                  " required

if &shell =~# 'fish$'
    set shell=sh
endif


" set the runtime path to include Vundle and initialize
" Includes possible paths for win and *nix
set rtp+=~/vimfiles/bundle/Vundle.vim
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'             " let Vundle manage Vundle, required

Plugin 'alvan/vim-closetag'               " Closes (x)html tags as you type
Plugin 'chriskempson/base16-vim'          " Base16 themes (compatible with airline)
Plugin 'christoomey/vim-tmux-navigator'   " navigate vim and tmux panes seamlessly
Plugin 'dag/vim-fish'                     " editing fish scripts
Plugin 'easymotion/vim-easymotion'        " more motions, activated by <leader><leader>w
Plugin 'fcpg/vim-farout'                  " theme emulating late 70's colors
Plugin 'gabrielelana/vim-markdown'        " even better github markdown
Plugin 'Konfekt/FastFold'                 " Fast folding
Plugin 'PProvost/vim-ps1'                 " powershell syntax and formatting
Plugin 'tmhedberg/matchit'                " better matching for %
Plugin 'tmhedberg/SimpylFold'             " better python folding
Plugin 'tomtom/tcomment_vim'              " commenting
Plugin 'tpope/vim-surround'               " adds a new verb
Plugin 'vim-airline/vim-airline'          " Airline, a nicer statusline
Plugin 'vim-airline/vim-airline-themes'   " Nice themes for above

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

"##### Plugin Settings #####

"Vundle
map <leader>U :PluginUpdate<CR>
map <leader>I :PluginInstall<CR>

" airline
set laststatus=2
autocmd VimEnter * AirlineToggleWhitespace
let g:airline_powerline_fonts = 0
let g:airline_symbols_ascii = 1 " I don't always have unicode available
nnoremap <Leader>a :AirlineToggleWhitespace<CR>
set noshowmode " airline already does this

" easymotion
let g:EasyMotion_keys = 'asdfghjklqwertyuiopzxcvbnm;DFGHJKLQWERTYUIOPZXCVBNMAS'

" SimplyFold
let g:SimplyFold_docstring_preview = 1
let g:SimplyFold_fold_import = 0
let b:SimplyFold_fold_import = 0

" vim-markdown
let g:markdown_enable_spell_checking = 0


"##### Whitespace Options #####

set tabstop=4
set softtabstop=4
set shiftwidth=4

" show wrapped lines
set showbreak=>>>\ 

set list
set listchars=eol:$,tab:>\ ,nbsp:#,trail:_,extends:>,precedes:<


"##### Display Options #####

set number     " line numbers
syntax on      " syntax hilighting

set showcmd    " show incomplete commands

set nowrap     " don't wrap lines
set linebreak  " if I do turn on wrap, work breaks

" to check line lengths
set colorcolumn=100

" colorscheme
set background=dark
set termguicolors

if has("gui_running")
    colorscheme base16-google-dark
else
	" 256 colors in terminal
	set t_Co=265
	set term=xterm-256color
endif


" ##### Navigation options #####

" split navigations
set splitright
set splitbelow

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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


" ##### Search options #####
"set hlsearch   " show search result
set incsearch  " go to results as you type
set ignorecase " ignore case in search


" ##### Editing Options #####

" virtual edit in visual mode
set virtualedit=block

" no swap file
set noswapfile

" ##### Function Definitions #####

" remove trailing whitespace on <leader>w, thanks Scolby
fun! TrimWhitespace()
	let l:save = winsaveview()
	%s/\s\+$//e
	call winrestview(l:save)
endfun
nnoremap <Leader>w :call TrimWhitespace()<CR>


" ##### Key Mappings #####

nnoremap <Leader>cd :cd %:p:h<CR>


" ##### Misc Options #####

" make backspace work the way it dos in most editors
set backspace=indent,eol,start

" UTF-8
set encoding=utf-8

" store a lot of history
set history=1000

" unix line endings
set fileformat=unix

" no sound, just flash the screen
set visualbell

" Makes diff easier to read
" https://vi.stackexchange.com/a/626
if &diff
	highlight! link DiffText MatchParen
endif


"##### Filetype Options #####
source ~/deoxys314_dotfiles/files.vim


"##### GUI Options #####
if has('gui_running')

	" ###FONT###
	set guifont=Source\ Code\ Pro\ Light:h13

	" ### GUIOPTIONS
	set guioptions-=e " text tabs
	set guioptions-=l " no left scrollbar
	set guioptions-=L " no left scrollbar when vertical split active
	set guioptions-=r " no right scrollbar
	set guioptions-=R " no right scrollbar when vertical split active

endif
