# deoxys314_dotfiles
These are a collection of dotfiles I use on the majority of my machines.

Initially created 170308.

### Usage

It is generally intended that you will browse these files to get ideas for your own collection of dotfiles.  However, if you are truly set on running things exactly as I do, then instructions are included below.

1. Clone the repository somewhere on your computer. (I use my home directory.)
   `$ git clone https://github.com/deoxys314/deoxys314_dotfiles/`

   -- OR --
   
   `git clone https://github.com/deoxys314/deoxys314_dotfiles/ /path/to/where/you/want/these`

2. Some guides have you create symlinks to these files from where they normally are to the git repository.  I find that while I can share about 90% of my configuration between machines, there's always that last 10%. So instead, I have each configuration file source these files, and add the machine-specific settings after that.  Some examples are below.

   My `~/.vimrc`:
   ```vimscript
   " Cameron Rossington .vimrc
   " created 170420

   source ~/deoxys314_dotfiles/.vimrc

   " ###WHITESPACE###
   set listchars=eol:¬,tab:»\ ,extends:>,precedes:<,nbsp:#,trail:_
   [SNIP]
   ```
 
   `~/.tmux.conf`:
   ```
   source ~/deoxys314_dotfiles/.tmux.conf
   ```
 
   `~/.config/fish/config.fish`:
   ```fish
   
   #!/usr/local/bin/fish
 
   # Sources global configuration files
   source ~/deoxys314_dotfiles/config.fish
 
   # Sets up path for rust
   set -gx PATH "$HOME/.cargo/bin" $PATH

   [SNIP]
   ```

   I find this allows me to avoid duplicating work while still allowing my to tweak settings for each machine fairly easily.


### Licence
Released under the MIT License. See [here](LICENSE) for more info.
