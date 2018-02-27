#!/bin/bash

# exports
export PATH="$PATH:/opt/android-sdk/tools:/opt/android-sdk/build-tools:/opt/android-sdk/platform-tools"
export PATH="$PATH:$HOME/git/linux-scripts:$HOME/git/linux-scripts/*"
export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:/home/fabian/perl5"
export PERL_MB_OPT="--install_base /home/fabian/perl5"
export PERL_MM_OPT="INSTALL_BASE=/home/fabian/perl5"
export PERL5LIB="/home/fabian/perl5/lib/perl5:$PERL5LIB"

# "command not found" hook
source "/usr/share/doc/pkgfile/command-not-found.bash"
source "$HOME/git/dotfiles/arch/third-party/git-completion.bash"

# pacman
alias pac="sudo /usr/bin/pacman -S"         # default action       - install one or more packages
alias pacu="sudo /usr/bin/pacman -Syu"      # '[u]pdate'           - upgrade all packages to their newest version
alias pacy="sudo /usr/bin/pacman -Syy"      #                      - rebuild local database
alias pacr="sudo /usr/bin/pacman -Rs"       # '[r]emove'           - uninstall one or more packages
alias pacs="/usr/bin/pacman -Ss"            # '[s]earch'           - search for a package using one or more keywords
alias pacq="/usr/bin/pacman -Qs"            # '[q]uery'            - query installed packages using keywords
alias paci="/usr/bin/pacman -Si"            # '[i]nfo'             - show information about a package
alias pacc="sudo /usr/bin/pacman -Scc"      # '[c]lean cache'      - delete all not currently installed package files
alias paclf="/usr/bin/pacman -Ql"           # '[l]ist [f]iles'     - list all files installed by a given package
alias pacexpl="/usr/bin/pacman -D --asexp"  # 'mark as [expl]icit' - mark one or more packages as explicitly installed
alias pacimpl="/usr/bin/pacman -D --asdep"  # 'mark as [impl]icit' - mark one or more packages as non explicitly installed
alias paclo="/usr/bin/pacman -Qdt"          # '[l]ist [o]rphans'   - list all packages which are orphaned
alias pacro="/usr/bin/pacman -Qtdq > /dev/null && sudo /usr/bin/pacman -Rs \$(/usr/bin/pacman -Qtdq | sed -e ':a;N;$!ba;s/\n/ /g')" # '[r]emove [o]rphans' - recursively remove ALL orphaned packages

# yaourt
alias ya="/usr/bin/yaourt -S"
alias yau="/usr/bin/yaourt -Syau"
alias yas="/usr/bin/yaourt -Ss"
alias yaq="/usr/bin/yaourt -Qs"
alias yar="/usr/bin/yaourt -Rs"

# modified commands
alias libre='/usr/bin/libreoffice --nologo'
alias cp='acp -agi'
alias mv='amv -gi'

# development
alias gourcevideo='gource -1279x720 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec \\
  ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 gource.mp4'
alias git-pullall='git-pull $HOME/git'
alias logcat='$HOME/git/linux-scripts/logcat'
alias refresh-conky='killall -SIGUSR1 conky'
alias tv-show-dev='tmux-node-dev tv-show-torrent-downloader'

# image/office stuff
alias image='geeqie'
alias imagefind='find . -name "*" -exec file {} \; | /usr/bin/grep -o -P "^.+: \w+ image"'
pdf() { okular "$1" &> /dev/null & }
pdfa() {
  if [ -d "$1" ]; then
    for i in ${1%/}/*.pdf; do
      pdf "$(printf %q "$i")" # this should escape spaces but doesn't work
    done
  fi
}

# win-partition related
alias winmount="mount /dev/sdb1 /win"
alias winhibernate='sudo $HOME/git/linux-scripts/winboot -h'
alias winboot='sudo $HOME/git/linux-scripts/winboot'

# raspi - MAKE SURE TO KEEP SSH CONFIG IN SSH_CONFIG
alias raspi='ssh raspi'
alias raspi-extern='ssh raspi-extern'
alias raspi-session='while true; do raspi; echo -n "Waiting 10s before reconnecting... "; for i in $(seq 10 -1 0); do sleep 1; echo  -n "$i... "; done; echo "Reconnecting..."; done'
alias raspi-extern-session='while true; do raspi-extern; echo -n "Waiting 10s before reconnecting... "; for i in $(seq 10 -1 0); do sleep 1; echo  -n "$i... "; done; echo "Reconnecting..."; done'
alias raspi-tunnel='ssh -N raspi-tunnel'
raspi-backup(){
  echo "Device to back up: "
  read -r DEVICE
  sudo dd bs=4M  if="$DEVICE" | gzip > "raspi-image-$(date +%Y-%m-%d).gz"
}
raspi-restore(){
  echo "Device to restore to: "
  read -r DEVICE
  echo "Backup file: "
  read -r BACKUP
  gzip -dc "$BACKUP" | sudo dd bs=4M of="$DEVICE"
}

# misc "useful-ish" stuff
alias term='xfce4-terminal'
execterm () { xfce4-terminal -e "bash -c '$@; exec bash'"; }
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
    [ ! -z "$NUMBER" ] && sed -ie "${NUMBER}d" "$todoFile"
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
yoghurt () {
  first=1
  ping 8.8.8.8 -c 1 -w 1 &> /dev/null
  while [ "$?" -ne 0 ]; do
    if [ $first -eq 1 ]; then
      echo "Waiting for connection..."
      first=0
    fi
    sleep 1
    ping 8.8.8.8 -c 1 -w 1 &> /dev/null
  done
  yau
}
alias dissertation='cd $HOME/git/cu/300com/300com-final-project/dissertation && pdf main.pdf && vim main.tex'
alias compton-enable='compton --backend glx --paint-on-overlay --vsync opengl-swc -fb -D3'

# misc "fun" stuff
alias spiral='x=0;y=0;while [[ $y -lt 500 ]] ; do xdotool mousemove --polar $x $y ; x=$(($x+4));y=$(($y+1)); sleep 0.01; done'
alias mirror='mplayer -vf mirror -v tv:// -tv device=/dev/video0:driver=v4l2'
alias speak='time echo \""$@"\" | ( Equalizer || espeak || say -v Fred || cat)' # FIX ME :(
alias labyrinth='while ( true ) ; do if [ $( expr $RANDOM % 2 ) -eq 0 ] ; then echo -ne "\xE2\x95\xB1" ; else echo -ne "\xE2\x95\xB2" ; fi ; done'
say(){ curl -A RG 'translate.google.com/translate_tts' -d 'tl=en&q=$@' | mpg123 -; }

alias hslu-connect='/opt/cisco/anyconnect/bin/vpn -s connect vpn.enterpriselab.ch < ~/hslu-vpn-login'
alias hslu-disconnect='/opt/cisco/anyconnect/bin/vpn disconnect'
alias hslu-box='ssh hslubox'
alias hslu-session='hslu-connect; hslu-box; hslu-disconnect'

