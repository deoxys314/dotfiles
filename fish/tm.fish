function tm --description="Easier tmux usage."
	if test (count $argv) -eq 0
		tmux attach; or tmux new -s "main"
	else
		tmux $argv
	end
end
