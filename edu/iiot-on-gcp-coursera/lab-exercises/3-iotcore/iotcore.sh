#! /bin/bash 

export CLOUDSDK_PYTHON=/usr/bin/python2.7
gcloud init

export PROJECT_ID=$(gcloud config get-value project)
cp sample_cert.pem ~/sample_cert.pem

# create a topic and subscription 
gcloud pubsub topics create device-data
gcloud pubsub subscriptions create --topic device-data device-data-sub

# create a registry 
gcloud iot registries create deviceReg \
    --project=$PROJECT_ID \
    --region=us-central1 \
    --event-notification-config=topic=projects/$PROJECT_ID/topics/device-data \
    --state-pubsub-topic=projects/$PROJECT_ID/topics/device-data

# create the device 
gcloud iot devices create device1 \
    --project=$PROJECT_ID \
    --region=us-central1 \
    --registry=deviceReg \
    --public-key path=/home/ec2-user/sample_cert.pem,type=rs256_x509        