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
if command -v npm >/dev/null; then
  export PATH=$(npm bin):$PATH
fi

export PATH=/usr/local/bin:$PATH

# aliases
alias mp-tmux='tmux new-s -dA -s anything -c ~\; new-s -dA -s 3TB -c /Volumes/3TB\; new-s -dA -s 4TB -c /Volumes/4TB\; attach-session -t anything'
alias civis-tmux='tmux new-s -dA -s anything -c ~\; new-s -dA -s platform -c ~/Documents/console\; new-s -dA -s metawork -c ~/Documents/work-notes\; attach-session -t anything'

# homebrew cask
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# show time command was run in history
HISTTIMEFORMAT="%F %R "

# pretty PS1
__git_branch_and_status () {
  # Get the status of the repo and color the branch name appropriately
  local STATUS=$(git status --long 2>&1)
  local BRANCH=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
  local GREEN="\[\033[32m\]"
  local RED="\[\033[31m\]"
  local YELLOW="\[\033[33m\]"
  if [[ "$STATUS" != *'Not a git repository'* ]]
  then
    PS1+="$DEFAULT:"
    if [[ "$STATUS" != *'working tree clean'* ]]
    then
      if [[ "$STATUS" == *'Changes to be committed'* ]]
      then
        # green if all changes are staged
        PS1+="$GREEN"
      fi
      if [[ "$STATUS" == *'Changes not staged for commit'* ]] || [[ "$STATUS" == *'Unmerged paths'* ]]
      then
        # red if there are unstaged changes
        PS1+="$RED"
      fi
    else
      if [[ "$STATUS" == *'Your branch is ahead'* ]]
      then
        # yellow if need to push
        PS1+="$YELLOW"
      else
        # else default
        PS1+="$DEFAULT"
      fi
    fi

    PS1+="$BRANCH"

    if [[ "$STATUS" == *'Untracked files'* ]]
    then
      # red question mark to indicate untracked files
      PS1+="$RED"
      PS1+="?"
    fi
  fi
}

__prompt_command() {
  # returns the emoji clock closest to the current time
  # CLOCK=$(date +%I\ 60*%M+45-30/24%%2+2~C*+C8335+0PP|dc|iconv -f ucs-4)
  local DEFAULT="\[\033[0m\]"
  local JADE="\[\033[36m\]"
  local LAVENDER="\[\033[95m\]"
  # $? gives exit code of last command
  # \! gives history # of this command
  PS1="$LAVENDER\W"
  __git_branch_and_status
  PS1+="$LAVENDER *>$DEFAULT "
}

PROMPT_COMMAND=__prompt_command

__pretty_line() {
  local OFFSET=$(bc <<< "16 + ($RANDOM % 36 + 1)*6")
  local END=$(bc <<< "$OFFSET + 5")
  local LINE=""
  local STUFF=""

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
}

bind -x '"\C-l": clear; __pretty_line'
