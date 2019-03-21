#! /bin/bash

curl https://sdk.cloud.google.com > tmp_installer.sh 
export CLOUDSDK_PYTHON=/usr/bin/python2.7
chmod +x tmp_installer.sh 
./tmp_installer.sh 
rm tmp_installer.sh 
exec -l $SHELL

