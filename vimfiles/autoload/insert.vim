function! insert#InsertAtLineEnd(text) abort
	call setline('.', getline('.') . a:text)
	call cursor(getcurpos()[1], 999)
endfunction
