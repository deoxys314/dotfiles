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
Plugin 'easymotion/vim-easymotion'        " more motions, activated by <leader><leader>w
Plugin 'Konfekt/FastFold'                 " Fast folding
Plugin 'tmhedberg/SimpylFold'             " better python folding
Plugin 'tomtom/tcomment_vim'              " commenting
Plugin 'tpope/vim-surround'               " adds a new verb, surround
Plugin 'vim-airline/vim-airline'          " Airline, a nicer statusline
Plugin 'vim-airline/vim-airline-themes'   " Nice themes for above

" Languages
Plugin 'dag/vim-fish'                     " editing fish scripts
Plugin 'gabrielelana/vim-markdown'        " even better github markdown
Plugin 'PProvost/vim-ps1'                 " powershell syntax and formatting
Plugin 'rust-lang/rust.vim'               " rust-lang

" Testing
Plugin 'airblade/vim-gitgutter'           " git info in sign gutter

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ


"##### Plugin Settings #####

" Airline
set laststatus=2
autocmd VimEnter * AirlineToggleWhitespace
let g:airline_powerline_fonts = 0
let g:airline_symbols_ascii = 1 " I don't always have unicode available
nnoremap <Leader>a :AirlineToggleWhitespace<CR>
set noshowmode " airline already does this

" Easymotion
let g:EasyMotion_keys = 'asdfghjklqwertyuiopzxcvbnm;DFGHJKLQWERTYUIOPZXCVBNMAS'

" SimplyFold
let g:SimplyFold_docstring_preview = 1
let g:SimplyFold_fold_import = 0
let b:SimplyFold_fold_import = 0

" Vim-markdown
let g:markdown_enable_spell_checking = 0

" GitGutter
set updatetime=1000

"##### Whitespace Options #####

set tabstop=4
set softtabstop=4
set shiftwidth=4

" show wrapped lines
set showbreak=>>>\ 

" keep indent same when wrapping
set breakindent

set list
set listchars=eol:$,tab:>\ ,nbsp:#,trail:_,extends:>,precedes:<


"##### Display Options #####

set number     " line numbers
syntax on      " syntax highlighting

set showcmd    " show incomplete commands

set nowrap     " don't wrap lines
set linebreak  " if I do turn on wrap, work breaks

set wildmenu   " better tab-completion

" to check line lengths
set colorcolumn=100

" colorscheme
set background=dark
silent! set termguicolors

" I don't like how subdued some tablines are
function! FixTabLine()
	highlight TabLine guifg=Black guibg=LightGrey gui=italic,underline ctermfg=Black ctermbg=LightGrey cterm=italic,underline
	highlight TabLineFill guifg=Black guibg=DarkGrey ctermfg=Black ctermbg=LightGrey
	highlight TabLineSel guifg=LightGrey guibg=Black gui=bold ctermfg=LightGrey ctermbg=Black cterm=bold
endfunction

"otherwise the changes made above would be clobbered every time I switch colorschemes
augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call FixTabLine()
augroup END


if !has("gui_running")
	" 256 colors in terminal
	set t_Co=265
	silent! set term=xterm-256color
endif


" ##### Navigation options #####

" split navigations
set splitright
set splitbelow

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" tab is easier to type than %
nnoremap <tab> %
vnoremap <tab> %

" j and k by lines on screen, as with modern editors
nnoremap j gj
nnoremap k gk

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
set incsearch  " go to results as you type
set ignorecase " ignore case in search . . .
set smartcase  " unless I type a capital letter

" automatically make searches "more magic" aka sane
nnoremap / /\v
vnoremap / /\v


" ##### Editing Options #####

" virtual edit in visual mode
set virtualedit=block

" no swap file
set noswapfile

" formatting options, mostly dealing with comment characters
set formatoptions-=c
set formatoptions-=o
set formatoptions-=r
set formatoptions+=j
set formatoptions+=1

" automagically load changes from disk
set autoread


" ##### Function Definitions #####

" remove trailing whitespace on <leader>w, thanks Scolby
fun! TrimWhitespace()
	let l:save = winsaveview()
	%s/\s\+$//e
	call winrestview(l:save)
endfun
nnoremap <Leader>w :call TrimWhitespace()<CR>


" insert "ok" at the end of the line
function! InsertOkAtLineEnd()
	call setline('.', getline('.') . "ok")
	normal! $
endfunction

command -range OK <line1>,<line2>call InsertOkAtLineEnd()
nnoremap <Leader>o :OK<CR>
vnoremap <Leader>o :OK<CR>


" ##### Key Mappings #####

" cd to :head of :path
nnoremap <Leader>cd :cd %:p:h<CR>

" go to next misspelled word and suggest
nnoremap <Leader>s ]sz=


" using mouse
set mouse=a


" ##### Misc Options #####

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

" no modelines: potential security issue
set modelines=0

if &diff
	" Makes diff easier to read
	" https://vi.stackexchange.com/a/626
	highlight! link DiffText MatchParen

	" easier to quit both at once in diff mode
	command Q qall
endif


"##### Filetype Options #####
source ~/deoxys314_dotfiles/files.vim


"##### GUI Options #####
if has('gui_running')

	" ###FONT###
	set guifont=Source\ Code\ Pro\ Light:h13

	" ### GUIOPTIONS
	set guioptions-=e " text tabs
	set guioptions-=T " no toolbar icons
	set guioptions-=l " no left scrollbar
	set guioptions-=L " no left scrollbar when vertical split active
	set guioptions-=r " no right scrollbar
	set guioptions-=R " no right scrollbar when vertical split active

endif
