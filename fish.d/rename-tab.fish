function rename-tab --description="Renames current Tmux tab"
	# if we are not in tmux, exit
	if test -z "$TMUX"
		echo "Tmux is not running." 1>&2
		return 1
	end

	# if nothing was passed, exit
	if test (count $argv) -eq 0
		echo "No arguments passed."
		return 2
	end

	tmux rename-window "$argv"
end
