" Cameron Rossington File definition vimscript
" created 170605

" ##### Python #####
au BufNewFile,BufRead *.py,*.pyw  "PEP8 style settings
  \ set tabstop=4       |
  \ set softtabstop=4   |
  \ set shiftwidth=4    |
  \ set expandtab       |
  \ set autoindent      |
  \ set fileformat=unix |
  \ setlocal colorcolumn=100
" Note: I do not limit to 80 because there is more
" to life than PEP8


" ##### Web Files #####
au BufNewFile,BufRead *.js,*.css,*.htm,*.html,*.php
  \ set tabstop=2     |
  \ set softtabstop=2 |
  \ set shiftwidth=2  |
  \ set noexpandtab   |
  \ set autoindent    |
  \ set fileformat=unix

" ##### C files #####
au BufNewFile,BufRead *.c,*.h
  \ set tabstop=4     |
  \ set softtabstop=4 |
  \ set shiftwidth=4  |
  \ set noexpandtab   |
  \ set filetype=c    |
  \ set colorcolumn=100


" ##### journal files #####
au BufNewFile,BufRead *.jo
  \ set wrap |
  \ set cc=0 |
  \ set nonumber

