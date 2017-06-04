" Cameron Rossington .vimrc
" created 170420

"###VUNDLE PLUGINS###
"
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
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










"### TEMP OPTIONS ###

set number
syntax on
set visualbell
set lines=48 columns=160
set backspace=indent,eol,start
set nowrap

" whitespace chars
set tabstop=4
set softtabstop=4
set shiftwidth=4

set listchars=eol:$,tab:>-,nbsp:#,trail:_,extends:>,precedes:<
set list


" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding with spacebar
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" UTF-8
set encoding=utf-8

" remove trailing whitespace on save, thanks Scolby
fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
nnoremap <Leader>w :call TrimWhitespace()<CR>

" airline
set laststatus=2
