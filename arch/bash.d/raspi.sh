#!/bin/bash

fortune | cowsay | lolcat
PS1="\[\033[1;30m\][\[\033[0;31m\]\$?\$(if [[ \$? == 0 ]]; then echo \"  \[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;30m\]][\[\033[0;31m\]\A\[\033[1;30m\]][\[\033[0;31m\]\u\[\033[1;30m\]@\[\033[0;31m\]\h\[\033[1;30m\]][\[\033[0;31m\]\w\[\033[1;30m\]]\[\033[1;34m\]\$\[\033[0;37m\] "

source /usr/share/git/completion/git-completion.bash

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

# tmux
alias tmux-torrent='~/git/dotfiles/arch/tmux/sessions/raspi-torrents.sh'

