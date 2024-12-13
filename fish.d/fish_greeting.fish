function fish_greeting
	# neofish

	set --function qotd_lines (quote_of_the_day (git -C (status dirname) rev-parse --show-toplevel)'/qotd.txt' | string split "\n")
	set --function ascii_art (fish_logo | string split "\n")

	set --local num_of_lines (math max (count $ascii_art ), (count $qotd_lines) )

	set --local left_width 0
	for i in (seq 1 (count $ascii_art))
		set left_width (math 'max(' $left_width ',' (string length --visible $ascii_art[$i]) ')' )
	end

	for i in (seq 1 $num_of_lines)
		printf '%s %s   %s\n' (string pad --right --width $left_width $ascii_art[$i]) (set_color normal) $qotd_lines[$i]
	end
	# year_progress (math "0$COLUMNS" - 6)
end
