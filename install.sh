#!/bin/bash

prompt-file() {
  SRC=$1
  DEST=$2
  SUDO=$3

  if [ "$SUDO" != "sudo" ]; then
    SUDO=""
  fi

  while true; do
    echo "Do you want to create a symlink from $SRC to $DEST? (y/n)"
    read ANSWER
    ANSWER=${ANSWER,,}
    echo "Answer: $ANSWER"
    if [ "$ANSWER" == "y" ]; then
      if [ "$SUDO" == "sudo" ]; then
        echo -n "(root) "
      fi
      echo "Creating symlink from $1 to $2"
      $3 ln -sn $1 $2
      break
    elif [ "$ANSWER" == "n" ]; then
      echo "Skipping..."
      break
    else
      echo "Invalid answer, should be (y/n)"
    fi
  done
}

echo "* LINUX"
prompt-file $PWD/vim $HOME/.vim
prompt-file $PWD/arch/bashrc $HOME/.bashrc
prompt-file $PWD/arch/bash-sourcer.sh $HOME/.bash-sourcer.sh
prompt-file $PWD/arch/inputrc $HOME/.inputrc
prompt-file $PWD/arch/tmux.conf $HOME/.tmux.conf
prompt-file $PWD/arch/vimperatorrc $HOME/.vimperatorrc
prompt-file $PWD/arch/asoundrc $HOME/.asoundrc
prompt-file $PWD/arch/gitconfig $HOME/.gitconfig
prompt-file $PWD/arch/xinitrc $HOME/.xinitrc

echo "* LINUX (root)"
prompt-file $PWD/arch/slim.conf /etc/ sudo
prompt-file $PWD/arch/locale.conf /etc/ sudo
prompt-file $PWD/arch/locale.gen /etc/ sudo
prompt-file $PWD/arch/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf sudo
prompt-file $PWD/arch/20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf sudo
prompt-file $PWD/arch/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf sudo

