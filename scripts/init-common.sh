#!/usr/bin/env sh

sudo apt update

sudo apt -y dist-upgrade

sudo apt -y install aptitude build-essential git ntp ntpdate openssh-server python-dev sudo bridge-utils vlan lvm2 tmux vim curl

sudo sh -c "echo 'bonding' >> /etc/modules"
sudo sh -c " echo '8021q' >> /etc/modules"
