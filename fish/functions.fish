# Here are functions which are useful for all instances of fish

# Prompt hostname
set -g __fish_prompt_hostname (hostname | sed -e 's/\.local//')

function parse_git_branch
	set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
	set -l git_diff (git diff)
	if test -n "$git_diff"
		echo -n "$branch"
	else
		echo -n "$branch"
	end
end


# The command-line prompt
# sections are as follows:
# hostname > exit code (if not 0) > truncated directory > git branch (if any)
function fish_prompt
	# we need to do this first or we will clobber it
	set -l lastexit $status

	# calculates fish hostname once
	if not set -q __fish_prompt_hostname
		set -g __fish_prompt_hostname (hostname | cut -d . -f 1)
	end

	# echos user@hostname
	echo -n (set_color yellow)"$USER@$__fish_prompt_hostname"(set_color normal)
	echo -n ' > '

	# prints exit status, if not 0
	if not test $lastexit -eq 0
		echo -n (set_color red)$lastexit(set_color normal)
		echo -n ' > '
	end

	# prints working directory
	echo -n (set_color green)(prompt_pwd)(set_color normal)
	echo -n ' > '
end

# settings for __fish_git_prompt
set -x __fish_git_prompt_showdirtystate 1
set -x __fish_git_prompt_showstashstate 1
set -x __fish_git_prompt_showuntrackedfiles 1
set -x __fish_git_prompt_showcolorhints 1

function fish_right_prompt -d "git branch, if applicable"
	__fish_git_prompt
end
