#!/bin/bash

echo "[JOB 1] Join node to Kubernetes Cluster"
yum install -q -y sshpass >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kmaster.com:/join_cluster.sh /join_cluster.sh 2>/dev/null
bash /join_cluster.sh >/dev/null 2>&1