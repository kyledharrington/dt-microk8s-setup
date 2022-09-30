#!/bin/bash

#Variablize later
#echo enter what version of micro k8s are you installing?
#sleep 1
#echo ex: 1.19

# micro k8s manual installation documentaiton can be found here:
# https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s
 
# install micro k8s 1.19 stable on ubuntu via snap
echo installing microk8s v1.19 for use with Dynatrace cloudNativeFullstack
echo this will take a little bit, please be patient...
sleep 1
sudo snap install microk8s --classic --channel=1.19/stable

# firewall rule modifications
sleep 1
echo modifying firewall rules...
sleep 2
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sleep 1 
echo saving firewall rules..
sleep 1
sudo ufw default allow routed
sleep 1

# add current user to microk8s group
echo adding $(whoami) use to microk8s group.
echo you will need to create a new terminal session for these settings to take effect...
sleep 1
sudo usermod -a -G microk8s $(whoami)
sudo chown -f -R $(whoami) ~/.kube

# enable micro k8s addons. using sudo to bypass microk8s groups for now 
echo enabling microk8s addons...
sleep 1  
sudo microk8s enable dns dashboard storage helm3 

# setup and install NFS mount mount for CSI drivers and oneagent
# note this methodology only works in microk8s 1.19 as it has been depreciated in newer versions of micro k8s
# manual documentation here: 
# https://microk8s.io/docs/nfs

# install nfs kernel
echo installing nfs server requirements...
sleep 1
sudo apt-get install nfs-kernel-server

# modify permisssions for filesystem
echo modifying directory permissions...
sleep 1
sudo mkdir -p /srv/nfs
sudo chown nobody:nogroup /srv/nfs
sudo chmod 0777 /srv/nfs

# modify local exports file
echo enabling exports for local host to microk8s...
sleep 1
sudo mv /etc/exports /etc/exports.bak
sleep 1
echo '/srv/nfs 10.0.0.0/24(rw,sync,no_subtree_check)' | sudo tee /etc/exports
sleep 1
echo restarting nfs kernel service.... 
sudo systemctl restart nfs-kernel-server
sleep 3

# add helm repos 
echo adding helm repos for csi drivers.... 
sudo microk8s helm3 repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
sleep 1
sudo microk8s helm3 repo update
sleep 1

# install DYNATRACE SPECIFIC mount path this for CSI drivers
echo setting up csi driver volume mount....
echo this script will pause for 10 seconds while storage becomes available... 
sleep 1
sudo microk8s helm3 install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace kube-system --set kubeletDir=/var/snap/microk8s/common/var/lib/kubelet
sleep 10 

# creates storage class and persistent volume claim for CSI driver
echo creating storace class and PVC for CSI drivers....
sleep 1
sudo microk8s kubectl apply -f /yamls/storage/microk8s-nfs.yaml
sleep 5