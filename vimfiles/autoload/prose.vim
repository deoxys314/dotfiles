function! prose#initialize() abort
	" This could be done in the setlocal command, but I'm making it clear for
	" my future self which settings are global (see 'global-local')
	setlocal filetype=markdown nonumber wrap spell textwidth=0
	" There's no cleanup because I know how to change 'laststatus' and
	" everything else is buffer-local
	set laststatus=0
	" small macro that helps with sorting lists and compacting them
	let @l='vip:sort igv:normal! A,gvAgvJAkb'
endfunction
