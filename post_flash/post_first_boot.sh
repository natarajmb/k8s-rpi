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
curl -k https://packages.cloud.google.com/apt/doc/apt-key.gpg -o /tmp/k8s-key
sleep 5 # giving time to write output key before reading
apt-key add /tmp/k8s-key

cat <<EOF | tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# let docker use systemd for its driver management
[[ -d /etc/docker/ ]] || mkdir -p /etc/docker/
cat <<EOF | tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

apt-get update -q && apt-get install -y apt-transport-https docker.io kubeadm kubelet kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable docker

# disable service by deleting self
rm /id_rsa.pub
rm $0

# reboot system
reboot now