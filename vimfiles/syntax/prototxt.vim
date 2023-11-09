if exists("b:current_syntax")
	finish
endif

syntax match prototxtIdentifier "\v\w+\s*(:|\{)@="
syntax region prototxtIdBrackets start='\[' end=']' fold contains=prototxtIdentifier
highlight link prototxtIdBrackets Special
syntax match prototxtIdentifier contained '[a-z_]\+\(\.[a-z_]\+\)\+'
highlight link prototxtIdentifier Identifier

syntax match prototxtComment "\v#.*$"
highlight link prototxtComment Comment

syntax region prototxtString start=/\v"/ skip=/\v\\./ end=/\v"/
highlight link prototxtString String

syntax match prototxtInteger '[-+]\?\d\+'
highlight link prototxtInteger Number

syntax match prototxtFloat '[-+]\?\d\.\d*'
highlight link prototxtFloat Float

syntax keyword prototxtBool true false
highlight link prototxtBool Boolean

syntax match prototxtEnumValue '[A-Za-z_]\+$'
highlight link prototxtEnumValue Function

let b:current_syntax = "prototxt"
