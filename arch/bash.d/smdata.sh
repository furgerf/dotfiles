#!/bin/bash

alias deploy='echo "Removing old DataServer..." && sudo rm /opt/hxm/dataserver/* ; echo "Copying files from Release directory..." && sudo mv $HOME/Release/* /opt/hxm/dataserver/ && echo "Removing leftover Release directory..." && rmdir $HOME/Release && echo "Restarting DataServer service..." && sudo service hxm-dataserver restart && echo "... done!"'
alias dsrestart='sudo service hxm-dataserver restart'
alias dsstop='sudo service hxm-dataserver stop'
alias dsstart='sudo service hxm-dataserver start'
alias ss='sudo service'
alias fsupdate='echo "Changing directory..." ; cd /var/www/hxm-fatigue-supervisor ; echo "Pulling git..." ; git pull ; echo "Running npm install..." ; npm install ; echo "Running bower update..." ; bower update ; echo "Running grunt..." ; grunt ; echo "Running phar install..." ; php composer.phar install ; echo "Migrating database..." ; php5 misc/preparePhinx.php; php5 vendor/bin/phinx migrate ;  echo "Restarting nginx..." ; sudo service nginx restart ; cd - echo "DONE!"'
alias highstateundo='echo "Chowning /var/log/hxm..."; sudo chown -R hxm:hxm /var/log/hxm; echo "Stopping websocket..."; sudo service hxm-websocket stop'

debdownload () {
  apt-get --print-uris --yes install $1 | grep ^\' | cut -d\' -f2 | wget -i -
}

pjson() { python2 $HOME/git/linux-scripts/pjson.py; }

fortune | cowsay | lolcat

