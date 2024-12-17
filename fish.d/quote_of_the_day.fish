function quote_of_the_day \
	--description 'Print out a random quote of the day from a provided file. File is expected to be one quote per line with a tab between the quote and the source (if any).'

	argparse -x i,s \
		(fish_opt --short p --long print-header) \
		(fish_opt --short c --long count --long-only) \
		(fish_opt --short w --long width --required-val) \
		(fish_opt --short i --long index --required-val)'!_validate_int --min 1' \
		(fish_opt --short s --long seed --required-val)'!_validate_int --min 1'  \
		-- $argv
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

	set --function quotes (cat "$argv[1]")
	set --function n_quotes (count $quotes)
	if set -ql _flag_count; printf '%d' $n_quotes; return; end

	set --function quote_idx (math (date '+%V') '*' (date '+%j') '%' "$n_quotes + 1")
	if set -ql _flag_seed
		set quote_idx (math "$quote_idx + $_flag_seed % $n_quotes")
	else if set -ql _flag_index
		set quote_idx $_flag_index
	end

	printf '%s\n' $quotes[$quote_idx] | sed 's/\t/\n\t- /' | fold -w "$width" -s
end
