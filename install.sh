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
    if [ -e "$DEST" ]; then
      echo "NOTE: $DEST exists already!"
    fi
    read ANSWER
    ANSWER=${ANSWER,,}
    echo "Answer: $ANSWER"
    if [ "$ANSWER" == "y" ]; then
      if [ "$SUDO" == "sudo" ]; then
        echo -n "(root) "
      fi
      echo "Creating symlink from $1 to $2"
      $3 ln -snf $1 $2
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
prompt-file $PWD/awesome $HOME/.config/awesome
prompt-file $PWD/arch/bashrc $HOME/.bashrc
prompt-file $PWD/arch/bash-sourcer.sh $HOME/.bash-sourcer.sh
prompt-file $PWD/arch/inputrc $HOME/.inputrc
prompt-file $PWD/arch/tmux.conf $HOME/.tmux.conf
prompt-file $PWD/arch/vimperatorrc $HOME/.vimperatorrc
prompt-file $PWD/arch/asoundrc $HOME/.asoundrc
prompt-file $PWD/arch/pulseaudio-ctl-config $HOME/.config/pulseaudio-ctl/config
prompt-file $PWD/arch/gitconfig $HOME/.gitconfig
prompt-file $PWD/arch/xinitrc $HOME/.xinitrc
prompt-file $PWD/arch/ctags $HOME/.ctags
prompt-file $PWD/arch/git-templates $HOME/.git-templates
prompt-file $PWD/arch/gitignore $HOME/.gitignore
prompt-file $PWD/arch/fonts $HOME/.fonts

echo "* LINUX (root)"
prompt-file $PWD/awesome/theme /usr/share/awesome/themes/mysty sudo
prompt-file $PWD/arch/slim.conf /etc/slim.conf sudo
prompt-file $PWD/arch/acpi-handler.sh /etc/acpi/handler.sh sudo
prompt-file $PWD/arch/locale.conf /etc/locale.conf sudo
prompt-file $PWD/arch/locale.gen /etc/locale.gen sudo
prompt-file $PWD/arch/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf sudo
prompt-file $PWD/arch/20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf sudo
prompt-file $PWD/arch/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf sudo

