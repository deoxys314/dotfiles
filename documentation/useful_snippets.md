# Useful snippets

A collection of useful one-liners or the like which don't merit an entire file
to themselves.

### OSX battery
This one liner will extract the current battery level for use at the OSX command
line.

`(pmset -g batt | grep --color=never -o -E "[0-9]{1,3}%")`

Note: in tmux, you will have to add an extra `%` as the string is passed through
`date`.
