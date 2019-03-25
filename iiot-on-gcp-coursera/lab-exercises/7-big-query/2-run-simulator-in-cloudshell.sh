#! /bin/bash

export PROJECT_ID=$(gcloud config get-value project)

#
#
# simulate events
# re-install google cloud pubsub library used by the simulator
# python scripts
sudo pip uninstall google-cloud-pubsub
sudo pip uninstall google-cloud
sudo pip install google-cloud
sudo pip install google-cloud-pubsub


# if not in cloudshell, will need a service account
#
# generate the sample credential can be generated using
# "Create Service Account Key" page from here
# https://cloud.google.com/docs/authentication/getting-started
# gcloud iam service-accounts create service-account-sample
# gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:service-account-sample@$PROJECT_ID.iam.gserviceaccount.com" --role "roles/owner"
# gcloud iam service-accounts keys create /home/acahyadi/sample-credentials.json --iam-account service-account-sample@$PROJECT_ID.iam.gserviceaccount.com
# export GOOGLE_APPLICATION_CREDENTIALS='/home/acahyadi/sample-credentials.json'


#
#
# start simulator
git clone https://github.com/cagamboa123/sensor-sim.git
cd sensor-sim
python sendData.py -p $PROJECT_ID -t device-events
