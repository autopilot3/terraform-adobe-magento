#!/bin/bash
BASEDIR=/tmp/ec2_install
sudo cp -a $BASEDIR /opt/

if grep -i debian /etc/os-release; then
  $BASEDIR/scripts/install_base_deb.sh
  $BASEDIR/scripts/install_nginx_deb.sh "$BASEDIR"
  $BASEDIR/scripts/install_varnish_deb.sh "$BASEDIR"
fi


if grep -i amazon /etc/os-release; then
  echo "Wait for cloud-init to complete"
  sudo cloud-init status --wait
  echo "Cloud init completed"
  $BASEDIR/scripts/install_base_amzn.sh
  $BASEDIR/scripts/install_nginx_amzn.sh "$BASEDIR"
  $BASEDIR/scripts/install_varnish_amzn.sh "$BASEDIR"
fi
