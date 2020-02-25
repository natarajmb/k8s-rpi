#!/bin/bash

# update wireless settings
echo "First boot - updating wireless settings"
cat /wireless.yaml >> /etc/netplan/50-cloud-init.yaml
netplan generate

# update hostname kali, bhadra, shimsha, netravati
echo "First boot - updating hostname" 
echo "YOUR_HOSTNAME" > '/etc/hostname'

# enable cgroup memory
echo "First boot - enable cgroup memory"
sed -i '$ s/$/ cgroup_enable=memory cgroup_memory=1/' /boot/firmware/nobtcmd.txt

# enable ip forwarding
echo "First boot - enable ip forwarding"
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf 

# disable service by deleting self
rm /wireless.yaml
rm $0

# reboot system
reboot now