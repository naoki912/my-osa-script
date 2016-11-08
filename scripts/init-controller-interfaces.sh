#!/usr/bin/env sh

#sed -i -e "s/dhcp/static/" /etc/network/interfaces

#cat << EOF >> /etc/network/interfaces
#address 172.16.1.101
#netmask 255.255.255.0
#gateway 172.16.1.253
#dns-nameservers 8.8.8.8 8.8.4.4
#EOF

sudo cp ../files/ictsc-ucs-01.interfaces /etc/network/interfaces

sudo reboot
