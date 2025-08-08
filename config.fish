set --local SCRIPTDIR (dirname (status --current-filename))

# SETUP

mkdir -pv ~/bin

if command --query uname; and string match --ignore-case --quiet 'Darwin' (uname); and not test -e ~/.hushlogin
	# removes an annoying message in new terminals in OSX
	touch ~/.hushlogin
end

fish_add_path --global --path --move --append "$HOME/.local/bin"
fish_add_path --global --path --move --append "$HOME/bin"
fish_add_path --global --path "$HOME/.cargo/bin"

set fish_function_path "$SCRIPTDIR/fish.d" $fish_function_path

if command --query nvim
	set --global --export VISUAL nvim
	set --global --export MANPAGER 'nvim +Man!'
else
	set --global --export VISUAL vi
end
set --global --export EDITOR "$VISUAL"

set --global --export __fish_prompt_fade_left "░▒▓"
set --global --export __fish_prompt_fade_left_inverted "▓░▒"
set --global --export __fish_prompt_fade_right "▓▒░"
set --global --export __fish_prompt_fade_right_inverted "░▒▓"
set --global --export __fish_prompt_powerline_arrow_left ""
set --global --export __fish_prompt_powerline_arrow_left_inverted ""
set --global --export __fish_prompt_powerline_arrow_right ""
set --global --export __fish_prompt_powerline_arrow_right_inverted ""
set --global --export __fish_prompt_powerline_rounded_left ""
set --global --export __fish_prompt_powerline_rounded_left_line ""
set --global --export __fish_prompt_powerline_rounded_right ""
set --global --export __fish_prompt_powerline_rounded_right_line ""
set --global --export __fish_prompt_powerline_triangle_left ""
set --global --export __fish_prompt_powerline_triangle_left_swap ""
set --global --export __fish_prompt_powerline_triangle_right ""
set --global --export __fish_prompt_powerline_triangle_right_swap ""
set --global --export __fish_prompt_joiner "$__fish_prompt_powerline_triangle_right"

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
	if test $COLUMNS -ge 100
		set sections $sections "$USER@$__fish_prompt_hostname"
		set background_colors $background_colors "brmagenta"
		set foreground_colors $foreground_colors black
	end

	# Check if we are in a tmux prompt, display position if so
	if test -n "$TMUX"
		set sections $sections (tmux display-message -p '#I/#{session_windows}')
		set foreground_colors $foreground_colors black
		set background_colors $background_colors blue
	end

	# time of last prompt
	if test $COLUMNS -ge 80
		set sections $sections (date '+%m/%d %H:%M')
		set foreground_colors $foreground_colors black
		set background_colors $background_colors white
	end

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

	if fish_is_root_user
		set sections $sections '#'
		set background_colors $background_colors yellow
		set foreground_colors $foreground_colors black
	end

	set background_colors $background_colors normal # one extra so we don't have any access issues
	for i in (seq (count $sections))
		echo -n -s \
			(set_color $foreground_colors[$i] --background $background_colors[$i]) \
			$sections[$i] \
			(set_color $background_colors[$i] --background $background_colors[(math $i + 1)]) \
			"$__fish_prompt_joiner"
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
	fish_git_prompt
end

# suggestions display
set --global --export fish_pager_color_completion normal
set --global --export fish_pager_color_description green
set --global --export fish_pager_color_prefix normal --underline
set --global --export fish_pager_color_progress green
set --global --export fish_pager_color_selected_background -r

# brew settings
if command --query brew
	set --global --export HOMEBREW_AUTO_UPDATE_SECS (math "60 * 60 * 24 * 7")
	set --global --export HOMEBREW_NO_ANALYTICS
	if command --query bat
		set --global --export HOMEBREW_BAT 1
	end
end

if not command --query g
	alias g=git
end

# npm settings
set --local npmrc_file "$HOME/.config/npmrc"
if test -e "$npmrc_file"
	set --local npmrc (cat "$npmrc_file")
	if not string match --max-matches 1 --quiet --entire 'send-metrics="' "$npmrc"
		echo 'send-metrics=false' >> "$npmrc"
	end
	if not string match --max-matches 1 --quiet --entire 'fund="' "$npmrc"
		echo 'fund=false' >> "$npmrc"
	end
	if not string match --max-matches 1 --quiet --entire 'cache="' "$npmrc"
		echo 'cache=~/.cache/npm' >> "$npmrc"
	end
end
