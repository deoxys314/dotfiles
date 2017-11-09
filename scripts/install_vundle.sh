#!/usr/bin/env sh

echo "This script will install vundle and start vim to install all plugins."
echo "It assumes you have git installed and will fail otherwise."

read -r -p "Are you sure you want to proceed? [y/n] " response

case "$response" in 
	[yY][eE][sS]|[yY])
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim "+PluginInstall"
		;;
	*)
		echo "Aborting"
		;;
esac
