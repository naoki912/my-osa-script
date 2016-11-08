#!/usr/bin/env sh

sudo apt update

sudo apt -y dist-upgrade

sudo apt -y install aptitude build-essential git ntp ntpdate openssh-server python-dev sudo bridge-utils vlan tmux vim curl

sudo echo 'bonding' >> /etc/modules
sudo echo '8021q' >> /etc/modules
