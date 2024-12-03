function fish_greeting
	neofish

	quote_of_the_day (git -C (status dirname) rev-parse --show-toplevel)'/qotd.txt' true
	
	year_progress (math "0$COLUMNS" - 6)
end
