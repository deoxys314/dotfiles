function list-sessions
	tmux ls ^ /dev/null | cut -d ':' -f 1
end
