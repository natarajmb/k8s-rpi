#!/bin/bash

# update wireless settings
echo "First Boot - updating wireless settings"
cat /wireless.yaml >> /etc/netplan/50-cloud-init.yaml

# update hostname
echo "First Boot - updating hostname" 
echo "YOUR_HOST_NAME" > "/etc/hostname"

# update ubuntu user to custom
echo "First Boot - updating username" 
groupadd NEW_USERNAME
usermod -d /home/NEW_USERNAME -m -g NEW_USERNAME -l NEW_USERNAME ubuntu
echo NEW_USERNAME:ubuntu | chpasswd
passwd -e NEW_USERNAME
userdel ubuntu
groupdel ubuntu

# delete post install setup & self
systemctl disable custom-local-init.service
rm /lib/systemd/system/custom-local-init.service
rm /wireless.yaml
rm $0

# reboot system
reboot now


