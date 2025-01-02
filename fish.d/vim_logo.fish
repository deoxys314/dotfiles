function vim_logo
	set -f green 439741
	set -f grey CCC
	set -f g  (set_color $green)
	set -f gr (set_color $grey)
	echo "       $gr ________ $g++    $gr ________
       $gr/VVVVVVVV\\$g++++  $gr/VVVVVVVV\\
       $gr\\VVVVVVVV/$g++++++$gr\\VVVVVVVV/
        $gr|VVVVVV|$g++++++++$gr/VVVVV/'
        $gr|VVVVVV|$g++++++$gr/VVVVV/'
       $g+$gr|VVVVVV|$g++++$gr/VVVVV/'$g+
     $g+++$gr|VVVVVV|$g++$gr/VVVVV/'$g+++++
   $g+++++$gr|VVVVVV|/VVVVV/$g'+++++++++
     $g+++$gr|VVVVVVVVVVV/'$g+++++++++
       $g+$gr|VVVVVVVVV/'$g+++++++++
        $gr|VVVVVVV/'$g+++++++++
        $gr|VVVVV/'$g+++++++++
        $gr|VVV/'$g+++++++++
        $gr'V/'   $g++++++
                 $g++
$(set_color normal)"
end
