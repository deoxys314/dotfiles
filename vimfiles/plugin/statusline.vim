scriptencoding utf-8

" Constants
let s:true = 1
let s:false = 0
let s:filled = '█'
let s:empty = '░'

" Private functions
function! s:set_colors() abort
	highlight! link User1 Directory
	highlight! link User2 ErrorMsg
endfunction

function! s:set_status_line(active) abort
	if &buftype ==# 'nofile' || &filetype ==# 'netrw'
		" Likely a file explorer.
		setlocal statusline=%!NoFileStatusLine()
	elseif &buftype ==# 'nowrite'
		" Don't set a custom status line for certain special windows.
		return
	elseif a:active
		setlocal statusline=%!ActiveStatusLine()
	else
		setlocal statusline=%!InactiveStatusLine()
	endif
endfunction

function! s:update_inactive_windows() abort
	for l:winnum in range(1, winnr('$'))
		if l:winnum != winnr()
			call setwinvar(l:winnum, '&statusline', '%!InactiveStatusLine()')
		endif
	endfor
endfunction

" Public Functions

function! StatuslineScrollbar(width) abort
	" The various calls to round() are to make Numbers into Floats, otherwise
	" Vim just drops the remainder because a Number/Number -> Number.
	let l:pos = line('.') / round(line('$'))

	let l:scrollbar = map(range(a:width), '"' . s:empty . '"')
	for l:n in range(a:width)
		if (((l:n + 1) / round(a:width)) > l:pos)
			break
		endif
	endfor
	let l:scrollbar[l:n] = s:filled

	return join(l:scrollbar, '')
endfunction

function! ShortFilePath() abort
	if &buftype ==# 'terminal'
		return expand('%:t')
	else
		return pathshorten(fnamemodify(expand('%:p'), ':~:.'))
	endif
endfunction

function! ObsessionStatusLine() abort
	if !exists('g:loaded_obsession')
		return ''
	else
		return ObsessionStatus()
	endif
endfunction

function! FugitiveStatusLine() abort
	if !exists('g:loaded_fugitive')
		return ''
	else
		return FugitiveStatusline()
	endif
endfunction

function! ActiveStatusLine() abort
	" Sections:
	" Mode:
	let l:statusline = '%([%-2{mode(1)}]%)'
	" Location/Flags:
	let l:statusline .= '%(%1* %{ShortFilePath()}%h%2*%m%r%1* %)%0*'
	" Split:
	let l:statusline .= '%='
	" File Info:
	let l:statusline .= '%(%y[%{&ff}]%)'
	" Location:
	let l:statusline .= '%([%3p%%]%)%([x:%2c y:%2l z:%{&foldlevel}]%)'
	" Fugitive:
	let l:statusline .= '%(%{FugitiveStatusLine()}%)'
	" Obsession:
	let l:statusline .= '%(%{ObsessionStatusLine()}%)'

	return l:statusline
endfunction

function! InactiveStatusLine() abort
	return '  %(%{ShortFilePath()}%h%m%r%)'
endfunction

function! NoFileStatusLine() abort
	return '  %(%{ShortFilePath()}%)'
endfunction

augroup StatusLine
	autocmd!
	autocmd VimEnter             * call s:update_inactive_windows()
	autocmd WinEnter,BufWinEnter * call s:set_status_line(s:true)
	autocmd WinLeave             * call s:set_status_line(s:false)
	autocmd ColorScheme,VimEnter * call s:set_colors()
augroup END

set laststatus=2
set noshowmode
