function quote_of_the_day \
	--description 'Print out a random quote of the day from a provided file. File is expected to be one quote per line with a tab between the quote and the source (if any).' \
	--argument-names quote_file print_header

	if not test -e "$quote_file"
		printf 'ERROR: Cannot find file %s\n' "$quote_file" >&2
		return
	end

	if test -n "$print_header"
		echo (set_color yellow --underline)'Quote of the Day'(set_color normal)
	end

	set --local quotes (cat "$quote_file")
	set --local n_quotes (count < "$quote_file")
	set --local quote_idx (math (date '+%j') '%' "$n_quotes")
	printf '%s\n' $quotes[$quote_idx] | sed 's/\t/\n\t- /' | fold -w 80 -s
end
