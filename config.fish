# Here is the configuration for the fish shell

set --local SCRIPTDIR (dirname (status --current-filename))

source $SCRIPTDIR/fish/aliases.fish

source $SCRIPTDIR/fish/functions.fish

mkdir -pv ~/bin

set PATH $PATH ~/bin

set -gx VISUAL vi
set -gx EDITOR vi
