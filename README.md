# Setup Microk8s 

## Requirements:
1. VM Running Ubuntu 20.04 LTS (other OSes may work, but are not tested)
1. snap package manager
1. Host running x86 architecture 


## Setup
1. From your VM, run:
    ```
    git clone https://github.com/kyledharrington/dt-microk8s-setup.git
    ```
1. Once the repo is cloned, run the script
    ```
    ./dt-microk8s-setup/microk8sInstall.sh
    ```
1. Once the script is complete you can deploy your dynakube custom resource running in cloudNativeFullstack mode

### To do:
- add versioning functionality for other microk8s versions
----

# DISCLAIMER
# Please note this is note that the yaml files contained in this repo are not meant for production workloads
- The yaml files contained in this repo made to work ONLY with files in this repo
- The yaml files contained in this repo have been significantly modified from defaults using the dynatrace operator v7.2
- this script will spin up a microk8s environment running Kubernetes 1.19
- the script in this repo will deploy the dynatrace operator and the csi drivers
- As such this script can only be used to setup applicaiton only or cloud native full stack
