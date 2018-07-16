#!/usr/bin/env sh

echo "This script will install vim-plug and start vim to install all plugins."
echo "It assumes you have curl somewhere in PATH and will fail otherwise."

read -r "Are you sure you want to proceed? [y/n] " response

case "$response" in 
	[yY][eE][sS]|[yY])
		curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		;;
	*)
		echo "Unknown response, no action taken. Please run script again if necessary." >&2
		;;
esac
