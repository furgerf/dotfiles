#!/bin/bash

alias deploy='echo "Removing old DataServer..." && sudo rm /opt/hxm/dataserver/* ; echo "Copying files from Release directory..." && sudo mv $HOME/Release/* /opt/hxm/dataserver/ && echo "Removing leftover Release directory..." && rmdir $HOME/Release && echo "Restarting DataServer service..." && sudo service hxm-dataserver restart && echo "... done!"'
alias dsrestart='sudo service hxm-dataserver restart'
alias dsstop='sudo service hxm-dataserver stop'
alias dsstart='sudo service hxm-dataserver start'
alias ss='sudo service'
alias fsupdate='echo "Changing directory..." ; cd /var/www/hxm-fatigue-supervisor ; echo "Stopping services..." ; sudo service hxm-websocket stop ; sudo service nginx stop ; echo "Pulling git..." ; git pull ; echo "Running npm install..." ; npm install ; echo "Running grunt..." ; grunt ; echo "Running phar install..." ; sudo php composer.phar install ; echo "Migrating database..." ; php5 vendor/bin/phinx migrate ;  echo "Starting services..." ; sudo service nginx start ; sudo service hxm-websocket start ; cd - echo "DONE!"'
debdownload () {
  apt-get --print-uris --yes install $1 | grep ^\' | cut -d\' -f2 | wget -i -
}

