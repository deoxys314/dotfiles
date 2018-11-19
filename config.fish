# Here is the configuration for the fish shell

set --local SCRIPTDIR (dirname (status --current-filename))

source $SCRIPTDIR/fish/functions.fish

mkdir -pv ~/bin

# only add ~/bin if it's not already in the PATH (reduces duplicate PATH entries)
if not contains ~/bin $PATH
	set PATH $PATH ~/bin
end


## ALIASES

# ls (a)ll (B) print unprintables (h) sizes in megabyte, et al
#    (s) file block size (l) long format
alias lsa 'ls -aBhsl'


## GLOBALS

set -gx VISUAL vi
set -gx EDITOR vi
