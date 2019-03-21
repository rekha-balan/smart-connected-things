#! /bin/bash 

gcloud init
gcloud components update
gcloud components install beta
sudo apt-get update
sudo apt-get install python-pip openssl git -y
sudo pip install pyjwt paho-mqtt cryptography

git clone http://github.com/GoogleCloudPlatform/training-data-analyst

export PROJECT_ID==$(gcloud config get-value project)
export MY_REGION=us-central1


mv training-data-analyst $HOME
cd $HOME/training-data-analyst/quests/iotlab/
openssl req -x509 -newkey rsa:2048 -keyout rsa_private.pem \
    -nodes -out rsa_cert.pem -subj "/CN=unused"


read -p "Go back to 1-setup.sh - preparation is completed"
    
cat rsa_cert.pem 
read -p "Copy the RSA key to register this IOT device"

cd $HOME/training-data-analyst/quests/iotlab/

wget https://pki.google.com/roots.pem
