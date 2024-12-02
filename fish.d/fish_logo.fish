function fish_logo \
    --description="Fish-shell colorful ASCII-art logo" \
    --argument-names outer_color medium_color inner_color mouth eye

	# Taken and modified from https://github.com/laughedelic/fish_logo on
	# 2024-11-23

    # defaults:
    [ $outer_color  ]; or set outer_color  'red'
    [ $medium_color ]; or set medium_color 'f70'
    [ $inner_color  ]; or set inner_color  'yellow'
    [ $mouth ]; or set mouth '['
    [ $eye   ]; or set eye   'O'

    set usage 'Usage: fish_logo <outer_color> <medium_color> <inner_color> <mouth> <eye>
See set_color --help for more on available colors.'

    if contains -- $outer_color '--help' '-h' '-help'
        echo $usage
        return 0
    end

    # shortcuts:
    set o (set_color $outer_color)
    set m (set_color $medium_color)
    set i (set_color $inner_color)

    if test (count $o) != 1; or test (count $m) != 1; or test (count $i) != 1
        echo 'Invalid color argument'
        echo $usage
        return 1
    end

    echo '                 '$o'___
'$o'  ___======____='$m'-'$i'-'$m'-='$o')
'$o'/T            \_'$i'--='$m'=='$o')
'$o$mouth' \ '$m'('$i$eye$m')   '$o'\~    \_'$i'-='$m'='$o')
'$o' \      / )J'$m'~~    '$o'\\'$i'-='$o')
'$o'  \\\\___/  )JJ'$m'~'$i'~~   '$o'\)
'$o'   \_____/JJJ'$m'~~'$i'~~    '$o'\\
'$o'   '$m'/ '$o'\  '$i', \\'$o'J'$m'~~~'$i'~~     '$m'\\
'$m'  (-'$i'\)'$o'\='$m'|'$i'\\\\\\'$m'~~'$i'~~       '$m'L_'$i'_
'$i'  '$m'('$o'\\'$m'\\)  ('$i'\\'$m'\\\)'$o'_           '$i'\=='$m'__
   '$o'\V    '$m'\\\\'$o'\) =='$m'=_____   '$i'\\\\\\\\'$m'\\\\
          '$o'\V)     \_) '$m'\\\\'$i'\\\\JJ\\'$m'J\)
                      '$o'/'$m'J'$i'\\'$m'J'$o'T\\'$m'JJJ'$o'J)
'$o'                      (J'$m'JJ'$o'| \UUU)
'$o'                       (UU)'(set_color normal)
end
