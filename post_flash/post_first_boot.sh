#!/bin/bash

# disbale password login
echo "Post first boot - disabling ssh password login"
TFILE=`mktemp --tmpdir tfile.XXXXX`
trap `rm -f $TFILE` 0 1 2 3 15
sed 's/PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config > $TFILE
cat $TFILE > /etc/ssh/sshd_config

# update ubuntu user to custom
echo "Post first boot - updating username" 
groupadd YOUR_USER_NAME
usermod -d /home/YOUR_USER_NAME -m -g YOUR_USER_NAME -l YOUR_USER_NAME ubuntu
echo YOUR_USER_NAME:ubuntu | chpasswd
passwd -e YOUR_USER_NAME
groupdel ubuntu

# add ssh public key for passwordless login
echo "Post first boot - adding ssh key for passwordless login"
cat /id_rsa.pub >> /home/YOUR_USER_NAME/.ssh/authorized_keys

# install k8s packages
echo "Post first boot - installing k8s and dependent packages"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt-get update -q && apt-get install -y apt-transport-https docker.io kubeadm kubelet kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable docker

# disable service by deleting self
rm /id_rsa.pub
rm $0

# reboot system
reboot now