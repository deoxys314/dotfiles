function! prose#initialize() abort
	setlocal filetype=markdown nonumber wrap spell textwidth=0
	" This could be done in the setlocal command, but I'm making it clear for
	" my future self which settings are global (see 'global-local')
	set laststatus=0
	" There's no cleanup because I know how to change 'laststatus' and
	" everything else is buffer-local
endfunction
