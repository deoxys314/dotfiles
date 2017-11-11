# Here are functions which are useful for all instances of fish

# Prompt hostname
set -g __fish_prompt_hostname (hostname | sed -e 's/\.local//')

# The command-line prompt
# sections are as follows:
# hostname > exit code (if not 0) > tmux pane(if any) > truncated directory
function fish_prompt
	# we need to do this first or we will clobber it
	set -l lastexit $status

	# calculates fish hostname once
	if not set -q __fish_prompt_hostname
		set -g __fish_prompt_hostname (hostname | cut -d . -f 1)
	end

	# user@hostname, to make ssh sessions more clear
	set -l __prompt_host (set_color yellow)"$USER@$__fish_prompt_hostname"(set_color normal)

	# exit status, if not 0
	if not test $lastexit -eq 0
		set __prompt_status (set_color red)$lastexit(set_color normal)
	else
		# If this is not erased, the last error will be "sticky"
		set --erase __prompt_status
	end

	# CHeck if we are in a tmux prompt, display position if so
	if test -n "$TMUX"
		set -l n_tmux (tmux display-message -p '#{session_windows}')
		set -g __prompt_tmux (set_color blue)(tmux display-message -p '#I')/$n_tmux(set_color normal)
	else
		set --erase __prompt_tmux
	end


	# working directory
	set -l __prompt_pwd (set_color green)(prompt_pwd)(set_color normal)

	# this sets an array with no "extra" elements because unset variables expand to nothing
	set -l __prompt_array $__prompt_host $__prompt_status $__prompt_tmux $__prompt_pwd


	for section in $__prompt_array
		echo -n $section
		echo -n " > "
	end


end

# settings for __fish_git_prompt
set -x __fish_git_prompt_showdirtystate 1
set -x __fish_git_prompt_showstashstate 1
set -x __fish_git_prompt_showuntrackedfiles 1
set -x __fish_git_prompt_showcolorhints 1

function fish_right_prompt -d "git branch, if applicable"
	__fish_git_prompt
end

function tm -d "Easier tmux usage."
	if test (count $argv) -eq 0
		tmux attach; or tmux new
	else
		tmux $argv
	end
end

function gi -d "Uses gitignore.io to create .gitignore files"
	curl -L -s https://www.gitignore.io/api/$argv
end

