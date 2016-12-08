#!/bin/bash

function log_message {
  echo "`date --iso-8601=seconds --utc` schedule-backups: $1"
}


echo
log_message "Scheduling automatic backups..."
did_something=''

backup_match=`crontab -l | grep '/opt/ed.*/backup.sh daily'`
delete_match=`crontab -l | grep '/opt/ed.*/delete-old-backups.sh'`


if [ -z "$backup_match" ]; then
	crontab -l | { cat; echo '10 2 * * * cd /opt/ed && ./scripts/backup.sh daily >> maint.log 2>&1'; } | crontab -
	log_message "Added backup.sh entry."
	did_something='yes'
fi

if [ -z "$delete_match" ]; then
	crontab -l | { cat; echo '10 3 * * * cd /opt/ed && ./scripts/delete-old-backups.sh >> maint.log 2>&1'; } | crontab -
	log_message "Added delete-old-backups.sh entry."
	did_something='yes'
fi

if [ -n "$did_something" ]; then
	log_message "Done. Bye."
else
	log_message "Already done. Nothing to do. Bye."
fi
echo
