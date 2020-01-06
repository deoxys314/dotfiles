" remove trailing whitespace on <leader>w, thanks Scolby
function! whitespace#TrimWhitespace() abort
	if !&binary && &filetype !=# 'diff'
		let l:save = winsaveview()
		%s/\s\+$//e
		call winrestview(l:save)
	endif
endfunction
