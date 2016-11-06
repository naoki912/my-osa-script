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
  - ictsc-ucs-02
    + 一度上と同じものを選択し、途中まで進めてパーティションを作成してから `Go Back` で `Manual` を選択
    + `Configure the Logical Volume Manager` を選択
    + `Delete volume group` でvolume groupを削除
    + Finishで前のメニューに戻る
    + `#5 logical` を選択し、`Delete the partition` で削除
    + swapを作成する。 `pri/log 988.5 GB` -> `Create a new partition` -> `137.3GB` を入力
      -> `Logical` -> `End` -> `Use as` から `swap area` を選択
      -> `Done setting up the partition`
    + rootを作成する。 `pri/log 861.2 GB` -> `Create a new partition` -> `50%` を入力
      -> `Logical` -> `Beginning` -> `Use as` から `physical volume for LVM` を選択
      -> `Done setting up the partition`
    + cinder-volumes用LVMを作成する。 `pri/log 430.6 GB` -> `Create a new partition` -> デフォルトでEnter (430.6 GB)
      -> `Logical` -> `Use as` から `physical volume for LVM` を選択
      -> `Done setting up the partition`
    + `Configure the Logical Volume Manager` を選択
    + `Create volume group` -> `ictsc-ucs-02-vg` 入力 -> `/dev/sdb6` 選択
    + `Create volume group` -> `cinder-volumes` 入力 -> `/dev/sdb7` 選択
    + `Create logical volume` -> `ictsc-ucs-02-vg` -> `root` 入力 -> デフォルトでEnter
    + `Finish`
    + `LVM VG ictsc-ucs-02-vg, LV root .....` 内の `#1 430.6GB` を選択
      -> `Use as` を `Ext4` -> `Mount Point` を `/` -> Label を `root` -> `Done setting up the partition`
    + 終了
    + ---
    + ictsc-ucs-02 のディスクに最終的に出来るもの
      ```
      LVM VG ictsc-ucs-02-vg
        #1 430.6 GB f ext4 /
      #1 primary 510.7 MB K lvm
      #6 logical 430.6 GB K lvm  // ictsc-ucs-02-vg, root など
      #7 logical 430.6 GB K lvm  // cinder-volumes
      #5 logical 137.3 GB f swap swap
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
sudo ./scripts/init-compute.sh
sudo ./scripts/init-controller.sh
# 勝手に再起動される
```

## OpenStack-Ansibleのための初期設定 (手動でやったほうがいいやつ)

### Conpute

cinder-volumes LVMを作成 (インストーラでmetadatasizeがどのように設定されているかわからないため)

```
sudo pvcreate --metadatasize 2048 /dev/vdb7
sudo vgcreate cinder-volumes /dev/vdb7

# 確認
sudo pvdisplay
```

### Controller

Ansibleで使用するssh公開鍵をcomputeにコピー

```
sudo ssh-keygen
sudo ssh-copy-id -i ~/.ssh/id_rsa ictsc@172.16.1.102

cd /opt/my-osa-script/scripts
sudo ./init-osa-controller.sh

sudo python pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml
# user_secrets.yml の keystone_auth_admin_password 分かりやすいものに変更する

cd /opt/openstack-ansible/playbooks
sudo openstack-ansible setup-hosts.yml
sudo openstack-ansible setup-infrastructure.yml
sudo ansible galera_container -m shell -a "mysql -h localhost -e 'show status like \"%wsrep_cluster_%\";'"
# 表示を確認
sudo openstack-ansible setup-openstack.yml
```
