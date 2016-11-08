# README.md

* OS: Ubuntu16.04.1

## OSのインストール
* 選択は基本的にデフォルト
* 言語等はenに統一
* default interface -> enp1s0f0
* hostname -> ictsc-ucs-01,2
* mirror -> Japan -> jp.archve.ubuntu.com
* disk
  - ictsc-ucs-01 -> `Guided - use entire disk and set up LVM`
  - ictsc-ucs-02 ->
    ```
    #1 primary 450.0 GB B f ext4 /
    #2 primary 450.0 GB     // インストール後に cinder-volumes に変更
    #3 primary 99.0 GB f swap swap
    ```
* user
  - full name: None
  - name: ictsc
  - password: ${ぱすわーど}
* Choose software to install:
  - `standard system utilities`
  - `OpenSSH server`

## インストール後の初期設定

```
sudo apt update
sudo apt -y install git
sudo git clone https://github.com/naoki912/my-osa-script.git /opt/my-osa-script
cd /opt/my-osa-script/scripts

sudo ./scripts/init-common.sh

# 環境に合わせて実行
sudo ./scripts/init-compute-interfaces.sh
sudo ./scripts/init-controller-interfaces.sh

# 勝手に再起動される
```

## OpenStack-Ansibleのための初期設定 (手動でやったほうがいいやつ)

### Conpute

cinder-volumes LVMを作成 (インストーラでmetadatasizeがどのように設定されているかわからないため)

```
# 場合によっては /dev/sdb になる
sudo pvcreate --ff --metadatasize 2048 /dev/sda2
sudo vgcreate cinder-volumes /dev/sda2

# 確認
sudo pvdisplay
```

### Controller

Ansibleで使用するssh公開鍵をcomputeにコピー

```
sudo ssh-keygen
sudo ssh-copy-id -i /root/.ssh/id_rsa ictsc@172.16.1.102
# ictsc-ucs-02側で実行
sudo cp -r ~/.ssh/ /root/

cd /opt/my-osa-script/scripts
sudo ./init-osa-controller.sh

cd /opt/openstack-ansible/scripts/
sudo python pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml
# /etc/openstack_deploy/user_secrets.yml の keystone_auth_admin_password 分かりやすいものに変更する

cd /opt/openstack-ansible/playbooks
sudo openstack-ansible setup-hosts.yml
sudo openstack-ansible setup-infrastructure.yml
sudo ansible galera_container -m shell -a "mysql -h localhost -e 'show status like \"%wsrep_cluster_%\";'"
# 表示を確認
sudo openstack-ansible setup-openstack.yml
```
