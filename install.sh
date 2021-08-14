#!/bin/bash -x

# setup logging
exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

# env variables
export ANSIBLE_CHROOT_EXE=/usr/bin/arch-chroot
export ANSIBLE_ACTION_WARNINGS=false

# create inventory
cat <<EOF > /tmp/inventory
[chroot]
chroot ansible_host=/mnt ansible_connection=chroot
EOF

# increase cowspace size
mount -o remount,size=1G /run/archiso/cowspace

rm -R /var/lib/pacman/sync/

# install ansible
pacman -Syy --noconfirm && pacman -Sy ansible --needed --noconfirm

# install ansible dependencies
ansible-galaxy install -r requirements.yml

# run ansible
script --flush --quiet --return /tmp/ansible-output.txt --command "ansible-playbook ./playbook.yml -i /tmp/inventory"