function is-haiku --argument-names first second third
	if test (count-syllables-line "$first") = 5
		and test (count-syllables-line "$second") = 7
		and test (count-syllables-line "$third") = 5
		return 0
	end
	return 1
end
