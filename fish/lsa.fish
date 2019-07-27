function lsa --description "Lists files, but better!"
	if command --search -q exa
		exa --git --long --all --header $argv
	else
		# ls (a)ll (B) print unprintables (h) sizes in megabyte, et al
		#    (s) file block size (l) long format
		ls -aBhsl $argv
	end
end
