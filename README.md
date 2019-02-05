# k8s-vagrant

## About...

This setup is used to create kubernetes cluster on  local laptop / desktop using vagrant - with this we can create a three node cluster setup which contains one master and two worker nodes with one single command.


## Table of Contents

* [What are the pre-requisites ?](#pre-requisites)
* [How to deploy kubernetes cluster ?](#deploy)
* [How to install HELM ?](#helm)
* [What are the VM's configured ?](#configuration)
* [How to access Kubernetes Dashboard ?](#dashboard)
* [How to access Vagrant VM's ?](#access)
* [How to stop Vagrant VM's ?](#stop)
* [How to restart Vagrant VM's ?](#restart)


<a id="pre-requisites"></a>
## What are the pre-Requisites ?
* [vagrant plugin install vagrant-disksize](https://github.com/sprotheroe/vagrant-disksize "vagrant plugin install vagrant-disksize")
* [Git](https://git-scm.com/downloads "Git")
* [Vagrant](https://www.vagrantup.com/downloads.html "Vagrant")
* [Oracle Virtual Manger](https://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html "Oracle Virtual Manger")
* `Virtualization needes to be enabled in System BIOS`
* `Minimum laptop/desktop configuration  - 32 gb ram,  8 cores cpu (not to worry base OS will balance the cpu need on time sharing model), 120 gb hdd disk space`


<a id="deploy"></a>
## How to deploy kubernetes cluster ?
* Open `bash` terminal 
* Checkout the code  (git clone https://github.com/SubhakarKotta/k8s-vagrant.git) 
* `cd k8s-vagrant/provisioning` 
    
	By running the below command kubernetes cluster will be created with 3 Centos VM's installed including Kubernetes Dashboard with [configuration](#configuration)
* `vagrant up`



<a id="helm"></a>
## How to install HELM ?
The below two commands to be executed on master vm (100.10.10.100)  [How to access Vagrant VM's ](#access) to work with `HELM` charts  
* `helm init`
* `helm init --service-account tiller --upgrade`



<a id="configuration"></a>
## What are the VM's configured ?
By default below are the IP Addresses that will be configured for the VM's

|Role|FQDN|IP|OS|RAM|CPU|
|----|----|----|----|----|----|
|Master   |kmaster.com   |100.10.10.100|CentOS 7|2G|2|
|Worker-1|kworker1.com |100.10.10.101|CentOS 7|8G|2|
|Worker-2|kworker2.com |100.10.10.102|CentOS 7|8G|2|


<a id="dashboard"></a>
## How to access Kubernetes Dashboard ?
The Kubernetes Dashboard can be accessed via the below URL without any changes from your host machine

[http://100.10.10.100:30070/#!/overview?namespace=_all](http://100.10.10.100:30070/#!/overview?namespace=_all)


<a id="access"></a>
## How to access Vagrant VM's ?
* `cd k8s-vagrant/provisioning` from bash terminal
* `vagrant ssh kmaster`
* `vagrant ssh kworker1`
* `vagrant ssh kworker2`


<a id="stop"></a>
## How to stop Vagrant VM's ?
* `cd k8s-vagrant/provisioning` from bash terminal
* `vagrant halt`

<a id="restart"></a>
## How to restart Vagrant VM's ?
* `cd k8s-vagrant/provisioning` from bash terminal
* `vagrant up`