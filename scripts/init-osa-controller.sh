#!/usr/bin/env sh

git clone -b stable/newton https://github.com/openstack/openstack-ansible /opt/openstack-ansible

cp -r /opt/openstack-ansible/etc/openstack_deploy /etc/openstack_deploy

cp ../files/haproxy_config.yml /opt/openstack-ansible/playbooks/vars/configs/haproxy_config.yml
cp ../files/openstack_user_config.yml /etc/openstack_deploy/openstack_user_config.yml

cd /opt/openstack-ansible

sudo scripts/bootstrap-ansible.sh
