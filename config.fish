#!/usr/fish

#git info
set fish_git_dirty_color red
set fish_git_not_dirty_color green

if status --is-login
  function parse_git_branch
    set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
    set -l git_diff (git diff)

    if test -n "$git_diff"
      echo -n (set_color -b $fish_git_dirty_color white)$branch
    else
      echo -n (set_color -b $fish_git_not_dirty_color white)$branch
    end
  end
else
  function parse_git_branch
    echo -n 'NONLOGIN SHELL'
  end
end


function fish_prompt
  set -l lastexit $status  # we need to do this first or we will clobber it
  echo -n (set_color green)(prompt_pwd)(set_color normal)
  echo -n ' > '
  if not test $lastexit -eq 0
    echo -n (set_color red)$lastexit(set_color normal)
    echo -n ' > '
  end
  set -l git_dir (git rev-parse --git-dir 2> /dev/null)
  if test -n "$git_dir"
    echo -n (parse_git_branch)
    echo -n (set_color normal) '> '
  end
end

function fish_right_prompt -d "exit code (if not zero"
end

#set prompts
#function fish_prompt --description 'Write out the prompt'
  # Just calculate these once, to save a few cycles when displaying the prompt
  #if not set -q __fish_prompt_hostname
  # set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  #end
  #if not set -q __fish_prompt_normal
  # set -g __fish_prompt_normal (set_color normal)
  #end
#  switch $USER
#  case root
#  if not set -q __fish_prompt_cwd
#   if set -q fish_color_cwd_root
#    set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
#   else
#    set -g __fish_prompt_cwd (set_color $fish_color_cwd)
#   end
#  end
#  echo -n -s "$USER" @ "$__fish_prompt_hostname" ' ' "$__fish_prompt_cwd" [(prompt_pwd)] "$__fish_prompt_normal" '# '
#  case '*'
#  if not set -q __fish_prompt_cwd
#   set -g __fish_prompt_cwd (set_color $fish_color_cwd)
#  end
#  set -l git_dir (git rev-parse --git-dir 2> /dev/null)
#  if test -n "$git_dir"
#   echo -n -s (set_color yellow) "$USER" @ "$__fish_prompt_hostname" "$__fish_prompt_cwd":[(prompt_pwd)]"$__fish_prompt_normal" (set_color F00)' {' (parse_git_branch) (set_color F00) '} ' (set_color 00F) '> '(set_color normal)
#  else
#   echo -n -s (set_color yellow) "$USER" @ "$__fish_prompt_hostname" "$__fish_prompt_cwd":[(prompt_pwd)]"$__fish_prompt_normal"(set_color 00F) '> '(set_color normal)
#  end
# end
#end

#aliases
alias temp '/opt/vc/bin/vcgencmd measure_temp'
alias tetris 'tetris-bsd'
alias games 'cat ~/.gameslist | sort'
alias t '/home/pi/docs/todo/todo.txt-cli/todo.sh'
alias tls '/home/pi/docs/todo/todo.txt-cli/todo.sh ls | grep --color=never -E "^[[:digit:]]" | sort'
alias utils 'cat ~/.utillist | sort | more'
alias transfer 'cat ~/docs/files/scripts/transh.usage'
alias 2048 '~/docs/files/scripts/2048/./2048'
alias home '~/docs/files/scripts/home/home.sh'
alias weather '/home/pi/docs/files/scripts/weather/w.sh'
alias lastboot 'cat /home/pi/docs/files/scripts/lastboot/lastboot.log | tail'
alias life '/home/pi/docs/files/scripts/life/bash-life/bash-life.sh'
alias mhome '/home/pi/docs/files/scripts/mhome/mhome.sh'
alias lips 'cat /home/pi/docs/files/logs/ips.log'
alias pb '/home/pi/docs/files/scripts/pushbullet/pb.sh'
#alias j 'nano -cm -\$ /home/pi/docs/files/journal/(date +%Y)/(date +%m).jo'
source /home/pi/docs/files/scripts/journal/journal.fish # a more expanded journal solution
alias gcal 'gcalcli'
alias lsa 'ls -aBhsl'

alias fortunes 'fortune suq | fold -s -w (tput cols)'

alias dropbox '/home/pi/docs/utils/dropbox/Dropbox-Uploader/dropbox_uploader.sh'

function logfail
  grep -E 'authentication failure.+user=\\w' /var/log/auth.log | awk -F '=' '{print $NF}' | sort | uniq -c | sort -nr
end

set -x PATH "/home/pi/.pyenv/bin" $PATH
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)


#runs bash intro script because I'm lazy as hell
if status --is-login
	set fish_greeting
	/home/pi/docs/files/scripts/home/home.sh
end
