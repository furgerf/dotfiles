#!/bin/bash

###############################################################################
# package manager
###############################################################################

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

# yay
function yay {
   if [[ $# -gt 0 ]]; then
     /sbin/yay --color=auto "$@"
   else
     /sbin/yay --color=auto -Syu
   fi
}
alias yas="yay -Ps" # stats
alias yaq="yay -Q" # query local
alias yar="yay -Rsn" # remove
alias yac="yay -Yc" # clean

# development
alias gourcevideo='gource -1279x720 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec \\
  ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 gource.mp4'
alias refresh-conky='killall -SIGUSR1 conky'

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

# raspi
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

# misc
source /usr/share/doc/pkgfile/command-not-found.bash
alias mirror='mplayer -vf mirror -v tv:// -tv device=/dev/video0:driver=v4l2'
alias speak='echo \""$@"\" | espeak' # FIX ME :(
say(){ curl -A RG 'translate.google.com/translate_tts' -d 'tl=en&q=$@' | mpg123 -; }

