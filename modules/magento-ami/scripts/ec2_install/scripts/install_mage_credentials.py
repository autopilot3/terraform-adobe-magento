#!/usr/bin/python3
# pylint: disable=bare-except,consider-using-f-string,missing-module-docstring,invalid-name,line-too-long

import os
import boto3
import json

REGION = os.environ.get('REGION')

session = boto3.Session(region_name=REGION)
ssm = session.client('ssm')

ssm_path_prefix="/"

with open('/tmp/ec2_install/scripts/ssm.json') as ssm_file:
  ssm_config = json.load(ssm_file)
  ssm_path_prefix = ssm_config['ssm_path_prefix']

try:
  mage_composer_username = ssm.get_parameter(f"{ssm_path_prefix}mage_composer_username", WithDecryption=True)
except:
  print("mage_composer_username: NotFound")

try:
  mage_composer_password = ssm.get_parameter(f"{ssm_path_prefix}mage_composer_password", WithDecryption=True)
except:
  print("mage_composer_password: NotFound")


auth_json = {
    'http-basic': {
        'repo.magento.com': {
            'username' : mage_composer_username,
            'password' : mage_composer_password
        }
    }
}

with open("/tmp/ec2_install/configs/auth.json", "w") as file:
    json.dump(auth_json, file)


print("wrote auth.json")
