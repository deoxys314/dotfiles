function fish_greeting
	neofish

	quote_of_the_day --print-header (git -C (status dirname) rev-parse --show-toplevel)'/qotd.txt'
	
	year_progress (math "0$COLUMNS" - 6)
end
