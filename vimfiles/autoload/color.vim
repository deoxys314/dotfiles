function! color#GetColorSchemes()
	return uniq(sort(map(
   \  globpath(&runtimepath, "colors/*.vim", 0, 1),  
   \  'fnamemodify(v:val, ":t:r")'
   \)))
endfunction

function! color#RandomColorScheme()
	let l:schemes = color#GetColorSchemes()
	let l:nums = len(l:schemes)
	let l:scheme = l:schemes[RandomNumber(0, l:nums)]
	execute 'colorscheme ' . l:scheme
endfunction

function! color#NextColorScheme()
	let l:schemes = color#GetColorSchemes()
	let l:index = index(l:schemes, g:colors_name)
	if l:index != -1
		execute 'colorscheme ' . extend(l:schemes, l:schemes)[l:index + 1]
	else
		echoerr '`g:colors_name` does not seem to be set properly.'
	endif
endfunction

function! color#PreviousColorScheme()
	let l:schemes = color#GetColorSchemes()
	let l:index = index(l:schemes, g:colors_name)
	let l:length = len(l:schemes)
	if l:index != -1
		execute 'colorscheme ' . extend(l:schemes, l:schemes)[l:length + l:index - 1]
	else
		echoerr '`g:colors_name` does not seem to be set properly.'
	endif
endfunction
