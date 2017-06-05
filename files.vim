" Cameron Rossington File definition vimscript
" created 170605

" ##### Python ##### 
au BufNewFile,BufRead *.py,*.pyw     "PEP8 style settings
  \ set tabstop=4
  \ set softtabstop=4
  \ set shiftwidth=4
"  \ set textwidth=79                "This part of PEP8 I don't agree with
  \ set expandtab
  \ set autoindent
  \ set fileformat=unix


" PEP8
"augroup vimrc_autocmds
"  autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
"  autocmd BufEnter * match OverLength /\%100v.*/
"augroup END

" ##### Web Files #####
au BufNewFile,BufRead *.js,*.css,*.htm,*.html,*.php
  \ set tabstop=2
  \ set softtabstop=2
  \ set shiftwidth=2
  \ set noexpandtab
  \ set autoindent
  \ set fileformat=unix

" ##### journal files #####
au BufNewFile,BufRead *.jo set wrap

