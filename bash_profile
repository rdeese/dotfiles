# add via line in bash_profile or bash_rc:
# source ~/dotfiles/bash_profile

source ~/.git/git-completion.bash

# for vim with tmux
export TERM='xterm-256color'

# set default editor, partially so that tmux uses vim bindings.
export VISUAL=vim
export EDITOR="$VISUAL"

# pyenv shims
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# include locally installed node modules
if command -v npm 2>/dev/null; then
  PATH=$(npm bin):$PATH
fi

# homebrew cask
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# pretty PS1
alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/(\1)/'"

__prompt_command() {
  BRANCH=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
  PS1="[\W:$BRANCH] "
  unset BRANCH
}

PROMPT_COMMAND=__prompt_command

__pretty_line() {
  OFFSET=$(bc <<< "16 + ($RANDOM % 40 + 1)*6")
  END=$(bc <<< "$OFFSET + 5")
  LINE=""

  for C in $(seq $OFFSET $END); do
      STUFF=$(printf ' %.0s' $(seq 1 $(bc <<< "$(tput cols)/12")))
      LINE+="\033[48;5;${C}m"$STUFF
  done
  for C in $(seq $END $OFFSET); do
      STUFF=$(printf ' %.0s' $(seq 1 $(bc <<< "$(tput cols)/12")))
      LINE+="\033[48;5;${C}m"$STUFF
  done
  echo -e "$LINE"
  tput sgr0

  unset OFFSET
  unset END
  unset LINE
  unset STUFF
}

bind -x '"\C-l": clear; __pretty_line'
