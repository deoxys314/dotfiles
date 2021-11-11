function! prose#initialize() abort
	" There's no cleanup because everything is buffer-local
	setlocal filetype=markdown nonumber wrap spell textwidth=0

	" small macro that helps with sorting lists and compacting them
	let @l='vip:sort i

	" headings
	let @h='yypVr-'
	let @j='yypVr='
endfunction