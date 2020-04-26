deoxys314_dotfiles
==================

These are a collection of dotfiles I use on the majority of my machines.

Initially created 170308.

Usage
-----

It is generally intended that you will browse these files to get ideas for your
own collection of dotfiles. However, if you are truly set on running things
exactly as I do, then instructions are included below.

1. Clone the repository somewhere on your computer. (I use my home directory.)
   `$ git clone https://github.com/deoxys314/dotfiles/`

   -- OR --

   `git clone https://github.com/deoxys314/dotfiles/ /path/to/where/you/want/these`

2. Some guides have you create symlinks to these files from where they normally
   are to the git repository. I find that while I can share about 90% of my
   configuration between machines, there's always that last 10%. So instead, I
   have each configuration file source these files, and add the machine-specific
   settings after that.

   Instructions for sourcing files follow, as well as the usual location of
   configuration files

   `~/.vimrc`:

   ```vim
   source ~/dotfiles/vimfiles/vimrc
   ```

   `~/.tmux.conf`:

   ```
   source ~/dotfiles/.tmux.conf
   ```

   `~/.config/fish/config.fish`:

   ```fish
   source ~/dotfiles/config.fish
   ```

   `$profile`:
   Powershell is a little different - there is no powershell prompt file by
   default, you must create it. If the `test-path $profile` cmdlet returns
   `False`, then there has not been one created yet.

   To create a profile, type `new-item -path $profile -itemtype file -force`.

   To edit this file, type `notepad $profile` (or similar).

   And finally, PowerShell uses dot-sourcing, so the following should be
   included in your profile:

   ```powershell
   . C:\Path\to\dotfiles\profile.ps1
   ```

   I find this allows me to avoid duplicating work while still allowing my to
     tweak settings for each machine fairly easily.

Licence
-------

Released under the MIT License. See [here](LICENSE) for more info.
