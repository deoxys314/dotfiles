function! insert#InsertAtLineEnd(text) abort
	call setline('.', getline('.') . a:text)
	call cursor(line('.'), col('$'))
endfunction
