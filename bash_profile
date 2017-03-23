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

# show time command was run in history
HISTTIMEFORMAT="%F %R "

# pretty PS1
__prompt_command() {
  # returns the emoji clock closest to the current time
  # CLOCK=$(date +%I\ 60*%M+45-30/24%%2+2~C*+C8335+0PP|dc|iconv -f ucs-4)
  BRANCH=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
  GREY="\033[38;5;14m"
  JADE="\033[38;5;6m"
  LAVENDER="\033[38;5;13m"
  # $? gives exit code of last command
  # \! gives history # of this command
  #
  PS1="$LAVENDER\W:$GREY$BRANCH$LAVENDER *>$GREY "
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
  LINE+=$(printf ' %.0s' $(seq 1 $(bc <<< "$(tput cols) - 12*($(tput cols)/12)")))
  echo -e "$LINE"
  tput sgr0

  unset OFFSET
  unset END
  unset LINE
  unset STUFF
}

bind -x '"\C-l": clear; __pretty_line'
