#! /bin/bash 

# this is run on the iot-device-simulator VM 

sudo apt-get remove google-cloud-sdk -y
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

