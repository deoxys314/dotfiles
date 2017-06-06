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
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Airline, a nicer statusline
Plugin 'vim-airline/vim-airline'

" adds a new verb
Plugin 'tpope/vim-surround'

" more motions, activated by <leader><leader>w
Plugin 'easymotion/vim-easymotion'

" nice colorscheme, if possible
Plugin 'altercation/vim-colors-solarized'

" filesystem navigation
Plugin 'scrooloose/nerdtree'

" git integration
Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


"##### Plugin Settings #####

"Vundle
map <leader>U :PluginUpdate<CR>

" airline
set laststatus=2
let g:airline_section_error = ''

" solarized
set background=dark
silent! colorscheme solarized

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" easymotion
let g:EasyMotion_keys = 'asdfghjklqwertyuiopzxcvbnm;ASDFGHJKLQWERTYUIOPZXCVBNM'

"##### Whitespace Options #####

set tabstop=4
set softtabstop=4
set shiftwidth=4

set listchars=eol:$,tab:>\ ,nbsp:#,trail:_,extends:>,precedes:<
set list


"##### Display Options #####

set number     " line numbers
syntax on      " syntax hilighting

set showcmd    " show incomplete commands

set nowrap     " don't wrap lines
set linebreak  " if I do turn on wrap, work breaks

" to check line lengths
set colorcolumn=100

" ##### Navigation options #####

" split navigations
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

"##### Function Definitions #####

" remove trailing whitespace on <leader>w, thanks Scolby
fun! TrimWhitespace()
	let l:save = winsaveview()
	%s/\s\+$//e
	call winrestview(l:save)
endfun
nnoremap <Leader>w :call TrimWhitespace()<CR>


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

"##### Filetype Options #####
source ~/deoxys314_dotfiles/files.vim

"##### Windows Compatability #####
if has("win32") || has("win16")
	set lines=48 columns=160
	colorscheme industry
endif
