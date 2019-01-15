" Cameron Rossington .gvimrc
"
" #### Font Options
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


" #### GUIOPTIONS
set guioptions-=e " text tabs
set guioptions-=T " no toolbar icons
set guioptions-=l " no left scrollbar
set guioptions-=L " no left scrollbar when vertical split active
set guioptions-=r " no right scrollbar
set guioptions-=R " no right scrollbar when vertical split active
set guioptions+=c " console dialogue for simple choices

let g:gui_first_load_complete = 1
