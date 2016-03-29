#!/bin/bash

# select the bashrc files to source here
bashd="$HOME/git/dotfiles/arch/bash.d"
if [ -d $bashd ]; then
  for i in $bashd/*.sh; do
    if [ -r $i ]; then
      #echo "Sourcing $i"
      source $i
    fi
  done
  unset i
fi
unset bashd

