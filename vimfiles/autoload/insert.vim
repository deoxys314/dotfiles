function! insert#InsertAtLineEnd(text) abort
	call setline('.', getline('.') . a:text)
endfunction
