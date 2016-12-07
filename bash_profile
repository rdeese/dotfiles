# add via line in bash_profile or bash_rc:
# source ~/dotfiles/bash_profile

source ~/.git/git-completion.bash

# for vim with tmux
export TERM='xterm-256color'

# set default editor, partially so that tmux uses vim bindings.
export VISUAL=vim
export EDITOR="$VISUAL"

# include locally installed node modules
if command -v npm 2>/dev/null; then
  PATH=$(npm bin):$PATH
fi
