function year_progress --description "Prints a bar of progress through the current year." --argument-names width
	# maybe someday I'll do leap years properly
	set --local total_days 365
	if test -z "$width"; or test "$width" -lt 4
		set width 52 # default because a year has 52 weeks
	end

	echo -n '['

	for n in (seq $width)
		if test (math $n / $width) -le (math (date +%j) / $total_days)
			echo -n '#'
		else
			echo -n '-'
		end
	end

	echo ']'
end
