function year_progress --description "Prints a bar of progress through the current year." --argument-names width
	# maybe someday I'll do leap years properly
	set --local total_days 365
	if test -z "$width"; or test "$width" -lt 4
		set width 52 # default because a year has 52 weeks
	end

	set --local before (math --scale 0 "$width * $(date +%j) / $total_days")
	set --local after  (math --scale 0 "$width - $before")
	# echo "DEBUG: before [$before] after [$after] sum [$(math $before + $after)] width [$width]"
	echo "|$(string repeat --no-newline --count (math "max($before - 1, 0)") '=')>$(string repeat --no-newline --count $after ' ')|"
end
