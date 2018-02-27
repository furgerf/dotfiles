#!/bin/bash

alias drop-install='cd /var/lib/safemine/drop && for i in *.upt; do sudo mv $i $i.zip && unzip $i.zip && sudo rm $i.zip; done && sudo chown root:root * && sudo chmod 644 * && sudo mv * /opt/safemine/ && cd -'
alias logwatch="tf *.log | egrep -ai --line-buffered 'error|exception|'"
alias fmdbclear='fm-stop ; echo "***cleaning DbFatigue.db" ; sudo rm /var/lib/safemine/DbFatigue.db ; fm-start'
alias fmrestart='fm-stop ; sudo service fm start'
alias fmupdate='sudo service bootstrapper start ; echo "***updating..." ; sleep 10; fmrestart'
alias countdown='/home/service/countdown.sh'
alias syslog='vim /var/log/syslog'
alias ss='sudo service'

