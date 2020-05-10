#!/bin/bash

# update wireless settings
echo "First boot - updating wireless settings"
cat /wireless.yaml >> /etc/netplan/50-cloud-init.yaml
netplan generate

# update hostname
echo "First boot - updating hostname" 
echo "YOUR_HOSTNAME" > '/etc/hostname'

# letting iptable see bridge traffic and allowing ip forwarding
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.ipv4.tcp_mtu_probing = 1
EOF

# enable cgroup memory
echo "First boot - enable cgroup memory & cpu limit"
sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/' /boot/firmware/cmdline.txt

# disable service by deleting self
rm /wireless.yaml
rm $0

# reboot system
reboot now