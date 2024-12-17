function fish_greeting

	set --function qotd_length (math "min( ($COLUMNS / 3), 48 )")
	set --function qotd_file (git -C (status dirname) rev-parse --show-toplevel)'/qotd.txt'

	set --function qotd_lines (quote_of_the_day $qotd_file --width $qotd_length --print-header)
	# add just a touch more visual space
	set --prepend qotd_lines ''

	set --function ascii_art (fish_logo)

	set --local num_of_lines (math max (count $ascii_art ), (count $qotd_lines) )

	set --local left_width 0
	for i in (seq 1 (count $ascii_art))
		set left_width (math "max($left_width , $(string length --visible $ascii_art[$i]) )" )
	end

	for i in (seq 1 $num_of_lines)
		printf '%s %s   %s\n' (string pad --right --width $left_width $ascii_art[$i]) (set_color normal) $qotd_lines[$i]
	end

	set --function yp_msg "$(set_color yellow --underline)Year Progress$(set_color normal): "
	printf '%s%s\n' "$yp_msg" (year_progress (math "$qotd_length + $left_width -  $(string length --visible $yp_msg)"))
end
