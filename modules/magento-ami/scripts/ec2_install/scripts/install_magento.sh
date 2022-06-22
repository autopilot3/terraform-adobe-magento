#!/bin/bash
BASEDIR=$1

sudo mkdir -p /var/www/html/magento
sudo chown -R magento. /var/www/html
mkdir -p /home/magento/.config/composer/
sudo mv "$BASEDIR"/configs/auth.json /home/magento/.config/composer/
sudo chown -R magento. /home/magento/.config/
cd /home/magento
MAGENTO_RELEASE=$(jq -r ".release" <"$BASEDIR"/scripts/magento-composer-config.json)
sudo -u magento composer create-project --repository-url=https://repo.magento.com/ "$MAGENTO_RELEASE" /var/www/html/magento -n
