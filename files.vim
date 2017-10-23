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
  \ set colorcolumn=110


" ##### journal files #####
au BufNewFile,BufRead *.jo
  \ set wrap |
  \ set cc=0 |
  \ set spell


" ##### test/status files #####
au BufNewFile,BufRead *.txt
  \ set cc=0     |
  \ set autoread |
  \ set wrap
"  \ if @% =~ "status" | cd %:p:h | endif " changes cwd to current file


" ##### logfiles #####
au BufNewFile,BufRead *.log
  \ set cc=0 |
  \ cd %:p:h


" ##### Markdown #####
au BufNewFile,BufRead *.md
  \ set cc=0  |
  \ setlocal spell |
  \ setlocal wrap

" ##### gitcommit #####
au BufNewFile,BufRead COMMIT_EDITMSG
  \ setlocal spell |
  \ colo base16-solarized-light

" ##### special cases #####
au BufNewFile,BufRead !status*
  \ cd %:p:h


