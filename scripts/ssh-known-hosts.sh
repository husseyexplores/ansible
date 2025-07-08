#!/usr/bin/env bash

# Ensure the .ssh directory exists

SSH_DIR=~/.ssh

if [[ $TEST ]] then
  SSH_DIR=/home/hsy/ansible
fi

KNOWN_HOSTS=$SSH_DIR/known_hosts


# Only modify this
targets="github.com,thiasdasdasdng.com,${VPN_IP}"

targets="${targets//,/ }"
horizontal_line="-------------------------------------------------------------------------------------"

# mkdir -p $SSH_DIR
# chmod 700 $SSH_DIR

if [[ -d $SSH_DIR ]] then

  # empty the file if it exists
  if [[ -f $KNOWN_HOSTS ]] then
    > $KNOWN_HOSTS
  fi

  for target in $targets; do
    if [[ $target ]] then
      echo -e "# [ssh-keyscan $target]" >> $KNOWN_HOSTS
      echo -e "# $horizontal_line" >> $KNOWN_HOSTS
      ssh-keyscan $target >> $KNOWN_HOSTS 2>/dev/null


      echo -e "# [/ssh-keyscan $target]" >> $KNOWN_HOSTS
      echo -e "# $horizontal_line\n\n" >> $KNOWN_HOSTS

     fi
  done

fi

chmod 644 $KNOWN_HOSTS