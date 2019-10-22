function count-syllables-line
	set --local syllables 0

	for word in $argv
		set syllables (math "$syllables" + (count-syllables-word "$word"))
	end

	echo "$syllables"
end
