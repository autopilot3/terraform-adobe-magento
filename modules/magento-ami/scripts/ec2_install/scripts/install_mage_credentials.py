#!/usr/bin/python3
# pylint: disable=bare-except,consider-using-f-string,missing-module-docstring,invalid-name,line-too-long

import os
import boto3
import json

REGION = os.environ.get('REGION') if os.environ.get(
    'REGION') else 'ap-southeast-2'

session = boto3.Session(region_name=REGION)
ssm = session.client('ssm')

ssm_path_prefix="/"

with open('/tmp/ec2_install/scripts/ssm.json') as ssm_file:
  ssm_config = json.load(ssm_file)
  ssm_path_prefix = ssm_config['ssm_path_prefix']

try:
    mage_composer_username = ssm.get_parameter(
        Name=f"{ssm_path_prefix}mage_composer_username", WithDecryption=True)
except Exception as e:
    print(
        f"mage_composer_username: NotFound {ssm_path_prefix}mage_composer_username", e)

try:
    mage_composer_password = ssm.get_parameter(
        Name=f"{ssm_path_prefix}mage_composer_password", WithDecryption=True)
except Exception as e:
    print("mage_composer_password: NotFound", e)


auth_json = {
    'http-basic': {
        'repo.magento.com': {
            'username': mage_composer_username['Parameter']['Value'],
            'password': mage_composer_password['Parameter']['Value']
        }
    }
}

with open("/tmp/ec2_install/configs/auth.json", "w+") as file:
    json.dump(auth_json, file)


print("wrote auth.json")
