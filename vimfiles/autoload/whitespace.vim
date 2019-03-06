" remove trailing whitespace on <leader>w, thanks Scolby
function! whitespace#TrimWhitespace() abort
	let l:save = winsaveview()
	%s/\s\+$//e
	call winrestview(l:save)
endfunction
