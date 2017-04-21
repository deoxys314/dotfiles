" Cameron Rossington .vimrc
" created 170420

"###MISC###
set backspace=2                      "make backspace work like most other apps

"###CODING###
filetype plugin on
syntax on                            "syntax highlighting

set number                           "line numbers on side

set tabstop=4                        "tabs = 4 spaces when using '>'
set shiftwidth=4                     "tabs = 4 spaces when typing
set expandtab                        "replace tabs with spaces as you type

"###WHITESPACE###

set listchars=eol:¬,tab:»\ ,extends:>,precedes:<,space:·,nbsp:#,trail:_

"###STATUSLINE###

set laststatus=2                     "required to make statusline always visible

set statusline=

set statusline +=[col:%3c\ lin:%3l]  "column and line number
set statusline +=[%f]                "file name, relative path to cwd
set statusline +=[%B]                "value under cursor in hex (in case of unicode)
