#!/bin/bash
BASEDIR=$1

sudo adduser --disabled-password --gecos "" magento

sudo rm -rf ~magento/.bashrc
sudo rm -rf ~ec2-user/.bashrc
sudo cp -a $BASEDIR/scripts/.bashrc ~magento/.bashrc
sudo cp -a $BASEDIR/scripts/.bashrc ~ec2-user/.bashrc
sudo chown magento. ~magento/.bashrc
sudo chown ec2-user. ~ec2-user/.bashrc

sudo apt update

sudo apt install -y curl gnupg2 gnupg ca-certificates lsb-release debian-archive-keyring \
    apt-transport-https wget unzip lsof strace mariadb-client python3-venv python3-pip \
    git jq binutils telnet rsync
