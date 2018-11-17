# Useful snippets

A collection of useful one-liners or the like which don't merit an entire file
to themselves.

## OSX battery

This one liner will extract the current battery level for use at the OSX command
line.

`(pmset -g batt | grep --color=never -o -E "[0-9]{1,3}%")`

Note: in tmux, you will have to add an extra `%` as the string is passed through
`date`.

## OSX change to current open Finder Window

```fish
function cdf
  set --local target (osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
  if test -n target
    echo "Changing directory to: $target"
    cd $target
  else
    echo "No Finder window found." >&2
    return 1
  end
end
```
Adapting this to other shell languages should be fairly easy.

## Git change remote URL

`git remote set url [remote name] [new url]`
