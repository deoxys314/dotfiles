function count-syllables-word --argument-names word
	# the assumption here is that we have one word, no spaces.
	# Thus we can use `tr` with reckless abandon.
	set --local word (echo "$word" | tr -cd '[:alpha:]' | tr '[A-Z]' '[a-z]')

	set --local count (string trim (echo "$word" | grep -o -E '[aeiouy]+' | wc -l))

	set --local lastchar (echo "$word" | tail -c 1)
	set --local lasttwoc (echo "$word" | tail -c 2)
	if test "$lastchar" = e; or test "$lasttwoc" = ed; or test "$lasttwoc" = es; and not test "$lasttwoc" = le
		set count (math "$count" - 1)
	end

	echo "$count"
end

