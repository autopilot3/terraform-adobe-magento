#!/bin/bash

sudo adduser --comment "" magento

sudo yum -y update

sudo yum install -y curl gnupg2 gnupg ca-certificates  \
    wget unzip lsof strace python3-pip git jq binutils telnet rsync

echo "cd /var/www/html/magento/" | sudo tee -a ~magento/.bashrc

echo "cat /tmp/discovered-vars" | sudo tee -a ~magento/.bashrc

echo "PATH=\$PATH:/var/www/html/magento/bin" | sudo tee -a ~magento/.bashrc

echo "magento ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/90-magento-passwordless-sudo
