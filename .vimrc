" Cameron Rossington .vimrc
" created 170420

"###MISC###
set backspace=2                      "make backspace work like most other apps

"###CODING###
filetype plugin on
syntax on                            "syntax hilighting

set number                           "line numbers on side

"###STATUSLINE###
set laststatus=2                     "required to make statusline always visible

set statusline=
set statusline +=%r%m                "readonly and modified flag, repsectively
set statusline +=[col:%3c\ lin:%3l]  "column and line number
set statusline +=[%f]                "file name, relative path to cwd
set statusline +=[%B]                "value under cursor in hex (in case of unicode)
