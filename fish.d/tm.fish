function tm --description="Easier tmux usage."
	if test (count $argv) -eq 0
		tmux attach; or tmux new -s "main"
	else if test (count $argv) -eq 1; and tmux has-session -t $argv 2> /dev/null
		tmux attach -t $argv
	else
		tmux $argv
	end
end
