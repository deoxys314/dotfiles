function fish_greeting
	neofish

	quote_of_the_day (git -C (status dirname) rev-parse --show-toplevel)'/qotd.txt' true
end
