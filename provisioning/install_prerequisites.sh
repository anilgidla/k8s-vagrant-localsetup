#!/bin/bash


echo "[JOB 1]  Update /etc/hosts"
cat >>/etc/hosts<<EOF
100.10.10.100 kmaster.com kmaster
100.10.10.101 kworker1.com kworker1
100.10.10.102 kworker2.com kworker2
EOF


echo "[JOB 2]  Install docker container engine"
yum install -y -q yum-utils curl  git device-mapper-persistent-data lvm2 > /dev/null 2>&1
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
yum install -y -q docker-ce >/dev/null 2>&1


echo "[JOB 3]  Enable and start docker service"
systemctl enable docker >/dev/null 2>&1
systemctl start docker


echo "[JOB 4]  Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux


echo "[JOB 5]  Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld


echo "[JOB 6]  Load  br_netfilter"
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables


echo "[JOB 7]  Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a


echo "[JOB 8]  Add yum repo file for kubernetes"
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


echo "[JOB 9]  Install kubeadm, kubelet and kubectl"
yum install -y -q kubeadm kubelet kubectl >/dev/null 2>&1


echo "[JOB 10] Enable and start kubelet service"
systemctl enable kubelet >/dev/null 2>&1
systemctl start kubelet >/dev/null 2>&1


echo "[JOB 11] Add sysctl settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1


echo "[JOB 12] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd


echo "[JOB 13] Set root password"
echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1
echo "export TERM=xterm" >> /etc/bashrc