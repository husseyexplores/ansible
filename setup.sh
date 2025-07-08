#!/usr/bin/env bash

## Install ansible
sudo apt install curl git software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible ssh curl git resolvconf

# sudo chmod +x scripts/*.sh

## pull ansible
# sudo ansible-pull -U https://github.com/husseyexplores/ansible.git