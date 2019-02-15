#!/usr/bin/env sh

universal_location=${UNIVERSAL_RECORD:=${XDG_DATA_HOME:="$HOME/.local/share"}}
universal_location="$universal_location/universal"
mkdir -p "$universal_location"

debug_echo() {
    if [ "$DEBUG" ]; then
        echo "DEBUG INFO: [$*]"
    fi
}

stderr_echo() {
    echo "$@" 1>&2
}

universal_install_help() { # {{{
    width="72"
    if command -v tput > /dev/null 2>&1; then
        if [ "$(tput cols)" -lt "$width" ]; then
            width="$(tput cols)"
        fi
    fi


    help_text=$(cat <<-EOF | tr '\n@' '\0\n'
	@usage: $0@
	@
	This script makes a best-effort attempt to keep your system up to date and
	 record things such that you can recover more easily from a system crash.@
	@
	A few assumptions:@
	@
	- The system is sufficiently unix-y to have sh running on it.  This output
	 is printing, so the script is already running.@
	- You do, in fact, want things recorded somewhere. If the environmental
	 variable \$UNIVERSAL_RECORD is set, files will be written there.
	 Otherwise, \$XDG_DATA_HOME will be used. If this is unset, a default
	 value of \$HOME/.local/share is used. In all cases, a folder
	 \`universal\` will be used to store the data, and created if necessary.
	 It's suggested to set \$UNIVERSAL_RECORD to \`/dev/null\` if you don't
	 want things recorded.@
	- This script does not invoke sudo. The user should only do this as an
	 informed decision. You can do so by executing \`sudo $0\`.@
	EOF
)

    debug_help_text=$( cat <<-'EOF'
	If you can see this sentence, the $DEBUG system variable is not null.
	EOF
    )

    if command -v fold >/dev/null 2>&1; then
        echo "$help_text" | fold -s -w "$width"
        debug_echo "$debug_help_text" | fold -s -w "$width"
    else
        echo "$help_text"
        debug_echo "$debug_help_text"
    fi

} # }}}

# no arguments needed means any argument is a cry for help
if [ $# -ne 0 ]; then
    universal_install_help
    exit
fi

# --- END OF SETUP ---

debug_echo "Updating dotfiles directories."
find "$HOME" -type d -maxdepth 1 -iname "*dotfile*" -exec git -C "{}" pull --ff-only origin master ";"

if command -v brew > /dev/null 2>&1; then # {{{
    debug_echo "Updating brew."
    BREW_RECORD="$universal_location"
    brew update
    brew upgrade
    brew cleanup
    brew list > "$BREW_RECORD"/brew-list.txt
    brew leaves > "$BREW_RECORD"/brew-leaves.txt
    brew cask list > "$BREW_RECORD"/brew-cask-list.txt
fi # }}}

if command -v apt-get > /dev/null 2>&1; then # {{{
    debug_echo "Updating apt-get."
    APT_RECORD="$universal_location"

    # This script probably should be inbvoked as sudo, and it's bad practice to
    # use sudo within a script, so we will not be doing that here

    apt-get update
    apt-get upgrade

    # neither of these are perceft but they should suffice to make recovering
    # a system much more easy.
    apt list --installed > "$APT_RECORD"/apt-list.txt
    apt-mark showmanual > "$APT_RECORD"/apt-manual.txt

fi #}}}

if command -v vim > /dev/null 2>&1; then
	vim_executable="vim"
	# use NeoVim if available
	if command -v nvim > /dev/null 2>&1; then
		vim_executable="nvim"
	fi

	tempfile=$(mktemp)
	debug_echo "Tempfile: ${tempfile}"
	cat <<-VIM > "${tempfile}"
	:try | PlugInstall! | qall | catch | cq
	VIM

	# if a user uses pathogen, we can simply use the same find/execdir trick as
	# above to update the repositories

	# check for vundle, vim-plug and dein
	if $vim_executable -s "${tempfile}"; then
		: # nothing to do here, but I find positive if-satements read better
	else
		# update for pathogen here
		:
	fi

fi

# vim_plugin_update() { # {{{
#     debug_echo "Updating (n)vim plguins."
#     VIM_EXECUTABLE=vim
#     nvim_path=$(command -v nvim)
#     if [ -x "$nvim_path" ]; then
#         VIM_EXECUTABLE=$nvim_path
#     fi

#     debug_echo "Executable path: $VIM_EXECUTABLE"

#     $VIM_EXECUTABLE "+PlugUpdate!" "+qall"
# } # }}}
