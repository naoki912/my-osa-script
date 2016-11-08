#!/usr/bin/env sh

git clone -b myosa/stable/newton https://github.com/naoki912/openstack-ansible /opt/openstack-ansible

cp -r /opt/openstack-ansible/etc/openstack_deploy /etc/openstack_deploy

cp ../files/openstack_user_config.yml /etc/openstack_deploy/openstack_user_config.yml

cd /opt/openstack-ansible

sudo scripts/bootstrap-ansible.sh
