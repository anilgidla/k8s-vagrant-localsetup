#!/bin/bash

echo "[JOB 1] Start Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=100.10.10.100 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

echo "[JOB 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube


echo "[JOB 3] Install flannel network"
su - vagrant -c "kubectl create -f /vagrant/kube-flannel.yaml"
su - vagrant -c "kubectl create -f /vagrant/kubernetes-dashboard.yaml"
su - vagrant -c "kubectl create -f /vagrant/kubernetes-dashboard-rbac.yaml"


echo " [JOB 4] Generate and save cluster join command to /join_cluster.sh"
kubeadm token create --print-join-command > /join_cluster.sh


echo " [JOB 5]  Install JDK"
yum install -y java-1.8.0-openjdk



echo " [JOB 6]  Install Postgres"
yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
yum install -y postgresql10-server postgresql10-contrib
/usr/pgsql-10/bin/postgresql-10-setup initdb
sudo systemctl start postgresql-10
sudo systemctl enable postgresql-10



echo "[JOB 7] Install HELM"
export PATH=/bin:/usr/bin:/usr/local/bin
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod  777 get_helm.sh
./get_helm.sh

 

echo "[JOB 8] Install TILLER"
su - vagrant -c "kubectl --namespace kube-system create serviceaccount tiller"
su - vagrant -c "kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller"