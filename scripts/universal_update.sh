#!/usr/bin/env sh

debug_echo() {
    if [ "$DEBUG" ]; then
        echo "$@"
    fi
}

stderr_echo() {
    echo "$@" 1>&2
}

vim_plugin_update() {
    debug_echo "Updating (n)vim plguins."
    VIM_EXECUTABLE=vim
    nvim_path=$(command -v nvim)
    if [ -x "$nvim_path" ]; then
        VIM_EXECUTABLE=$nvim_path
    fi

    debug_echo "Executable path: $VIM_EXECUTABLE"

    $VIM_EXECUTABLE "+PlugUpdate!" "+qall"
}

brew_update() {
    debug_echo "Updating brew."
    BREW_RECORD=${BREW_RECORD:="$HOME"}
    debug_echo "Brew record location: $BREW_RECORD"
    if [ -x "$(command -v brew)" ]; then
        brew update
        brew upgrade
        brew cleanup
        brew list > "$BREW_RECORD"/brew-list.txt
        brew leaves > "$BREW_RECORD"/brew-leaves.txt
        brew cask lift > "$BREW_RECORD"/brew-cask-list.txt
    else
        stderr_echo "\`brew\` not found. You should probably install it, it's very useful!"
    fi
}

git_update() {
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
}

apt_update() {
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
}

universal_install_help() {
    echo "$0"
    echo ""
    echo "This script makes a best-effort attempt to keep your system up to"
    echo "date and record things such that you can recover more easily from"
    echo "a system crash."
    echo ""
    echo "A few assumptions:"
    echo ""
    echo "  - The system is sufficiently unix-y to have sh running on it."
    echo "    This output is printing, so you're probably fine."
    echo '  - You do, in fact, want things recorded somewhere. The $*_RECORD'
    echo '    family of variables control this, and default to $HOME'
    echo "  - You have some dotfiles you want to keep up to date, and use git"
    echo '    to do so. This is controlled by the $DOTFILES_DIR variable, and'
    echo '    will default to $HOME.'
    echo "    (Note: this will work with any git repo, if you want to point it"
    echo "    at something else."
    echo "  - You use vim or neovim and use vim-plug to manage plugins for"
    echo "    that editor."

}


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
