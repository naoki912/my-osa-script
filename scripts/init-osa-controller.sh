#!/usr/bin/env sh

sudo git clone -b myosa/stable/newton https://github.com/naoki912/openstack-ansible /opt/openstack-ansible

sudo cp -r /opt/openstack-ansible/etc/openstack_deploy /etc/openstack_deploy

sudo cp ../files/openstack_user_config.yml /etc/openstack_deploy/openstack_user_config.yml

cd /opt/openstack-ansible

sudo scripts/bootstrap-ansible.sh
