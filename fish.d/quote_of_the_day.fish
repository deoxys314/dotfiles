function quote_of_the_day \
	--description 'Print out a random quote of the day from a provided file. File is expected to be one quote per line with a tab between the quote and the source (if any).'


	argparse (fish_opt --short p --long print-header) (fish_opt --short w --long width --required-val) -- $argv
	or return

	if not test -e "$argv[1]"
		printf 'ERROR: Cannot find file %s\n' "$quote_file" >&2
		return
	end

	if set -ql _flag_print_header
		echo (set_color yellow --underline)'Quote of the Day'(set_color normal)
	end

	if set -ql _flag_width
		set --function width $_flag_width
	else
		set --function width 80
	end

	set --local quotes (cat "$argv[1]")
	set --local n_quotes (count < "$argv[1]")
	set --local quote_idx (math (date '+%V') '*' (date '+%j') '%' "$n_quotes")
	printf '%s\n' $quotes[$quote_idx] | sed 's/\t/\n\t- /' | fold -w "$width" -s
end
