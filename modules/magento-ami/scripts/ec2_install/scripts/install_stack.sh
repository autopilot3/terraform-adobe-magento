#!/bin/bash
BASEDIR=/tmp/ec2_install
sudo cp -a $BASEDIR /opt/

if grep -i debian /etc/os-release; then
  $BASEDIR/scripts/install_base_deb.sh "$BASEDIR"
  $BASEDIR/scripts/install_nginx_deb.sh "$BASEDIR"
  $BASEDIR/scripts/install_php_deb.sh "$BASEDIR"
  $BASEDIR/scripts/install_efshelper_deb.sh
fi

if grep -i amazon /etc/os-release; then
  echo "Wait for cloud-init to complete"
  sudo cloud-init status --wait
  echo "Cloud init completed"
  $BASEDIR/scripts/install_base_amzn.sh
  $BASEDIR/scripts/install_nginx_amzn.sh "$BASEDIR"
  $BASEDIR/scripts/install_php_amzn.sh "$BASEDIR"
fi

echo "magento ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/91-magento

sudo pip3 install boto3
sudo pip3 install --upgrade awscli

echo "start install_mage_credentials.py"

python3 $BASEDIR/scripts/install_mage_credentials.py

echo "done install_mage_credentials.py"

$BASEDIR/scripts/install_composer.sh

sudo $BASEDIR/scripts/install_postfix.sh

sudo $BASEDIR/scripts/install_efssetup.sh
sudo su - magento -c "$BASEDIR/scripts/install_magento.sh $BASEDIR"
