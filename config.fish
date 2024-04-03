# Here is the configuration for the fish shell

set --local SCRIPTDIR (dirname (status --current-filename))

mkdir -pv ~/bin

# only add ~/bin if it's not already in the PATH (reduces duplicate PATH entries)
if not contains ~/bin $PATH
	set PATH $PATH ~/bin
end

if not contains "$SCRIPTDIR/fish" $fish_function_path
	set fish_function_path $fish_function_path "$SCRIPTDIR/fish"
end


## GLOBALS

set -gx VISUAL vi
set -gx EDITOR vi


## FUNCTIONS

# The command prompt sections are as follows:
# hostname > exit code (if not 0) > tmux pane (if any) > truncated directory
function fish_prompt
	# we need to do this first or we will clobber it with other exit codes
	set -l lastexit $status

	# calculates fish hostname once as it will not change
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

	# Check if we are in a tmux prompt, display position if so
	if test -n "$TMUX"
		set -g __prompt_tmux (set_color blue)(tmux display-message -p '#I/#{session_windows}')(set_color normal)
	else
		set --erase __prompt_tmux
	end


	# time of last prompt
	set -l __prompt_time (set_color white)(date '+%m/%d %H:%M')(set_color normal)

	# working directory
	set -l __prompt_pwd (set_color green)(prompt_pwd)(set_color normal)

	# this sets an array with no "extra" elements because unset variables expand to nothing
	set -l __prompt_array $__prompt_host $__prompt_status $__prompt_tmux $__prompt_time $__prompt_pwd


	# if this isn't set by a per-system customization
	if not set -q __fish_prompt_joiner
		set -g __fish_prompt_joiner " > "
	end

	# for section in $__prompt_array
	# 	echo -n $section
	# 	echo -n $__fish_prompt_joiner
	# end

	# we used to do a for loop, but a brace expansion works as well
	# the -s argument suppresses extra spaces between arguments
	echo -n -s $__prompt_array{$__fish_prompt_joiner}

end

# settings for __fish_git_prompt
set --export __fish_git_prompt_show_informative_status 1
set --export __fish_git_prompt_describe_style branch
set --export __fish_git_prompt_showcolorhints 1
set --export __fish_git_prompt_showdirtystate 1
set --export __fish_git_prompt_showstashstate 1
set --export __fish_git_prompt_showuntrackedfiles 1
set --export __fish_git_prompt_showupstream informative
set --export __fish_git_prompt_char_stateseparator ' '
set --export __fish_git_prompt_char_cleanstate 'ok'
set --export __fish_git_prompt_color_cleanstate 'cyan'
set --export __fish_git_prompt_color_cleanstate_done 'normal'
set --export __fish_git_prompt_char_dirtystate '*'
set --export __fish_git_prompt_char_invalidstate '#'
set --export __fish_git_prompt_char_stagedstate '+'
set --export __fish_git_prompt_char_stashstate '$'
set --export __fish_git_prompt_char_untrackedfiles '%'
set --export __fish_git_prompt_char_upstream_ahead '>'
set --export __fish_git_prompt_char_upstream_behind '<'
set --export __fish_git_prompt_char_upstream_diverged '<>'
set --export __fish_git_prompt_char_upstream_equal '='

function fish_right_prompt --description="Shows the git status, if applicable."
	__fish_git_prompt
end
