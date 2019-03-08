function! search#toggle_hls(on_enter) abort
	if a:on_enter
		let s:hls_on = &hlsearch
		set hlsearch
	else
		if exists('s:hls_on')
			execute 'set ' . (s:hls_on ? '' : 'no') . 'hlsearch'
			unlet! s:hls_on
		endif
	endif
endfunction
