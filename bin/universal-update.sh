#!/usr/bin/env sh

debug_echo() {
    if [ "$DEBUG" ]; then
        echo "DEBUG INFO: [$@]"
    fi
}

stderr_echo() {
    echo "$@" 1>&2
}

vim_plugin_update() { # {{{
    debug_echo "Updating (n)vim plguins."
    VIM_EXECUTABLE=vim
    nvim_path=$(command -v nvim)
    if [ -x "$nvim_path" ]; then
        VIM_EXECUTABLE=$nvim_path
    fi

    debug_echo "Executable path: $VIM_EXECUTABLE"

    $VIM_EXECUTABLE "+PlugUpdate!" "+qall"
} # }}}

brew_update() { # {{{
    debug_echo "Updating brew."
    BREW_RECORD=${BREW_RECORD:="$HOME"}
    debug_echo "Brew record location: $BREW_RECORD"
    if [ -x "$(command -v brew)" ]; then
        brew update
        brew upgrade
        brew cleanup
        brew list > "$BREW_RECORD"/brew-list.txt
        brew leaves > "$BREW_RECORD"/brew-leaves.txt
        brew cask list > "$BREW_RECORD"/brew-cask-list.txt
    else
        stderr_echo "\`brew\` not found. You should probably install it, it's very useful!"
    fi
} # }}}

git_update() { # {{{
    debug_echo "Updating git repo."
    DOTFILES_DIR=${DOTFILES_DIR:="$HOME/dotfiles/"}
    debug_echo "Directory: $DOTFILES_DIR"
    if [ -d "$DOTFILES_DIR" ]; then
        # it is always safe to do a `git fetch`
        git -C "$DOTFILES_DIR" fetch

        if [ -z "$(git -C "$DOTFILES_DIR" status -s)" ]; then
            git -C "$DOTFILES_DIR" pull
        fi
    else
        stderr_echo "Dotfiles not found."
    fi
} # }}}

apt_update() { # {{{
    debug_echo "Updating apt-get"
    APT_RECORD=${APT_RECORD:="$HOME"}
    debug_echo "apt record location: $APT_RECORD"

    # This script probably should be inbvoked as sudo, and it's bad practice to
    # use sudo within a script, so we will not be doing that here

    apt-get update
    apt-get upgrade

    # neither of these are perceft but they should suffice to make recovering
    # a system much more easy.
    apt list --installed > "$APT_RECORD"/apt-list.txt
    apt-mark showmanual > "$APT_RECORD"/apt-manual.txt

    # gotta do something here, need a debian system to check
} #}}}

universal_install_help() { # {{{
	width="72"
	if command -v tput > /dev/null 2>&1; then
		if [ "$(tput cols)" -lt "$width" ]; then
			width=$(tput cols)
		fi
	fi


	help_text=$(cat <<EOF
$0

This script makes a best-effort attempt to keep your system up to date and \
record things such that you can recover more easily from a system crash.

A few assumptions:

- The system is sufficiently unix-y to have sh running on it.  This output \
is printing, so the script is already running.
- You do, in fact, want things recorded somewhere. If the environmental \
variable \$UNIVERSAL_RECORD is set, files will be written there. \
Otherwise, \$XDG_DATA_HOME will be used. If this is unset, a default \
value of \$HOME/.local/share is used. In all cases, a folder \
\`universal\` will be used to store the data, and created if necessary.
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

case $(uname -s) in
    Darwin*)
        brew_update;;
    Linux*)
        apt_update;;
esac

git_update

vim_plugin_update
