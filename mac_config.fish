#!/usr/fish

# Sets up path for rust
set -gx PATH "$HOME/.cargo/bin" $PATH;


function git_prompt_seg

  if git_is_repo
    if git_is_dirty
      segment_right black red (git_branch_name)
    else
      segment_right black green (git_branch_name)
    end
  segment_close
  end

end

function fish_prompt
  set -l lastexit $status

  segment black blue " "(prompt_pwd)"  "

  if not test $lastexit -eq 0
    segment black red  " $lastexit "
  end

  segment black yellow (echo " $USER"@"$__fish_prompt_hostname ")
  segment_close

end

function fish_right_prompt -d "Write out the right prompt"

  git_prompt_seg

end

# Aliases
alias pytest="python3 -m pytest --verbose -r ap"


