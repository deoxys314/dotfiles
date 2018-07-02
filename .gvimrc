" Cameron Rossington .gvimrc
"
" #### Font Options ###
set guifont=Consolas:h13:cANSI:qDEFAULT

" #### Window Options
if !exists('g:gui_first_load_complete')
	set lines=40 columns=120
endif
let g:goyo_width=100 " so Goyo has room, by default


" #### Whitespace Options ###
set listchars=eol:¬,tab:»\ ,extends:>,precedes:<,nbsp:#,trail:_


" #### Color Options
set background=dark
colorscheme base16-solarflare

let g:gui_first_load_complete = 1
