# Here is the configuration for the fish shell

set --local SCRIPTDIR (dirname (status --current-filename))

mkdir -pv ~/bin

fish_add_path --global --path --move --append "$HOME/.local/bin"
fish_add_path --global --path --move --append "$HOME/bin"
fish_add_path --global --path "$HOME/.cargo/bin"

if not contains "$SCRIPTDIR/fish" $fish_function_path
	set fish_function_path $fish_function_path "$SCRIPTDIR/fish"
end


## GLOBALS

set --global --export VISUAL vi
set --global --export EDITOR vi


## FUNCTIONS

set --local powerline_right ''
set --local powerline_left  ''
set --local powerline_right_inverse ''
set --local powerline_left_inverse ''
set --global --export __fish_prompt_joiner "$powerline_right"
# set --global --export __fish_prompt_joiner '▓▒░'
if set --query __fish_prompt_no_powerline
	set --global --export __fish_prompt_joiner "▌"
end

function fish_prompt
	# we need to do this first or we will clobber it with other exit codes
	set --function lastexit $status

	set --function sections
	set --function background_colors
	set --function foreground_colors

	# calculates fish hostname once as it will not change
	if not set --query __fish_prompt_hostname
		set --global --export __fish_prompt_hostname (hostname | cut -d . -f 1)
	end

	# user@hostname, to make ssh sessions more clear
	set sections $sections " $USER@$__fish_prompt_hostname"
	set background_colors $background_colors magenta
	set foreground_colors $foreground_colors black

	# Check if we are in a tmux prompt, display position if so
	if test -n "$TMUX"
		set sections $sections (tmux display-message -p '#I/#{session_windows}')
		set foreground_colors $foreground_colors black
		set background_colors $background_colors blue
	end

	# time of last prompt
	set sections $sections (date '+%m/%d %H:%M')
	set foreground_colors $foreground_colors black
	set background_colors $background_colors white

	# working directory
	set sections $sections (prompt_pwd)
	set foreground_colors $foreground_colors black
	set background_colors $background_colors green

	# exit status, if not 0
	if not test $lastexit -eq 0
		set sections $sections "$lastexit"
		set background_colors $background_colors red
		set foreground_colors $foreground_colors black
	end

	set background_colors $background_colors normal # one extra so we don't have any access issues
	for i in (seq (count $sections))
		echo -n -s \
			(set_color $foreground_colors[$i] --background $background_colors[$i])\
			$sections[$i]" "\
			(set_color $background_colors[$i] --background $background_colors[(math $i + 1)])\
			"$__fish_prompt_joiner "
	end
	echo -s -n (set_color normal)
	if set --query __fish_prompt_no_powerline
		echo -s -n (set_color $background_colors[-2])'$ '(set_color normal)
	end

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

# I seem to use these a lot, so this is a handy ref
function unicode_block_elements_table
	set --function idx 0
	for char_id in (seq (math 0x2580) (math 0x259F))
		set idx (math "$idx" + 1)
		echo -s -n \
			(math --base hex $char_id) \
			': ' \
			(set_color blue) \
			(printf (printf '\\\\u%x' "$char_id")) \
			(set_color normal)

		if test (math "$idx" '%' 4) -eq 0
			echo
		else
			echo -n -s ' | '
		end
	end
end
