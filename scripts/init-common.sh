#!/usr/bin/env sh

apt update

apt -y dist-upgrade

apt -y install aptitude build-essential git ntp ntpdate openssh-server python-dev sudo bridge-utils vlan tmux vim curl

echo 'bonding' >> /etc/modules
echo '8021q' >> /etc/modules
