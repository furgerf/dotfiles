#!/bin/bash

source "$HOME/git/dotfiles/arch/third-party/git-completion.bash"

alias compton-enable='compton --backend glx --paint-on-overlay --vsync opengl-swc -fb -D3'
alias refresh-conky='killall -SIGUSR1 conky'
alias term='xfce4-terminal'

todo() {
  todoFile="/data/Dropbox/misc/misc/todo.txt"
  todoHistory="/data/Dropbox/misc/misc/todo_history.txt"
  if [[ ! -f "$todoFile" ]]; then
    touch "$todoFile"
  fi
  if [[ ! -f "$todoHistory" ]]; then
    touch "$todoHistory"
  fi
  re='^[0-9]+$'
  if [[ "$#" -eq 0 ]]; then
    cat -n "$todoFile"
    echo -ne "----------------------------\nType a number to remove: "
    read -r NUMBER
    sed -ie "${NUMBER}d" "$todoFile"
  elif [[ "$#" -eq 1 && "$1" == "-l" ]]; then
    cat -n "$todoFile"
  elif [[ "$#" -eq 1 && "$1" == "-h" ]]; then
    cat -n "$todoHistory"
  elif [[ "$#" -eq 1 && "$1" == "-c" ]]; then
    echo > "$todoFile"
    echo > "$todoHistory"
  elif [[ "$#" -eq 1 && $1 =~ $re ]]; then
    sed -ie "${1}d" "$todoFile"
    cat -n "$todoFile"
  else
    echo "$@" >> "$todoFile"
    echo "$(date '+%A, %B %d, %Y [%T]')" "$@" >> "$todoHistory"
    cat -n "$todoFile"
  fi
}
finished () {
  if [[ "$1" -eq "" ]]; then
    echo "Please specify a number to remove"
  else
    sed -i "$1"d /data/Dropbox/misc/misc/todo.txt
  fi
}

pdf() { okular "$1" &> /dev/null & }

alias sau='sudo apt update && sudo apt upgrade'
alias sai='sudo apt install '

alias move-downloads-here='ls ~/downloads/*; mv ~/downloads/* .'

