#! /bin/bash 

export CLOUDSDK_PYTHON=/usr/bin/python2.7
gcloud init

export PROJECT_ID=$(gcloud config get-value project)

gcloud pubsub topics create device-events 

gsutil mb -l us-central1 gs://$PROJECT_ID/

# simulate events 
# re-install google cloud pubsub library used by the simulator 
# python scripts 
sudo pip uninstall google-cloud-pubsub
sudo pip uninstall google-cloud
sudo pip install google-cloud
sudo pip install google-cloud-pubsub

# generate the sample credential can be generated using 
# "Create Service Account Key" page from here 
# https://cloud.google.com/docs/authentication/getting-started
export GOOGLE_APPLICATION_CREDENTIALS='sample-credentials.json'

git clone https://github.com/cagamboa123/sensor-sim.git
mv sensor-sim /home/ec2-user
cd /home/ec2-user/sensor-sim
python sendData.py -p $PROJECT_ID -t device-events
